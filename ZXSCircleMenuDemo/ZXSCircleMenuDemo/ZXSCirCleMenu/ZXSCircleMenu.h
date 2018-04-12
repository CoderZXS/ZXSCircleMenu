//
//  ZXSCircleMenu.h
//  ZXSCircleMenuLib(https://github.com/CoderZXS/ZXSCircleMenu)
//
//  Created by CoderZXS on 2016/4/12.
//  Copyright © 2016年 CoderZXS. All rights reserved.
//  菜单按钮

#import <UIKit/UIKit.h>

@class ZXSCircleMenu;
@class ZXSCircleMenuButton;
@protocol ZXSCircleMenuDelegate <NSObject>

/**
 告诉委托人，圆形菜单即将为特定索引绘制一个按钮。
  
   - 参数circleMenu：圆形菜单对象，通知代表该即将发生的事件。
   - 参数按钮：圆形菜单在绘制行时将使用的圆形菜单按钮对象。 不要更改button.tag
   - 参数atIndex：一个按钮索引。
 */
- (void)zxs_circleMenu:(ZXSCircleMenu *)circleMenu buttonWillDisplay:(ZXSCircleMenuButton *)button atIndex:(NSUInteger)index;

/**
 告诉委托人即将选择指定的索引。
  
   - 参数circleMenu：圆形菜单对象，通知代表即将进行的选择。
   - 参数按钮：一个选定的圆形菜单按钮。 不要更改button.tag
   - 参数atIndex：选定的按钮索引
 */
- (void)zxs_circleMenu:(ZXSCircleMenu *)circleMenu buttonWillSelected:(ZXSCircleMenuButton *)button atIndex:(NSUInteger)index;

/**
 告诉委托人现在选择了指定的索引。
  
   - 参数circleMenu：通知委托人有关新索引选择的圆形菜单对象。
   - 参数按钮：一个选定的圆形菜单按钮。 不要更改button.tag
   - 参数atIndex：选定的按钮索引
 */
- (void)zxs_circleMenu:(ZXSCircleMenu *)circleMenu buttonDidSelected:(ZXSCircleMenuButton *)button atIndex:(NSUInteger)index;

/**
 告诉委托人菜单已折叠 - 取消操作。
  
   - 参数circleMenu：通知委托人有关新索引选择的圆形菜单对象。
 */
- (void)zxs_menuCollapsed:(ZXSCircleMenu *)circleMenu;

@end

@interface ZXSCircleMenu : UIButton

@property (weak, nonatomic) id<ZXSCircleMenuDelegate> delegate; // The object that acts as the delegate of the circle menu. ZXSCircleMenuDelegate
@property (assign, nonatomic) NSUInteger buttonsCount;          // Buttons count
@property (assign, nonatomic) CGFloat duration;                 // Circle animation duration
@property (assign, nonatomic) CGFloat distance;                 // Distance between center button and buttons
@property (assign, nonatomic) CGFloat showDelay;                //  显示按钮之间的延迟
@property (assign, nonatomic) CGFloat startAngle;               //  Start angle of the circle
@property (assign, nonatomic) CGFloat endAngle;                 //  End angle of the circle
@property (assign, nonatomic) CGFloat subButtonsRadius;         //  Pop buttons radius, if nil use center button size

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
- (instancetype)zxs_initWithFrame:(CGRect)frame normalIcon:(NSString *)normalIcon selectedIcon:(NSString *)selectedIcon buttonsCount:(NSUInteger)buttonsCount duration:(CGFloat)duration distance:(CGFloat)distance;

@end
