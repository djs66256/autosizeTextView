//
//  FRAutoSizePlaceholderTextView.m
//  Fitrun
//
//  Created by duanjsh on 13-5-17.
//  Copyright (c) 2013年 Neusoft. All rights reserved.
//

#import "FRAutoSizePlaceholderTextView.h"

NSString * const FRAutoSizePlaceholderTextView_sizeChangedNotification = @"FR_ASPHTV_SIZECHANGED";

@implementation FRAutoSizePlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [_originalText release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self autoChangeViewSize];
}

- (CGFloat)heightWithText:(NSString *)text
{
    CGSize textSize = [self textSizeWithText:text == nil ? @"" : text
                                        font:self.font
                          constrainedToWidth:self.frame.size.width];
    
    return self.frame.size.height + textSize.height - self.frame.size.height + 15;
}

- (CGSize)textSizeWithText:(NSString *)text font:(UIFont *)font constrainedToWidth:(float)width
{
    return [[text stringByAppendingString:@"++"] sizeWithFont:font
                                            constrainedToSize:CGSizeMake(width - 20, 10000)
                                                lineBreakMode:UILineBreakModeWordWrap];
}

- (void)textChanged:(NSNotification *)notification
{
    [super textChanged:notification];
    
    if (notification.object == self) {
        [self autoChangeViewSize];
    }
}

- (void)autoChangeViewSize
{
    CGSize originalSize = [self textSizeWithText:self.originalText
                                            font:self.font
                              constrainedToWidth:self.frame.size.width];
    CGSize newSize = [self textSizeWithText:self.text
                                       font:self.font
                         constrainedToWidth:self.frame.size.width];
    
    self.originalText = self.text;
    
    __block CGRect newFrame = CGRectMake(self.frame.origin.x,
                                         self.frame.origin.y,
                                         self.frame.size.width,
                                         newSize.height + 15);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = newFrame;
    }];
    
    if (originalSize.height != newSize.height) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FRAutoSizePlaceholderTextView_sizeChangedNotification object:self];
    }
}

@end
