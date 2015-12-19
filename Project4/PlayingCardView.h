//
//  PlayingCardView.h
//  Project4
//
//  Created by Glenn Axworthy on 9/29/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCard.h"

@interface PlayingCardView : UIView

@property (nonatomic) PlayingCard *card;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat scaleFactor;

- (void)setTapTarget:(id)target action:(SEL)action;

@end
