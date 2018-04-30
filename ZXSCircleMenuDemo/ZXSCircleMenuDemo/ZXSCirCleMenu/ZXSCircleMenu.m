//
//  ZXSCircleMenu.m
//  ZXSCircleMenu(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//

#import "ZXSCircleMenu.h"
#import "ZXSCircleMenuButton.h"
#import "ZXSCircleMenuLoader.h"
#import "UIView+ZXSCircleMenu.h"

@interface ZXSCircleMenu()

@property (strong, nonatomic) NSMutableArray *buttons;
@property (weak, nonatomic) UIView *platform;                         // 平台view
@property (strong, nonatomic) UIImageView *customNormalIconView;
@property (strong, nonatomic) UIImageView *customSelectedIconView;
@property (assign, nonatomic) BOOL isBounceAnimating;                 //  反弹动画

@end

@implementation ZXSCircleMenu

/**
 初始化并返回一个圆形菜单对象。
  
   - 参数框架：指定圆形菜单在其超级视图的's坐标中的初始位置和大小的矩形。
   - 参数normalIcon：用于指定正常状态的图像。
   - 参数selectedIcon：用于指定选定状态的图像。
   - 参数buttonsCount：按钮的数量。
   - 参数持续时间：动画的持续时间（以秒为单位）。
   - 参数距离：中心按钮和子按钮之间的距离。
  
   - 返回：新创建的圆形菜单。
 */
