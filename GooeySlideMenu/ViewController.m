//
//  ViewController.m
//  GooeySlideMenu
//
//  Created by James on 16/4/11.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "GooeySlideMenu.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    GooeySlideMenu      *_menu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //当navigationController 遇到 tableView 会自动偏移一段距离  需要手动关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _menu = [[GooeySlideMenu alloc]initWithTitle:@[@"首页",@"消息",@"发布",@"发现",@"个人",@"设置"]];
}

- (IBAction)triggerClick:(id)sender {
    NSLog(@"%s",__func__);
    [_menu trigger];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}
@end
