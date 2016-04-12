//
//  SlideButton.m
//  GooeySlideMenu
//
//  Created by James on 16/4/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SlideButton.h"

@implementation SlideButton {
    NSString * _buttonTitle;
}


- (void)drawRect:(CGRect)rect {
    //图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddRect(ref, rect);
    [self.buttonColor set];
    CGContextFillPath(ref);
    
    //画按钮
    UIBezierPath *roundRecrAnglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:rect.size.height / 2];
    [self.buttonColor setFill];
    [[UIColor whiteColor] setStroke];
    roundRecrAnglePath.lineWidth = 1;
    [roundRecrAnglePath stroke];
    
    //设置文字位置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //居中
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *att = @{NSParagraphStyleAttributeName: paragraphStyle,
                          NSFontAttributeName:[UIFont systemFontOfSize:24.0f],
                          NSForegroundColorAttributeName:[UIColor whiteColor]};
    //文字尺寸
    CGSize size = [_buttonTitle sizeWithAttributes:att];
    CGRect r = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - size.height) / 2.0f, rect.size.width, size.height);
    
    [_buttonTitle drawInRect:r withAttributes:att];
}

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _buttonTitle = title;
    }
    return self;
}

//当前view的点击事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            self.clickBlock();
            break;
            
        default:
            break;
    }
}
@end
