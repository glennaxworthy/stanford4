//
//  CardGame.m
//  Project2
//
//  Created by Glenn Axworthy on 9/2/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import "CardGame.h"

@interface CardGame()

@property (nonatomic, readwrite) int score;
@property (nonatomic, strong) NSMutableArray *cards;

@end

@implementation CardGame

- (Card *)cardAtIndex:(unsigned int)index
{
    return [self.cards objectAtIndex:index];
}

- (void)chooseCardAtIndex:(unsigned int)index
{
    static int COST_TO_CHOOSE = 1;
    static int MATCH_BONUS = 4;
    static int MISMATCH_PENALTY = 2;

    // mode > 2 unimplemented - incomprehensible

    Card *card = [self cardAtIndex:index];
    if (!card.matched)
    {
        if (card.chosen)
            card.chosen = NO;
        else
        {
            for (Card *other in self.cards)
            {
                if (other.chosen && !other.matched)
                {
                    unsigned score = [card matches:@[other]];
                    if (score == 0)
                    {
                        self.score -= MISMATCH_PENALTY;
                        other.chosen = NO;
                    }
                    else
                    {
                        self.score += score * MATCH_BONUS;
                        card.matched = YES;
                        other.matched = YES;
                    }

                    break; // match 2 cards only
                }
            }

            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        }
    }
}

- (unsigned)count
{
    return self.cards ? (unsigned)[self.cards count] : 0;
}

- (instancetype)initCards:(CardDeck *)deck cards:(unsigned)count
{
    self.cards = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++)
    {
        Card *card = [deck drawRandomCard];
        if (!card)
            return nil;

        [self.cards addObject:card];
    }

    return self;
}

- (instancetype)initWithDeck:(CardDeck *)deck cards:(unsigned)count
{
    self = [super init];
    if (self)
    {
        self = [self initCards:deck cards:count];
        self.mode = 2;
    }

    return self;
}

- (instancetype)resetWithDeck:(CardDeck *)deck cards:(unsigned)count
{
    self.score = 0;
    return [self initWithDeck:deck cards:count];
}

@end
