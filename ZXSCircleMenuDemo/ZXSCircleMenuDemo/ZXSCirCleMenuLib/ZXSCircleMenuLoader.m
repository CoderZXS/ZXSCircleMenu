//
//  ZXSCircleMenuLoader.m
//  ZXSCircleMenuLib(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//

#import "ZXSCircleMenuLoader.h"

@interface ZXSCircleMenuLoader()

@property (strong, nonatomic) CAShapeLayer *circle;

@end

@implementation ZXSCircleMenuLoader

- (instancetype)zxs_initWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth platform:(UIView *)platform color:(UIColor *)color {
    if (self == [super initWithFrame:CGRectMake(0, 0, radius, radius)]) {
        
        [platform addSubview:self];
        
        self.circle = [self zxs_createCircleWithRadius:radius strokeWidth:strokeWidth color:color];
        [self zxs_createConstraintsWithPlatform:platform radius:radius];
        
        CGRect circleFrame = CGRectMake((radius * 2 - strokeWidth), (radius - strokeWidth * 0.5), strokeWidth, strokeWidth);
        [self zxs_createRoundViewWithRect:circleFrame color:color];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


- (CAShapeLayer *)zxs_createCircleWithRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth color:(UIColor *)color {
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:(radius - strokeWidth * 0.5) startAngle:0.0 endAngle:(M_PI * 2) clockwise:YES];
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [circlePath CGPath];
    circle.fillColor = UIColor.clearColor.CGColor;
    circle.strokeColor = color.CGColor;
    circle.lineWidth = strokeWidth;
    
    [self.layer addSublayer:circle];
    
    return circle;
}


- (void)zxs_createConstraintsWithPlatform:(UIView *)platform radius:(CGFloat)radius {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    // added constraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:(radius * 2.0)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:(radius * 2.0)]];
    
    [platform addConstraint:[NSLayoutConstraint constraintWithItem:platform attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [platform addConstraint:[NSLayoutConstraint constraintWithItem:platform attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

- (void)zxs_createRoundViewWithRect:(CGRect)rect color:(UIColor *)color {
    
    UIView *roundView = [[UIView alloc] initWithFrame:rect];
    roundView.backgroundColor = [UIColor blackColor];
    roundView.layer.cornerRadius = rect.size.width * 0.5;
    roundView.backgroundColor = color;
    
    [self addSubview:roundView];
}



#pragma mark - animations
- (void)zxs_fillAnimationWithDuration:(CGFloat)duration startAngle:(CGFloat)startAngle completion:(void(^)(void))completion {

    if (self.circle == nil) {
        return;
    }
    
    CATransform3D rotateTransform = CATransform3DMakeRotation((startAngle * M_PI / 180.0), 0.0, 0.0, 1.0);
    self.layer.transform = rotateTransform;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duration;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.circle addAnimation:animation forKey:nil];
    [CATransaction commit];
}


- (void)zxs_hideAnimationWithDuration:(CGFloat)duration delay:(CGFloat)delay completion:(void(^)(void))completion {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = @1.2;
    scaleAnimation.duration = duration;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    scaleAnimation.beginTime = CACurrentMediaTime() + delay;
    [self.layer addAnimation:scaleAnimation forKey:nil];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        completion();
    }];
}

@end
