//
//  ViewController.m
//  底部旋转菜单 - CoreAnimation
//
//  Created by 陈诚 on 15/12/11.
//  Copyright © 2015年 陈诚. All rights reserved.
//

#import "ViewController.h"
#import "ButtonMenu.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //添加底部的View
    ButtonMenu *menu = [ButtonMenu buttonMenu];
    CGFloat menuX = 0;
    CGFloat menuY = self.view.bounds.size.height - menu.bounds.size.height;
    CGFloat menuW = self.view.bounds.size.width;
    CGFloat menuH = menu.bounds.size.height;
    menu.frame = CGRectMake(menuX, menuY, menuW, menuH);
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
