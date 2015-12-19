//
//  PlayingCardView.m
//  Project4
//
//  Created by Glenn Axworthy on 9/29/15.
//  Copyright © 2015 Glenn Axworthy. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()

@property (nonatomic) NSObject *tapTarget;
@property (nonatomic) SEL tapAction;

@end

@implementation PlayingCardView

@synthesize scaleFactor = _scaleFactor;

- (void) awakeFromNib
{
    [self initView];
}

- (void) initView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.opaque = NO;
    self.enabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initView];
    return self;
}

- (CGFloat)scaleFactor
{
    if (_scaleFactor == 0)
        _scaleFactor = 0.9; // default

    return _scaleFactor;
}

- (void) setCard:(PlayingCard *)card
{
    _card = card;
    if (self.faceUp)
        [self setNeedsDisplay];
}

- (void) setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void) setScaleFactor:(CGFloat)scaleFactor
{
    _scaleFactor = scaleFactor;
    [self setNeedsDisplay];
}

- (void)setTapTarget:(id)target action:(SEL)action
{
    self.tapTarget = target;
    self.tapAction = action;
}

- (void) tapGesture:(UITapGestureRecognizer *)sender
{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    if (self.enabled)
        [self.tapTarget performSelector:self.tapAction withObject:self];

#pragma clang diagnostic pop

}

#define CORNER_FONT_HEIGHT 180
#define CORNER_RADIUS 12

- (CGFloat)cornerScale { return self.bounds.size.height / CORNER_FONT_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScale]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [path addClip];

    [[UIColor whiteColor] setFill];
    [path fill];

    [[UIColor blackColor] setStroke];
    [path stroke];

    if (self.card)
    {
        NSMutableString *rankSuit = [NSMutableString stringWithString:self.card.contents];

        if (self.faceUp)
        {
            CGFloat scaledWidth = self.bounds.size.width * self.scaleFactor;
            CGFloat scaledHeight = self. bounds.size.height * self.scaleFactor;
            CGRect faceRect = CGRectInset(self.bounds, (self.bounds.size.width - scaledWidth) / 2, (self.bounds.size.height - scaledHeight) / 2);

            if (self.card.rank > 10)
            {
                // draw face card image

                UIImage *faceImage = [UIImage imageNamed:rankSuit];
                [faceImage drawInRect:faceRect];
            }

            // build rank/suit attributed text

            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.alignment = NSTextAlignmentCenter;
            UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            font = [font fontWithSize:font.pointSize * [self cornerScale]];
            NSDictionary *attributes = @{NSFontAttributeName : font,
                                         NSParagraphStyleAttributeName : paragraph};

            [rankSuit insertString:@"\n" atIndex:[rankSuit length] - 1]; // before suit character
             NSAttributedString *text = [[NSAttributedString alloc] initWithString:rankSuit attributes:attributes];

            // draw topleft rank/suit

            CGRect cornerBounds;
            cornerBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
            cornerBounds.size = [text size];
            [text drawInRect:cornerBounds];

            // draw bottom right rank/suit

            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
            CGContextRotateCTM(context, M_PI);
            [text drawInRect:cornerBounds];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"cardback"];
            [image drawInRect:self.bounds];
        }
    }
}

@end
