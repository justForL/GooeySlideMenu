//
//  GooeySlideMenu.m
//  GooeySlideMenu
//
//  Created by James on 16/4/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GooeySlideMenu.h"
#import "SlideButton.h"
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
     * 边界辅助view
     */
    UIView               *_helperSideView;
    
    /**
     *  中心辅助view
     */
    
    UIView               *_helperCenterView;
    
    /**
     *  用于当前左侧view的点击状态
     */
    BOOL                  _triggered;
    
    
    UIColor              *_menuColor;
    
    
    CGFloat               _menuButtonHeight;
    /**
     *  两个辅助视图的x值得差
     */
    CGFloat               _diff;
    
    
    CADisplayLink        *_displayLink;
    /**
     *  动画数量,当数量归零时,用于移除动displink
     */
    NSInteger             _animationCount;
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
        [_keyWindow addSubview:_helperCenterView];
        
        
        self.frame = CGRectMake(- _keyWindow.frame.size.width / 2 - menuBlankWidth, 0, _keyWindow.frame.size.width / 2 + menuBlankWidth, _keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
//        [_keyWindow insertSubview:self belowSubview:_helperCenterView];
        [_keyWindow addSubview:self];
        _menuColor = menuColor;
        _menuButtonHeight = buttonHeight;
        
        [self addButtons:titles];
    }
    return self;
}



/**
 *  添加button
 *
 *  @param titles 按钮标题
 */
- (void)addButtons:(NSArray *)titles {

        NSInteger index_down = titles.count/2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            SlideButton *home_button = [[SlideButton alloc]initWithTitle:title];
            if (i >= titles.count / 2) {
                index_up ++;
                home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 + _menuButtonHeight*index_up + buttonSpace*index_up + buttonSpace/2 + _menuButtonHeight/2);
            }else{
                index_down --;
                home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - _menuButtonHeight*index_down - buttonSpace*index_down - buttonSpace/2 - _menuButtonHeight/2);
            }
            
            home_button.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, _menuButtonHeight);
            home_button.buttonColor = _menuColor;
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            home_button.clickBlock = ^(){
                [WeakSelf tapToUnTrigger];
//                WeakSelf.menuClickBlock(i,title,titles.count);
            };

        
    }
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
        
        [self beforAnimation];
        
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionAllowUserInteraction |          UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            _helperSideView.center = CGPointMake(_keyWindow.center.x, _helperSideView.frame.size.height / 2);
            
        } completion:^(BOOL finished) {
            
            [self finishedAnimation];
        }];
        
        [self beforAnimation];
        
        [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionAllowUserInteraction |          UIViewAnimationOptionBeginFromCurrentState animations:^{
            _helperCenterView.center = _keyWindow.center;
            
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUnTrigger)];
                [_blurView addGestureRecognizer:tap];
                
                [self finishedAnimation];
            }
        }];
        
        //当点击Trigger按钮的时候,将毛玻璃的透明度显示成1,在界面上显示出来,加上动画效果,不会显得生硬,突兀
        [UIView animateWithDuration:0.25 animations:^{
            _blurView.alpha = 1;
        }];
        
        [self animateButtons];
        
        _triggered = YES;
    }else {
        
        [self tapToUnTrigger];
    }
}


/**
 *  给按钮添加动画
 */
- (void)animateButtons {
    
    for (int i = 0; i < self.subviews.count; ++i) {
        
        UIView *menuButton = self.subviews[i];
        //给按钮先平移
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        
        //添加动画
        [UIView animateWithDuration:0.7 delay:i * (0.3 / self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            menuButton.transform = CGAffineTransformIdentity;//是讲位移置为上一次修改前的状态
        } completion:NULL];
    }
}

/**
 *  关闭slideMenu
 */
- (void)tapToUnTrigger {
    //关闭蓝色view
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(- _keyWindow.frame.size.width /2 - menuBlankWidth, 0, _keyWindow.frame.size.width / 2 + menuBlankWidth, _keyWindow.frame.size.height);
    }];

    //移动边界辅助view
    [self beforAnimation];
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionAllowUserInteraction |          UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _helperSideView.center = CGPointMake(- _helperSideView.frame.size.height/2, _helperSideView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self finishedAnimation];
    }];
    
    
    //关闭blur
    [UIView animateWithDuration:0.25 animations:^{
        _blurView.alpha = 0;
    }];
    
    //移动中心辅助view
    [self beforAnimation];
    
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.6f initialSpringVelocity:2.0f options:UIViewAnimationOptionAllowUserInteraction |          UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _helperCenterView.center = CGPointMake(- _helperCenterView.frame.size.height/2, _helperCenterView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self finishedAnimation];
    }];
    
    _triggered = NO;
}

/**
 *  开始动画前
 */
- (void)beforAnimation {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        //加入Runloop循环
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
    }
    _animationCount++;
}


/**
 *  动画结束
 */
- (void)finishedAnimation {
    _animationCount--;
    if (_animationCount == 0) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
}



- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(self.frame.size.width - menuBlankWidth, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width - menuBlankWidth, self.frame.size.height) controlPoint:CGPointMake(_keyWindow.frame.size.width / 2 + _diff, _keyWindow.frame.size.height / 2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [_menuColor set];
    CGContextFillPath(context);
    NSLog(@"diff------%f",_diff);
}
/**
 *  用于重绘的方法
 *
 *  @param displayLink 定时器
 */
- (void)displayLinkAction:(CADisplayLink *)displayLink {
    
    CALayer *sideHelperPresentationLayer = [_helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = [_helperCenterView.layer presentationLayer];
    
    CGRect sideRect = [[sideHelperPresentationLayer valueForKey:@"frame"]CGRectValue];
    CGRect centerRect = [[centerHelperPresentationLayer valueForKey:@"frame"]CGRectValue];
    
    _diff = sideRect.origin.x - centerRect.origin.x;
    
    [self setNeedsDisplay];
}
@end
