//
//  GooeySlideMenu.m
//  GooeySlideMenu
//
//  Created by James on 16/4/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GooeySlideMenu.h"
#define buttonSpace 30
/**
 *  空出一段距离,不至于蓝色View铺满全屏,以至于看不到形变效果
 *
 *
 */
#define menuBlankWidth 50

@implementation GooeySlideMenu {
    /**
     *  当前keyWindow
     */
    UIWindow             *_keyWindow;
    /**
     * 毛玻璃效果
     */
    UIVisualEffectView   *_blurView;
    /**
     *
     */
    UIView               *_helperSideView;
    
    
    
    UIView               *_helperCenterView;
    
    /**
     *  用于当前左侧view的点击状态
     */
    BOOL                  _triggered;
    
    
    UIColor              *_menuColor;
    
    
    CGFloat               _menuButtonHeight;
}





- (instancetype)initWithTitle:(NSArray *)titles {
    return [self initWithTitle:titles withButtonHeight:40.0f withMenuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] withBackBlurStyle:UIBlurEffectStyleDark];
}

- (instancetype)initWithTitle:(NSArray *)titles withButtonHeight:(CGFloat)buttonHeight withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style {
    
    if (self = [super init]) {
//        //获取keyWindow
        _keyWindow = [[UIApplication sharedApplication]keyWindow];
//
        _blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:style]];
        
        //设置毛玻璃的尺寸
        _blurView.frame = _keyWindow.frame;
        //初始透明度设置为0,待以后点击Trigger按钮时,将透明度显示为1,在界面上显示出来
        _blurView.alpha = 0;
        
        
        //边界辅助view
        _helperSideView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, 40, 40)];
        _helperSideView.backgroundColor = [UIColor redColor];
        //初始化的时候,将其隐藏
        _helperSideView.hidden = YES;
        [_keyWindow addSubview:_helperSideView];
        
        
        //中心辅助view
        _helperCenterView = [[UIView alloc]initWithFrame:CGRectMake(-40, CGRectGetHeight(_keyWindow.frame), 40, 40)];
        _helperCenterView.backgroundColor = [UIColor yellowColor];
        _helperCenterView.hidden = YES;
//        [_keyWindow addSubview:_helperCenterView];
        
        
        self.frame = CGRectMake(- _keyWindow.frame.size.width / 2 - menuBlankWidth, 0, _keyWindow.frame.size.width / 2 + menuBlankWidth, _keyWindow.frame.size.height);
        self.backgroundColor = menuColor;
//        [_keyWindow insertSubview:self belowSubview:_helperCenterView];
        [_keyWindow addSubview:self];
        _menuColor = menuColor;
        _menuButtonHeight = buttonHeight;
        
    }
    return self;
}



- (void)trigger {
    
    if (!_triggered) {
        
        /**
         *  insertSubview与addSubview的区别:
         
         
         A addSubview B  是将B直接覆盖在A的最上层
         
         A insertSubView B AtIndex:2 是将B插入到A的子视图index为2的位置（最底下是0）
         
         A insertSubView B aboveSubview:C  是将B插入A并且在A已有的子视图C的上面
         
         A insertSubView B belowSubview:C  是将B插入A并且在A已有的子视图C的下面

         */
        [_keyWindow insertSubview:_blurView belowSubview:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            //添加动画,为了做位移,因为bounds是以(0,0)为起点 ,所以直接将bounds赋值给frame 就可以做到位移的效果
            self.frame = self.bounds;
        }];
        
        
        //当点击Trigger按钮的时候,将毛玻璃的透明度显示成1,在界面上显示出来,加上动画效果,不会显得生硬,突兀
        [UIView animateWithDuration:0.25 animations:^{
            _blurView.alpha = 1;
        }];
    }
}




- (void)drawRect:(CGRect)rect {
    
}


@end
