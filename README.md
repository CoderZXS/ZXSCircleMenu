# ZXSCircleMenu


介绍
--------
- ZXSCircleMenu是一个优雅的圆形菜单
- [Objective-C UI库(https://github.com/CoderZXS/ZXSCircleMenu)是模仿[Swift UI 库](https://github.com/Ramotion/circle-menu)实现的，所以 Objective-C UI库只会根据Swift UI 库更新而更新


使用
--------
- 添加菜单按钮
```Objective-C
    ZXSCircleMenu *button = [[ZXSCircleMenu alloc] zxs_initWithFrame:CGRectMake(150, 200, 50, 50) normalIcon:@"icon_menu" selectedIcon:@"icon_close" buttonsCount:4 duration:4 distance:120];
    button.backgroundColor = [UIColor lightGrayColor];
    button.delegate = self;
    button.layer.cornerRadius = button.frame.size.width * 0.5;
    [self.view addSubview:button];
```

- 实现菜单按钮代理方法
```Objective-C
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
```


效果
--------
![ZXSCircleMenu](https://github.com/CoderZXS/ZXSCircleMenu/blob/master/ZXSCircleMenu.gif)


结后语
--------
- 如果你觉得不错，请点个星星吧，辛苦啦！谢谢。。。
- QQ:1252935734 你要是对本框架有什么建议，欢迎加我QQ，希望与小伙伴们一起学习、成长！！！




