//
//  CardGameViewController.h
//  Project2
//
//  Created by Glenn Axworthy on 8/25/15.
//  Copyright (c) 2015 Glenn Axworthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDeck.h"

#define CARDS_ON_TABLE 20

@interface CardGameViewController : UIViewController

- (CardDeck *)createDeck;

@end
