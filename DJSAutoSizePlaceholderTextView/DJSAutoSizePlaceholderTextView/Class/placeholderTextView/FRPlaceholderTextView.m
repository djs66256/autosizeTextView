//
//  FRPlaceholderTextView.m
//  Fitrun
//
//  Created by duanjsh on 13-4-27.
//  Copyright (c) 2013年 Neusoft. All rights reserved.
//

#import "FRPlaceholderTextView.h"

@interface FRPlaceholderTextView()

@property (retain, nonatomic) UILabel *placeholderLabel;
@property (retain, nonatomic) UIButton *clearTextBtn;

@end

@implementation FRPlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"";
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_placeholderLabel release];
    [_placeholderColor release];
    [_placeholder release];
    [_clearTextBtn release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder != placeholder) {
        [_placeholder release];
        _placeholder = [placeholder copy];
    }
    self.placeholderLabel.text = _placeholder;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // placeholder label
    if (_placeholderLabel == nil )
    {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,self.bounds.size.height -16)];
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = self.placeholderColor;
        _placeholderLabel.alpha = 0;
        _placeholderLabel.tag = 999;
        [self addSubview:_placeholderLabel];
    }
    
    _placeholderLabel.text = self.placeholder;
    [_placeholderLabel sizeToFit];
    [self sendSubviewToBack:_placeholderLabel];
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [_placeholderLabel setAlpha:1];
    }
    
    // clear button
    if (_clearTextBtn == nil) {
        self.clearTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearTextBtn addTarget:self action:@selector(clearTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_clearTextBtn setBackgroundImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
        [self addSubview:_clearTextBtn];
        _clearTextBtn.frame = CGRectMake(self.bounds.size.width - 24, self.bounds.size.height - 26, 19, 19);
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            _clearTextBtn.frame = CGRectMake(self.bounds.size.width - 24, self.bounds.size.height - 26, 19, 19);
        }];
    }
    
}

- (void)textChanged:(NSNotification *)notification
{
    if (notification.object == self) {
        if([[self placeholder] length] == 0)
        {
            return;
        }
        
        if([[self text] length] == 0)
        {
            [_placeholderLabel setAlpha:1];
        }
        else
        {
            [_placeholderLabel setAlpha:0];
        }
    }
}

- (IBAction)clearTextButtonClicked:(id)sender
{
    self.text = @"";
    [_placeholderLabel setAlpha:1];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}

@end
