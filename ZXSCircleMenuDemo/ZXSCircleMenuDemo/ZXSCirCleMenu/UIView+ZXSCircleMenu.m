//
//  UIView+ZXSCircleMenu.m
//  ZXSCircleMenu(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//

#import "UIView+ZXSCircleMenu.h"

@implementation UIView (ZXSCircleMenu)

- (CGFloat)zxs_angleZ {
    return atan2(self.transform.b, self.transform.a) * (180 / M_PI);
}

@end
