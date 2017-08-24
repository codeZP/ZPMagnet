//
//  ZPMagnetView.h
//  ZPMagnetDemo
//
//  Created by yueru on 2017/8/24.
//  Copyright © 2017年 赵攀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPMagnetView : UIView

@property (nonatomic, strong) NSMutableArray <NSString *> *imageUrls;

@property (nonatomic, strong) NSString *placeholder;

-(void)reloadData;

@end
