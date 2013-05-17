//
//  FRPlaceholderTextView.h
//  Fitrun
//
//  Created by duanjsh on 13-4-27.
//  Copyright (c) 2013年 Neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPlaceholderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
