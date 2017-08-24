//
//  ViewController.m
//  ZPMagnetDemo
//
//  Created by yueru on 2017/8/24.
//  Copyright © 2017年 赵攀. All rights reserved.
//

#import "ViewController.h"
#import "ZPMagnetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ZPMagnetView *magnetView = [[ZPMagnetView alloc] initWithFrame:CGRectMake(0, 100, 375, 300)];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2685625329,3171256928&fm=26&gp=0.jpg"];
    [array addObject:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=527765531,3652006436&fm=26&gp=0.jpg"];
    [array addObject:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2795850468,3159955322&fm=26&gp=0.jpg"];
    magnetView.imageUrls = array;
    [self.view addSubview:magnetView];
    
}


@end
