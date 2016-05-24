//
//  PPFound.h
//  TagflagCloudDemo
//
//  Created by Kity_Pei on 16/5/24.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#pragma mark -
#pragma mark --位置相关--
#pragma mark -
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
#define BAR_HEIGHT ((SYSTEMVERSION>=7.0) ? 64.0 : 44.0)
#define TopDistin(r) ((SYSTEMVERSION>=7.0) ?(20+(r)) : (r))

#pragma mark -
#pragma mark --颜色相关--
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#pragma mark -
#pragma mark --常用提示语--
#define KNOWIFI @"无网络链接，请检查您的网络"