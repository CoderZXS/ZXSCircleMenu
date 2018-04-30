//
//  ZXSCircleMenuLoader.h
//  ZXSCircleMenu(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//  圆圈

#import <UIKit/UIKit.h>

@interface ZXSCircleMenuLoader : UIView

- (instancetype)zxs_initWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth platform:(UIView *)platform color:(UIColor *)color;

- (void)zxs_fillAnimationWithDuration:(CGFloat)duration startAngle:(CGFloat)startAngle completion:(void(^)(void))completion;

- (void)zxs_hideAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void(^)(void))completion;

@end
