//
//  CardGame.h
//  Project4
//
//  Created by Glenn Axworthy on 9/2/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "CardDeck.h"

@interface CardGame : NSObject

@property (nonatomic, readonly) unsigned count;
@property (nonatomic) unsigned mode;
@property (nonatomic, readonly) int score;

- (Card *)cardAtIndex:(unsigned)index;
- (void)chooseCardAtIndex:(unsigned)index;
- (instancetype)initWithDeck:(CardDeck *)deck cards:(unsigned)count;
- (instancetype)resetWithDeck:(CardDeck *)deck cards:(unsigned)count;

@end
