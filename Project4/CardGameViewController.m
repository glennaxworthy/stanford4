//
//  CardGameViewController.m
//  Project2
//
//  Created by Glenn Axworthy on 8/25/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardGame.h"
#import "Grid.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "ResultsViewController.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) void (^animatorComplete)(void);
@property (strong, nonatomic) CardDeck *cardDeck;
@property (strong, nonatomic) CardGame *cardGame;
@property (strong, nonatomic) Grid *cardGrid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) NSMutableArray *chosenCards;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSMutableArray *resultList;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *tableView;

@end

@implementation CardGameViewController

- (UIDynamicAnimator *)animator
{
    if (!_animator)
    {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.tableView];
        _animator.delegate = self;
        self.animatorComplete = nil;
    }

    return _animator;
}

- (CardDeck *)cardDeck
{
    if (!_cardDeck)
        _cardDeck = [self createDeck];

    return _cardDeck;
}

- (CardGame *)cardGame
{
    if (!_cardGame)
    {
        unsigned views = (unsigned) [self.cardViews count];
        _cardGame = [[CardGame alloc] initWithDeck:self.cardDeck cards:views];
        [self resetCardViews];
    }

    return _cardGame;
}

- (Grid *)cardGrid
{
    if (!_cardGrid)
    {
        _cardGrid = [[Grid alloc] init];
        _cardGrid.cellAspectRatio = 0.8;
        _cardGrid.minimumNumberOfCells = CARDS_ON_TABLE;
    }

    CGSize size = self.tableView.bounds.size;
    _cardGrid.size = size;

    return _cardGrid;
}

- (IBAction)cardTouched:(id)sender
{
    int score = self.cardGame.score;
    unsigned index = (unsigned) [self.cardViews indexOfObject:sender];
    Card *card = [self.cardGame cardAtIndex:index];
    [self.cardGame chooseCardAtIndex:index];

    NSString *result = @"";
    int delta = self.cardGame.score - score;

    if (!card.chosen)
        [self.chosenCards removeObject:card];
    else
    {
        [self.chosenCards addObject:card];
        if ([self.chosenCards count] == 1)
            // first and only card chosen
            result = [NSString stringWithFormat:@"Chose %@ for %d points", card.contents, delta];
        else if (card.matched)
        {
            result = @"Matched ";

            for (Card *chosen in self.chosenCards)
                if (chosen.matched)
                    result = [NSString stringWithFormat:@"%@ %@", result, chosen.contents];

            result = [NSString stringWithFormat:@"%@ for %d points", result, delta];
            [self.chosenCards removeAllObjects];
        }
        else
        {
            // card mismatch
            result = @"Mismatched ";

            for (Card *chosen in self.chosenCards)
                result = [NSString stringWithFormat:@"%@ %@", result, chosen.contents];
        
            result = [NSString stringWithFormat:@"%@ for %d penalty", result, delta];
            [self.chosenCards removeAllObjects];
            [self.chosenCards addObject:card];
        }
    }

    [self.resultList insertObject:result atIndex:0];
    [self updateControllerView];
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews)
        _cardViews = [[NSMutableArray alloc] init];

    return _cardViews;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards)
        _chosenCards = [[NSMutableArray alloc] init];

    return _chosenCards;
}

- (CardDeck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.animator removeAllBehaviors];
    if (self.animatorComplete)
    {
        self.animatorComplete();
        self.animatorComplete = nil;
    }
}

- (void) dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
}

- (void) discardCardView:(PlayingCardView *)view;
{
    CGRect frame = view.frame;
    frame.origin.x = -frame.size.width - self.tableView.frame.origin.x;
    frame.origin.y = -frame.size.height - self.tableView.frame.origin.y;
    view.frame = frame;
    view.enabled = NO;
}

- (void) discardCardViews:(void (^)())complete
{
    NSMutableArray *discardViews = [[NSMutableArray alloc] init];
    for (PlayingCardView* view in self.cardViews)
        if (view.enabled)
            [discardViews addObject:view];

    if ([discardViews count] == 0)
        complete();
    else
    {
        __block int discardCount = 0;
        for (PlayingCardView *view in self.cardViews)
            [UIView transitionWithView:view
                              duration:1.0
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{ [self discardCardView:view]; }
                            completion:^(BOOL completed){
                                                            if (view.faceUp)
                                                                view.faceUp = NO;
                                                            if (++discardCount == [discardViews count])
                                                                complete();
                                                        }];
    }
}

