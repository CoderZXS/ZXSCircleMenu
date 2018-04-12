//
//  ZXSCircleMenuButton.h
//  ZXSCircleMenuLib(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXSCircleMenuButton : UIButton

@property (weak, nonatomic) UIView *container;

/**
 初始化其他按钮
 */
- (instancetype)zxs_initWithSize:(CGSize)size platform:(UIView *)platform distance:(CGFloat)distance angle:(CGFloat)angle;


- (void)zxs_rotatedZWithAngle:(CGFloat)angle animated:(BOOL)animated duration:(double)duration delay:(double)delay;


- (void)zxs_showAnimationWithDistance:(CGFloat)distance duration:(CGFloat)duration delay:(CGFloat)delay;


- (void)zxs_hideAnimationWithDistance:(CGFloat)distance duration:(CGFloat)duration delay:(CGFloat)delay;


- (void)zxs_rotationAnimationWithAngle:(CGFloat)angle duration:(CGFloat)duration;

@end