- (instancetype)zxs_initWithFrame:(CGRect)frame normalIcon:(NSString *)normalIcon selectedIcon:(NSString *)selectedIcon buttonsCount:(NSUInteger)buttonsCount duration:(CGFloat)duration distance:(CGFloat)distance {
    if (self == [super initWithFrame:frame]) {
        
        if (nil != normalIcon) {
            [self setImage:[UIImage imageNamed:normalIcon] forState:UIControlStateNormal];
        }
        
        if (nil != selectedIcon) {
            [self setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
        }
        
        self.buttonsCount = (buttonsCount != 0) ? buttonsCount : 3;
        self.duration = (duration != 0) ? duration : 2;
        self.distance = (distance != 0) ? distance : 100;
        self.showDelay = 0;
        self.startAngle = 0;
        self.endAngle = 360;
        self.subButtonsRadius = frame.size.width * 0.5;
        self.isBounceAnimating = NO;
        self.buttons = [NSMutableArray array];
        
        [self zxs_commonInit];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        self.buttonsCount = 3;
        self.duration = 2;
        self.distance = 100;
        self.showDelay = 0;
        self.startAngle = 0;
        self.endAngle = 360;
        self.subButtonsRadius = self.frame.size.width * 0.5;
        self.isBounceAnimating = NO;
        self.buttons = [NSMutableArray array];
        
        [self zxs_commonInit];
    }
    
    return self;
}


- (void)zxs_commonInit {
    
    [self addTarget:self action:@selector(zxs_onTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.customNormalIconView = [self zxs_addCustomImageViewWithState:UIControlStateNormal];
    
    self.customSelectedIconView = [self zxs_addCustomImageViewWithState:UIControlStateSelected];
    if (self.customSelectedIconView != nil) {
        self.customSelectedIconView.alpha = 0;
    }
    
    [self setImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
}


#pragma mark - methods
/**
 隐藏按钮
  
   - 参数持续时间：动画的持续时间（以秒为单位）。
   - 参数hideDelay：延迟时间，以秒为单位。
 */
- (void)zxs_hideButtonsWithDuration:(CGFloat)duration hideDelay:(CGFloat)hideDelay {
    
    if (self.buttons == nil || self.buttons.count == 0) {
        return;
    }
    
    [self zxs_buttonsAnimationIsShow:NO duration:duration hideDelay:hideDelay];

    [self zxs_tapBounceAnimationWithDuration:0.5 completion:nil];
    [self zxs_tapRotatedAnimationWithDuration:0.3 isSelected:NO];
}


/**
 检查是否显示子按钮
 */
- (BOOL)zxs_buttonsIsShown {
    
    if (self.buttons == nil || self.buttons.count == 0) {
        return NO;
    }
    
    for (ZXSCircleMenuButton *button in self.buttons) {
        if (button.alpha == 0) {
            return NO;
        }
    }
    
    return YES;
}


- (void)zxs_removeFromSuperview {
    
    // 移除平台view
    if (nil != self.platform && nil != self.platform.superview) {
        [self.platform removeFromSuperview];
    }
    
    // 移除菜单按钮
    [super removeFromSuperview];
}


#pragma mark - create

/**
 创建子按钮数组
 */
- (NSArray *)zxs_createButtonsWithPlatform:(UIView *)platform {
    
    NSMutableArray *buttons = [NSMutableArray array];
    CGFloat step = [self zxs_getArcStep];
    for (NSInteger i = 0; i < self.buttonsCount; i++) {
        
        CGFloat angle = self.startAngle + i * step;
        CGFloat distance = self.bounds.size.height * 0.5;
        CGSize buttonSize;
        if (self.subButtonsRadius) {
            buttonSize = CGSizeMake(self.subButtonsRadius * 2, self.subButtonsRadius * 2);
        } else {
            buttonSize = self.bounds.size;
        }
        
        ZXSCircleMenuButton *button = [[ZXSCircleMenuButton alloc] zxs_initWithSize:buttonSize platform:platform distance:distance angle:angle];
        button.tag = i;
        [button addTarget:self action:@selector(zxs_buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        button.alpha = 0;
        [buttons addObject:button];
    }
    
    return buttons;
}



/**
 根据按钮状态创建对应状态下的UIImageView
 */
- (UIImageView *)zxs_addCustomImageViewWithState:(UIControlState)state {
    
    UIImage *image = [self imageForState:state];
    if (image == nil) {
        return nil;
    }
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:image];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.contentMode = UIViewContentModeCenter;
    [iconView setUserInteractionEnabled:NO];
    [self addSubview:iconView];
    
    // added constraints
    [iconView addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:self.bounds.size.height]];
    
    [iconView addConstraint:[NSLayoutConstraint constraintWithItem:iconView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:self.bounds.size.width]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:iconView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
    return iconView;
}



/**
 创建平台view，上面用于存放子按钮
 */
- (UIView *)zxs_createPlatform {
    
    UIView *platform = [[UIView alloc] initWithFrame:CGRectZero];
    platform.backgroundColor = [UIColor clearColor];
    platform.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.superview != nil) {
        [self.superview insertSubview:platform belowSubview:self];
    }
    
    // constraints
    [platform addConstraint:[NSLayoutConstraint constraintWithItem:platform attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(self.distance * 2.0)]];
    
    [platform addConstraint:[NSLayoutConstraint constraintWithItem:platform attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(self.distance * 2.0)]];
    
    if (self.superview != nil) {
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:platform attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:platform attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    return platform;
}


/**
 检索按钮之间的增量长度。 如果弧长是360度或更多，则增量将均匀分布在整个圆周上。 如果弧长小于360度，最后一个按钮将会是放在endAngle上。
 */
- (CGFloat)zxs_getArcStep {
    
    CGFloat arcLength = self.endAngle - self.startAngle;
    NSUInteger stepCount = self.buttonsCount;
    if (arcLength < 360) {
        stepCount -= 1;
    } else if (arcLength > 360) {
        arcLength = 360;
    }
    
    return arcLength / (stepCount * 1.0);
}


#pragma mark - 事件方法

/**
 菜单按钮点击触发方法
 */
- (void)zxs_onTap {
    
    // 过滤反弹动画中按钮点击
    if (self.isBounceAnimating != NO) {
        return;
    }
    self.isBounceAnimating = true;
    
    // 检查当前是否有条件允许显示按钮
    if ([self zxs_buttonsIsShown] == NO) {
        
        UIView *platform = [self zxs_createPlatform];
        // 清空先前添加的按钮,然后添加新按钮
        [self.buttons removeAllObjects];
        [self.buttons addObjectsFromArray:[self zxs_createButtonsWithPlatform:platform]];
        self.platform = platform;
    }
    
    
    BOOL isShow = ![self zxs_buttonsIsShown];
    CGFloat duration = isShow ? 0.5 : 0.2;

    [self zxs_buttonsAnimationIsShow:isShow duration:duration hideDelay:0.0];
    
    __weak typeof(self) weakSelf = self;
    [self zxs_tapBounceAnimationWithDuration:0.5 completion:^(BOOL isYes) {
        if (weakSelf != nil) {
            weakSelf.isBounceAnimating = NO;
        }
        
    }];
    [self zxs_tapRotatedAnimationWithDuration:0.3 isSelected:isShow];
}



/**
 点击其他按钮触发方法
 */
- (void)zxs_buttonHandler:(ZXSCircleMenuButton *)sender {
    
    if (nil == self.platform) {
        return;
    }
    
    //判断代理是否存在，且是否实现当前方法
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(zxs_circleMenu:buttonWillSelected:atIndex:)]) {
            [self.delegate zxs_circleMenu:self buttonWillSelected:sender atIndex:sender.tag];
        }
    }
    
    CGFloat strokeWidth;
    if (self.subButtonsRadius) {
        strokeWidth = self.subButtonsRadius * 2;
    } else {
        strokeWidth = self.bounds.size.height;
    }
    
    ZXSCircleMenuLoader *circle = [[ZXSCircleMenuLoader alloc] zxs_initWithRadius:self.distance strokeWidth:strokeWidth platform:self.platform color:sender.backgroundColor];
    
    if (sender.container != nil) { // rotation animation
        [sender zxs_rotationAnimationWithAngle:(sender.container.zxs_angleZ + 360) duration:self.duration];
        if (sender.container.superview != nil) {
           [sender.container.superview bringSubviewToFront:sender.container];
        }
    }
    
    if (self.buttons != nil && self.buttons.count != 0) {
        CGFloat step = [self zxs_getArcStep];
        __weak typeof(self) weakSelf = self;
        [circle zxs_fillAnimationWithDuration:self.duration startAngle:(-90 + self.startAngle + step * sender.tag) completion:^{
            for (ZXSCircleMenuButton *button in weakSelf.buttons) {
                button.alpha = 0;
            }
        }];
       
        [circle zxs_hideAnimationWithDuration:0.5 delay:self.duration completion:^{
            if (weakSelf.platform.superview != nil) {
                [weakSelf.platform removeFromSuperview];
            }
        }];
        

        [self zxs_hideCenterButtonWithDuration:0.3 delay:0.0];
        [self zxs_showCenterButtonWithDuration:0.525 delay:self.duration];
        
        NSLog(@"dispatch_after前");
        if (self.customNormalIconView != nil && self.customSelectedIconView != nil) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"dispatch_after");
                // 判断代理是否存在，且是否实现当前方法
                if (self.delegate != nil) {
                    if ([self.delegate respondsToSelector:@selector(zxs_circleMenu:buttonDidSelected:atIndex:)]) {
                        [self.delegate zxs_circleMenu:self buttonDidSelected:sender atIndex:sender.tag];
                    }
                }
            });
        }
        NSLog(@"dispatch_after后");
    }
}

