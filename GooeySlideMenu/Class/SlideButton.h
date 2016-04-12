//
//  SlideButton.h
//  GooeySlideMenu
//
//  Created by James on 16/4/12.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ButtonClickBlock) ();
@interface SlideButton : UIView
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic,copy) ButtonClickBlock clickBlock;

- (instancetype)initWithTitle:(NSString *)title;
@end
