//
//  ViewController.m
//  ZXSCircleMenuDemo
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//

#import "ViewController.h"
#import "ZXSCircleMenu.h"
#import "ZXSCircleMenuButton.h"

@interface ViewController ()<ZXSCircleMenuDelegate>

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (weak, nonatomic) IBOutlet ZXSCircleMenu *circlemenuButton;

@end

@implementation ViewController

- (NSMutableArray *)buttonArray {
    if (_buttonArray == nil) {
        
        _buttonArray = [NSMutableArray array];
        [_buttonArray addObject: @{@"icon":@"icon_home",@"color":[UIColor colorWithRed:0.19 green:0.57 blue:1.0 alpha:1.0]}];
        [_buttonArray addObject: @{@"icon":@"icon_search",@"color":[UIColor colorWithRed:0.22 green:0.74 blue:0 alpha:1.0]}];
        [_buttonArray addObject: @{@"icon":@"notifications-btn",@"color":[UIColor colorWithRed:0.96 green:0.23 blue:0.21 alpha:1.0]}];
        [_buttonArray addObject: @{@"icon":@"settings-btn",@"color":[UIColor colorWithRed:0.51 green:0.15 blue:1.0 alpha:1.0]}];
    }
    return _buttonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 纯代码add button
    ZXSCircleMenu *button = [[ZXSCircleMenu alloc] zxs_initWithFrame:CGRectMake(150, 200, 50, 50) normalIcon:@"icon_menu" selectedIcon:@"icon_close" buttonsCount:4 duration:4 distance:120];
    button.backgroundColor = [UIColor lightGrayColor];
    button.delegate = self;
    button.layer.cornerRadius = button.frame.size.width * 0.5;
    [self.view addSubview:button];
    
    
    // storyboard
    self.circlemenuButton.layer.cornerRadius = self.circlemenuButton.bounds.size.width * 0.5;
    self.circlemenuButton.delegate = self;
    self.circlemenuButton.buttonsCount = 4;
    
}

#pragma mark - ZXSCircleMenuDelegate
- (void)zxs_circleMenu:(ZXSCircleMenu *)circleMenu buttonWillDisplay:(ZXSCircleMenuButton *)button atIndex:(NSUInteger)index {
    
    NSLog(@"buttonWillDisplay:%zd",index);
    NSDictionary *tempdict = self.buttonArray[index];
    button.backgroundColor = (UIColor *)[tempdict valueForKey:@"color"];
    [button setImage:[UIImage imageNamed:[tempdict valueForKey:@"icon"]] forState:UIControlStateNormal];
    button.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}

- (void)zxs_circleMenu:(ZXSCircleMenu *)circleMenu buttonWillSelected:(ZXSCircleMenuButton *)button atIndex:(NSUInteger)index {
    NSLog(@"buttonWillSelected:%zd",index);
}

- (void)zxs_circleMenu:(ZXSCircleMenu *)circleMenu buttonDidSelected:(ZXSCircleMenuButton *)button atIndex:(NSUInteger)index {
    NSLog(@"buttonDidSelected:%zd",index);
}

- (void)zxs_menuCollapsed:(ZXSCircleMenu *)circleMenu {
    NSLog(@"zxs_menuCollapsed");
}


@end
