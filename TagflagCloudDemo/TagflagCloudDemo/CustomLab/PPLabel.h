//
//  PPLabel.h
//  TagflagCloudDemo
//
//  Created by Kity_Pei on 16/5/24.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPLabel : UILabel

@property (nonatomic,weak)id delegate;

@end

@protocol PPLabelDelegate <NSObject>

- (void)deleteFromSupBy:(NSInteger)flag;

@end