#pragma mark - animations
- (void)zxs_buttonsAnimationIsShow:(BOOL)isShow duration:(CGFloat)duration hideDelay:(CGFloat)hideDelay {
    
    if (self.buttons == nil || self.buttons.count == 0) {
        return;
    }
    
    CGFloat step = [self zxs_getArcStep];
    for (NSUInteger i = 0; i < self.buttonsCount; i++) {
        ZXSCircleMenuButton *button = self.buttons[i];
        if (button == nil) {
            continue;
        }
        
        if (isShow == YES) {
            //判断代理是否存在，且是否实现当前方法
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(zxs_circleMenu:buttonWillDisplay:atIndex:)]) {
                    [self.delegate zxs_circleMenu:self buttonWillDisplay:button atIndex:i];
                }
            }
            
            CGFloat angle = self.startAngle + i * step;
            [button zxs_rotatedZWithAngle:angle animated:NO duration:0 delay:i * self.showDelay];
            [button zxs_showAnimationWithDistance:self.distance duration:duration delay:i * self.showDelay];
        } else {
            [button zxs_hideAnimationWithDistance:(self.bounds.size.height * 0.5) duration:duration delay:hideDelay];
        }
    }

    if (isShow == NO) { // hide buttons and remove
        [self.buttons removeAllObjects];
        self.buttons = nil;
        
        //判断代理是否存在，且是否实现当前方法
        if (self.delegate != nil) {
            if ([self.delegate respondsToSelector:@selector(zxs_menuCollapsed:)]) {
                [self.delegate zxs_menuCollapsed:self];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.platform.superview != nil) {
                [self.platform removeFromSuperview];
            }
        });
    }
}



