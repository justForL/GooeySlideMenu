//
//  GooeySlideMenu.h
//  GooeySlideMenu
//
//  Created by James on 16/4/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GooeySlideMenu : UIView
- (instancetype)initWithTitle:(NSArray *)titles;
/**
 *  按钮的点击事件
 */
- (void)trigger;
@end
