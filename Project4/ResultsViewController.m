//
//  ResultsViewController.m
//  Project2
//
//  Created by Glenn Axworthy on 9/26/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *resultsText;

@end

@implementation ResultsViewController

- (void)setResults:(NSArray *)results
{
    _results = results;
}

- (void)viewDidLoad
{
    NSMutableString *text = [[NSMutableString alloc] init];
    for (NSString *result in self.results)
    {
        [text appendString:result];
        if (result != [self.results lastObject])
            [text appendString:@"\n"];
    }

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *attributes = @{   NSFontAttributeName : [UIFont preferredFontForTextStyle : UIFontTextStyleCaption1],
                                    NSForegroundColorAttributeName : [UIColor redColor],
                                    NSStrokeWidthAttributeName : @(-3)};

    [string addAttributes:attributes range:NSMakeRange(0, [string length])];
    self.resultsText.attributedText = string;
}

@end
