//
//  Card.h
//  Project4
//
//  Created by Glenn Axworthy on 8/25/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents;
@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;

- (unsigned)matches:(NSArray *)cards;

@end
