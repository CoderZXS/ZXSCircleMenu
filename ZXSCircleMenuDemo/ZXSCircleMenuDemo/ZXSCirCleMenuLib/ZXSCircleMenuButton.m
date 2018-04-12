//
//  ZXSCircleMenuButton.m
//  ZXSCircleMenuLib(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//

#import "ZXSCircleMenuButton.h"

@interface ZXSCircleMenuButton()

@end

@implementation ZXSCircleMenuButton

/**
 初始化其他按钮
 */
- (instancetype)zxs_initWithSize:(CGSize)size platform:(UIView *)platform distance:(CGFloat)distance angle:(CGFloat)angle {
    if (self == [super initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.79 green:0.24 blue:0.27 alpha:1.0];
        self.layer.cornerRadius = size.height * 0.5;
        
        UIView *aContainer = [self zxs_createContainerWithSize:CGSizeMake(size.width, distance) platform:platform];
        
        // hack view for rotate
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:self];
        // ...
        
        [aContainer addSubview:view];
        self.container = aContainer;
        
        view.layer.transform = CATransform3DMakeRotation((-angle * M_PI / 180.0), 0.0, 0.0, 1.0);

        [self zxs_rotatedZWithAngle:angle animated:NO duration:0.0 delay:0.0];
    }
    
    return self;
}


/**
 创建包裹其他按钮的containerview
 */
- (UIView *)zxs_createContainerWithSize:(CGSize)size platform:(UIView *)platform {
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    container.backgroundColor = [UIColor clearColor];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.layer.anchorPoint = CGPointMake(0.5, 1);
    [platform addSubview:container];
    
    // added constraints
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:size.height];
    heightConstraint.identifier = @"heightConstraint";
    [container addConstraint:heightConstraint];
    
    [container addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:size.width]];
    
    [platform addConstraint:[NSLayoutConstraint constraintWithItem:platform attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    [platform addConstraint:[NSLayoutConstraint constraintWithItem:platform attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    return container;
}


#pragma mark - methods
- (void)zxs_rotatedZWithAngle:(CGFloat)angle animated:(BOOL)animated duration:(CGFloat)duration delay:(CGFloat)delay {
    
    if (nil == self.container) {
        NSLog(@"contaner don't create");
        return;
    }
    
    CATransform3D rotateTransform = CATransform3DMakeRotation((angle * M_PI / 180.0), 0.0, 0.0, 1.0);
    if (animated) {
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.container.layer.transform = rotateTransform;
        } completion:nil];
    } else {
        self.container.layer.transform = rotateTransform;
    }
}



#pragma mark - Animations
- (void)zxs_showAnimationWithDistance:(CGFloat)distance duration:(CGFloat)duration delay:(CGFloat)delay {
    
    NSLayoutConstraint *heightConstraint = nil;
    for (NSLayoutConstraint *tempConstraint in self.container.constraints) {
        if (![tempConstraint.identifier isEqualToString:@"heightConstraint"]) {
            continue;
        } else {
            NSLog(@"showAnimationWithDistance获取到heightConstraint");
            heightConstraint = tempConstraint;
            break;
        }
    }
    
    if (nil == heightConstraint) {
        NSLog(@"showAnimationWithDistance没有获取到heightConstraint");
        return;
    }
    
    self.transform = CGAffineTransformMakeScale(0, 0);
    [self.container.superview layoutIfNeeded];
    self.alpha = 0.0;
    
    heightConstraint.constant = distance;
    [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.container.superview layoutIfNeeded];
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)zxs_hideAnimationWithDistance:(CGFloat)distance duration:(CGFloat)duration delay:(CGFloat)delay {
    
    NSLayoutConstraint *heightConstraint = nil;
    for (NSLayoutConstraint *tempConstraint in self.container.constraints) {
        if (![tempConstraint.identifier isEqualToString:@"heightConstraint"]) {
            continue;
        } else {
            NSLog(@"hideAnimationWithDistance获取到heightConstraint");
            heightConstraint = tempConstraint;
            break;
        }
    }
    
    if (nil == heightConstraint) {
        NSLog(@"hideAnimationWithDistance没有获取到heightConstraint");
        return;
    }
    
    heightConstraint.constant = distance;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.container.superview layoutIfNeeded];
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        self.alpha = 0;
         // remove container
        if (self.container != nil) {
            [self.container removeFromSuperview];
        }
    }];
}


- (void)zxs_changeDistance:(CGFloat)distance animated:(BOOL)animated duration:(CGFloat)duration delay:(CGFloat)delay {
    
    NSLayoutConstraint *heightConstraint = nil;
    for (NSLayoutConstraint *tempConstraint in self.container.constraints) {
        if (![tempConstraint.identifier isEqualToString:@"heightConstraint"]) {
            continue;
        } else {
            NSLog(@"changeDistance获取到heightConstraint");
            heightConstraint = tempConstraint;
            break;
        }
    }
    
    if (nil == heightConstraint) {
        NSLog(@"changeDistance没有获取到heightConstraint");
        return;
    }
    
    heightConstraint.constant = distance;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        if (self.container != nil && self.container.subviews != nil) {
            [self.container.superview layoutIfNeeded];
        }
        
    } completion:nil];
}

#pragma mark - layer animation
- (void)zxs_rotationAnimationWithAngle:(CGFloat)angle duration:(CGFloat)duration {
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.duration = duration;
    rotation.toValue = @(angle * M_PI / 180.0);
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.container.layer addAnimation:rotation forKey:@"rotation"];
}


@end
