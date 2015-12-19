//
//  BogusCardGameViewController.m
//  Project4
//
//  Created by Glenn Axworthy on 9/24/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "BogusCardGameViewController.h"
#import "Grid.h"
#import "ResultsViewController.h"

@interface BogusCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSMutableArray *resultList;
@property (nonatomic) int score;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *tableView;

@end

@implementation BogusCardGameViewController

- (IBAction)cardTouched:(id)sender
{
    int index = (int) [self.cardButtons indexOfObject:sender];
    int points = index + 1;
    self.score += points;
    
    UIButton *button = sender;
    UniChar suit = [button.currentTitle characterAtIndex:0];
    NSString *result = [NSString stringWithFormat:@"Chose %C for %d points\n", suit, points];
    [self.resultList insertObject:result atIndex:0];
    
    [self updateView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsViewController *controller = segue.destinationViewController;
    controller.results = self.resultList;
}

- (IBAction)redealTouched:(id)sender
{
    self.score = 0;
    [self.resultList removeAllObjects];
    [self updateView];
}

- (NSMutableArray *)resultList
{
    if (!_resultList)
        _resultList = [[NSMutableArray alloc] init];

    return _resultList;
}

- (void)updateView
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.resultLabel.text = [self.resultList firstObject];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateView];
}

- (void)viewDidLayoutSubviews
{
    Grid *grid = [[Grid alloc] init];
    grid.cellAspectRatio = 0.8;
    grid.minimumNumberOfCells = 4;
    grid.size = self.tableView.bounds.size;

    for (UIButton *button in self.cardButtons)
    {
        int index = (int) [self.cardButtons indexOfObject:button];
        button.frame = [grid frameOfCellAtIndex:index];
    }
}

@end