- (void)layoutCardView:(PlayingCardView *)view cardGrid:(Grid *)grid
{
    if (view.enabled) // not discarded?
    {
        int index = (int)[self.cardViews indexOfObject:view];
        view.frame = [grid frameOfCellAtIndex:index];
    }
}

- (void)layoutCardViews:(Grid *)grid
{
    for (PlayingCardView *view in self.cardViews)
        [self layoutCardView:view cardGrid:grid];
}

- (void)newGame
{
    self.redealButton.enabled = NO;
    [self.chosenCards removeAllObjects];
    [self.resultList removeAllObjects];

    [self discardCardViews:^{ [self redealCardViews:^{
                                                        unsigned count = (unsigned) [self.cardViews count];
                                                        self.cardDeck = [self createDeck];
                                                        [self.cardGame resetWithDeck:self.cardDeck cards:count];
                                                        [self resetCardViews];
                                                        [self updateControllerView];
                                                        self.redealButton.enabled = YES;
                                                    }];
                            }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsViewController *controller = segue.destinationViewController;
    controller.results = self.resultList;
}

- (IBAction)redealTouched:(id)sender
{
    [self newGame];
}

- (void)redealCardViews:(void(^)())complete
{
    for (PlayingCardView *view in self.cardViews)
    {
        int index = (int)[self.cardViews indexOfObject:view];
        CGPoint center = [self.cardGrid centerOfCellAtIndex:index];
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:center];
        [self.animator addBehavior:snap];
    }

    self.animatorComplete = complete;
}

- (void)resetCardViews
{
    for (int index = 0; index < [self.cardViews count]; index++)
    {
        PlayingCardView *view = [self.cardViews objectAtIndex:index];
        view.card = (PlayingCard *)[self.cardGame cardAtIndex:index];
        view.enabled = YES;
        view.faceUp = NO;
    }
}

- (NSMutableArray *)resultList
{
    if (!_resultList)
        _resultList = [[NSMutableArray alloc] init];
    
    return _resultList;
}

- (void)updateControllerView
{
    NSMutableArray *flipViews = [[NSMutableArray alloc] init];
    NSMutableArray *discardViews = [[NSMutableArray alloc] init];
    for (PlayingCardView *view in self.cardViews)
    {
        Card *card = view.card;
        if (card.chosen != view.faceUp)
            [flipViews addObject:view];
        if (card.matched && view.enabled)
            [discardViews addObject:view];
    }

    if ([flipViews count])
    {
        __block int flipsComplete = 0;
        void (^flipComplete)(BOOL) = ^(BOOL completed)  {
                                                            if (++flipsComplete == [flipViews count])
                                                                for (PlayingCardView *view in discardViews)
                                                                    [UIView transitionWithView:view
                                                                                      duration:0.5
                                                                                       options:UIViewAnimationOptionCurveEaseIn
                                                                                    animations:^{ [self discardCardView:view]; }
                                                                                    completion:nil];
                                                        };

        
        for (PlayingCardView *view in flipViews)
        {
            [UIView transitionWithView:view
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                            view.faceUp = !view.faceUp;
                                        }
                            completion:flipComplete];
        }
    }

    self.resultLabel.text = [self.resultList firstObject];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.cardGame.score];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (int index = 0; index < CARDS_ON_TABLE; index++)
    {
        PlayingCardView *view = [[PlayingCardView alloc] initWithFrame:CGRectZero];
        [self.tableView addSubview:view];
        [self.cardViews addObject:view];
        [view setTapTarget:self action:@selector(cardTouched:)];
    }

    Grid *grid = self.cardGrid;
    [self layoutCardViews:grid];
    [self resetCardViews];
    [self updateControllerView];
}

- (void)viewDidLayoutSubviews
{
    Grid *grid = self.cardGrid;
    if (self.cardGrid.inputsAreValid)
        [self layoutCardViews:grid];
}

@end
