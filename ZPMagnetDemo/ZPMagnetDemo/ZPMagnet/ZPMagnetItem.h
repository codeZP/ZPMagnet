//
//  ZPMagnetItem.h
//  ZPMagnetDemo
//
//  Created by yueru on 2017/8/24.
//  Copyright © 2017年 赵攀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPMagnetItem : UICollectionViewCell

//标题
@property (nonatomic, copy) NSString *imageUrl;

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

- (void)setimageWithImageUrl:(NSString *)imageUrl placeholder:(NSString *)placeholder;

@end
