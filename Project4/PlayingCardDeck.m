//
//  PlayingCardDeck.m
//  Project2
//
//  Created by Glenn Axworthy on 8/25/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        for (int rank = 1; rank < [[PlayingCard rankStrings] count]; rank++)
            for (NSString *suit in [PlayingCard suitStrings])
            {
                PlayingCard *card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
    }

    return self;
}

@end
