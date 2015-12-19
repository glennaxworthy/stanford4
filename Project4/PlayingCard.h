//
//  PlayingCard.h
//  Project2
//
//  Created by Glenn Axworthy on 8/26/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic) int rank;
@property (nonatomic) NSString *suit;

- (unsigned)matches:(NSArray *)cards;

+ (NSArray *)rankStrings;
+ (NSArray *)suitStrings;

@end
