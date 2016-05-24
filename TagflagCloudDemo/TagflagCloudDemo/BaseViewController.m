//
//  BaseViewController.m
//  TagflagCloudDemo
//
//  Created by Kity_Pei on 16/5/24.
//  Copyright © 2016年 Kity_Pei. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    float point_x;
    float point_y;
    UITextField *ppTextField;
}
@property (nonatomic,strong)UIScrollView *ppScroll;
@property (nonatomic,strong)NSMutableArray *arrayData;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTopBar:@"标签"];
    
    point_x = point_y = 10;
    _arrayData = [NSMutableArray array];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = YES;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    ppTextField = [[UITextField alloc] init];
    [ppTextField setBorderStyle:UITextBorderStyleNone];
    ppTextField.font = [UIFont systemFontOfSize:14.0f];
    [self.ppScroll addSubview:ppTextField];
    [ppTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        CGSize size = [PPUntil getSizeByString:@"输入标签，例如家人，同事" AndFontSize:14.0f WithBoundSize:CGSizeMake(MAXFLOAT, 30)];
        make.size.mas_equalTo(CGSizeMake(size.width, 30));
        make.top.mas_equalTo(self.ppScroll).with.offset(point_y);
        make.left.mas_equalTo(self.ppScroll).with.offset(point_x);
    }];
    
    [self setSomeView];
    
    [[ppTextField.rac_textSignal
      filter:^BOOL(id value){
          NSString*text = value;
          return text.length > 0;
      }]
     subscribeNext:^(id x){
         [ppTextField setBorderStyle:UITextBorderStyleRoundedRect];
         CGSize size = [PPUntil getSizeByString:ppTextField.text AndFontSize:14.0f WithBoundSize:CGSizeMake(MAXFLOAT, 30)];
         ppTextField.frame = CGRectMake(ppTextField.frame.origin.x, ppTextField.frame.origin.y, size.width+30, 30);
     }];
    
    
}

//懒加载 设置UIScrollView
- (UIScrollView *)ppScroll
{
    if (!_ppScroll) {
        _ppScroll = [[UIScrollView alloc] init];
        _ppScroll.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_ppScroll];
        [_ppScroll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, 100));
            make.top.mas_equalTo(self.view).with.offset(BAR_HEIGHT);
        }];
        
    }
    return _ppScroll;
}

/**
 手势事件
 点击屏幕使其结束编辑，设置标签
 */
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap
{
    if (![ppTextField.text isEqualToString:@""]) {
        [self.view endEditing:YES];
        [self.arrayData addObject:ppTextField.text];
        ppTextField.text = @"";
        [self setMyLayout];
    }
}

//设置标签布局
- (void)setMyLayout
{
    for (UIView *views in self.ppScroll.subviews) {
        if ([views isKindOfClass:[PPLabel class]]) {
            [views removeFromSuperview];
        }
    }
    point_y = point_x = 10;
    
    for (int i = 0; i< self.arrayData.count; i++) {
        CGSize size = [PPUntil getSizeByString:[self.arrayData objectAtIndex:i] AndFontSize:14.0f WithBoundSize:CGSizeMake(MAXFLOAT, 30)];
        if (size.width+20+point_x > DEVICE_WIDTH) {
            point_x = 10;
            point_y = point_y+40;
        }
        PPLabel *label = [[PPLabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderColor = [UIColor greenColor].CGColor;
        label.layer.cornerRadius = 15;
        label.layer.borderWidth = 1;
        label.tag = 100+i;
        label.delegate = self;
        label.textColor = [UIColor greenColor];
        [self.ppScroll addSubview:label];
        label.text = [self.arrayData objectAtIndex:i];
        label.frame = CGRectMake(point_x, point_y, size.width+20, 30);
        point_y = label.frame.origin.y;
        point_x = CGRectGetMaxX(label.frame)+10;
        
        if (CGRectGetMaxY(label.frame)+10>self.ppScroll.frame.size.height) {
            self.ppScroll.contentSize = CGSizeMake(DEVICE_WIDTH, CGRectGetMaxY(label.frame)+50);
            self.ppScroll.contentOffset = CGPointMake(0, self.ppScroll.contentSize.height-self.ppScroll.frame.size.height);
        }
    }
    [self setSomeView];
}

- (void)setSomeView
{
    if (_arrayData.count == 0) {
        ppTextField.placeholder = @"输入标签，例如家人，同事";
        self.ppScroll.contentSize = CGSizeMake(DEVICE_WIDTH, 100);
        [ppTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGSize size = [PPUntil getSizeByString:@"输入标签，例如家人，同事" AndFontSize:14.0f WithBoundSize:CGSizeMake(MAXFLOAT, 30)];
            make.size.mas_equalTo(CGSizeMake(size.width, 30));
            make.top.mas_equalTo(self.ppScroll).with.offset(point_y);
            make.left.mas_equalTo(self.ppScroll).with.offset(point_x);
        }];
    }
    else
    {
        self.ppScroll.showsHorizontalScrollIndicator = YES;
        ppTextField.placeholder = @"输入标签";
        [ppTextField setBorderStyle:UITextBorderStyleNone];
        [self.ppScroll addSubview:ppTextField];
        [ppTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGSize size = [PPUntil getSizeByString:@"输入标签" AndFontSize:14.0f WithBoundSize:CGSizeMake(MAXFLOAT, 30)];
            make.size.mas_equalTo(CGSizeMake(size.width, 30));
            if (size.width+point_x+10>DEVICE_WIDTH-1) {
                point_x = 10;
                point_y = 40+point_y;
            }
            make.top.mas_equalTo(self.ppScroll).with.offset(point_y);
            make.left.mas_equalTo(self.ppScroll).with.offset(point_x);
        }];
    }
}

- (void)deleteFromSupBy:(NSInteger)flag
{
    [_arrayData removeObjectAtIndex:(flag-100)];
    [self setMyLayout];
    
}

- (void)initTopBar:(NSString *)str
{
    self.navigationController.navigationBarHidden = YES;
    topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, BAR_HEIGHT)];
    topBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topBarView];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(topBarView.frame.size.width/2-95, TopDistin(0), 190, 44)];
    lblTitle.font = [UIFont systemFontOfSize:18];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = str;
    [topBarView addSubview:lblTitle];
    
    if (str.length < 1) {
        lblTitle.text = self.title;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