- (void)zxs_tapBounceAnimationWithDuration:(CGFloat)duration completion:(void(^)(BOOL isYes))completion {
    
    self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:completion];
}


- (void)zxs_tapRotatedAnimationWithDuration:(CGFloat)duration isSelected:(BOOL)isSelected {
    
    void (^addAnimations)(UIImageView *, BOOL) = ^(UIImageView *view, BOOL isShow) {
        CGFloat toAngle = 180.0;
        CGFloat fromAngle = 0;
        CGFloat fromScale = 1.0;
        CGFloat toScale = 0.2;
        NSUInteger fromOpacity = 1;
        NSUInteger toOpacity = 0;
        if (isShow == YES) {
            toAngle = 0;
            fromAngle = -180;
            fromScale = 0.2;
            toScale = 1.0;
            fromOpacity = 0;
            toOpacity = 1;
        }
        
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotation.duration = duration;
        rotation.toValue = @(toAngle * M_PI / 180.0);
        rotation.fromValue = @(fromAngle * M_PI / 180.0);
        rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fade.duration = duration;
        fade.fromValue = @(fromOpacity);
        fade.toValue = @(toOpacity);
        fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        fade.fillMode = kCAFillModeForwards;
        [fade setRemovedOnCompletion:NO];
        
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.duration = duration;
        scale.toValue = @(toScale);
        scale.fromValue = @(fromScale);
        scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        [view.layer addAnimation:rotation forKey:nil];
        [view.layer addAnimation:fade forKey:nil];
        [view.layer addAnimation:scale forKey:nil];
    };
    
    if (self.customNormalIconView != nil) {
        addAnimations(self.customNormalIconView, !isSelected);
    }
  
    if (self.customSelectedIconView != nil) {
        addAnimations(self.customSelectedIconView, isSelected);
    }
    
    self.selected = isSelected;
    self.alpha = isSelected ? 0.3 : 1;
}


/**
 隐藏菜单按钮动画
 */
- (void)zxs_hideCenterButtonWithDuration:(CGFloat)duration delay:(CGFloat)delay {
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:nil];
}


/**
显示菜单按钮动画
*/
- (void)zxs_showCenterButtonWithDuration:(CGFloat)duration delay:(CGFloat)delay {
    
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.78 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:nil];
    
    CASpringAnimation *rotation = [CASpringAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = 1.5;
    rotation.toValue = @0;
    rotation.fromValue = @(-180 * M_PI / 180.0);
    rotation.damping = 10;
    rotation.initialVelocity = 0;
    rotation.beginTime = CACurrentMediaTime() + delay;
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 0.01;
    fade.toValue = @0;
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.fillMode = kCAFillModeForwards;
    fade.removedOnCompletion = NO;
    fade.beginTime = CACurrentMediaTime() + delay;
    
    CABasicAnimation *show = [CABasicAnimation animationWithKeyPath:@"opacity"];
    show.duration = duration;
    show.toValue = @1;
    show.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    show.fillMode = kCAFillModeForwards;
    show.removedOnCompletion = NO;
    show.beginTime = CACurrentMediaTime() + delay;
    
    [self.customNormalIconView.layer addAnimation:rotation forKey:nil];
    [self.customNormalIconView.layer addAnimation:show forKey:nil];
    [self.customSelectedIconView.layer addAnimation:fade forKey:nil];
}

@end
