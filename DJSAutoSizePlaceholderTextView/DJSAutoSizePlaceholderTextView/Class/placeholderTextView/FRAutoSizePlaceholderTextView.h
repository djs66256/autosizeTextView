//
//  FRAutoSizePlaceholderTextView.h
//  Fitrun
//
//  Created by duanjsh on 13-5-17.
//  Copyright (c) 2013年 Neusoft. All rights reserved.
//

#import "FRPlaceholderTextView.h"

// notification when height changed
extern NSString * const FRAutoSizePlaceholderTextView_sizeChangedNotification;

@interface FRAutoSizePlaceholderTextView : FRPlaceholderTextView

@property (copy, nonatomic) NSString *originalText;

- (CGFloat)heightWithText:(NSString *)text;

@end

