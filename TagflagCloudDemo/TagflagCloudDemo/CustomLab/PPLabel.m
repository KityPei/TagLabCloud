//
//  PPLabel.m
//  TagflagCloudDemo
//
//  Created by Kity_Pei on 16/5/24.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "PPLabel.h"

@implementation PPLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)Tap:(UITapGestureRecognizer *)recognizer
{
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteBtnClick)];
    NSArray *array = [NSArray arrayWithObjects:delete, nil];
    [menu setMenuItems:array];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

- (void)deleteBtnClick
{
    if ([self.delegate respondsToSelector:@selector(deleteFromSupBy:)]) {
        [self.delegate deleteFromSupBy:self.tag];
    }
}

@end
