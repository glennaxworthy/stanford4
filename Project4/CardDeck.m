//
//  CardDeck.m
//  Project4
//
//  Created by Glenn Axworthy on 8/25/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import "CardDeck.h"

@interface CardDeck()

@property (nonatomic) NSMutableArray *cards;

@end

@implementation CardDeck

- (void)addCard:(Card *)card
{
    [self addCard:card atTop:FALSE];
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop)
        [self.cards insertObject:card atIndex:0];
    else
        [self.cards addObject:card];
}

- (NSMutableArray *)cards
{
    if (!_cards)
        _cards = [[NSMutableArray alloc] init];

    return _cards;
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    int count = (int) [self.cards count];
    if (count)
    {
        int index = arc4random_uniform((int) count);
        randomCard = [self.cards objectAtIndex:index];
        [self.cards removeObject:randomCard];
    }

    return randomCard;
}

@end
