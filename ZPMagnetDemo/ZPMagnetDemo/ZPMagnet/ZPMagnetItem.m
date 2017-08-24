//
//  ZPMagnetItem.m
//  ZPMagnetDemo
//
//  Created by yueru on 2017/8/24.
//  Copyright © 2017年 赵攀. All rights reserved.
//

#import "ZPMagnetItem.h"
#import <UIImageView+WebCache.h>

@interface ZPMagnetItem ()
{
    UIImageView *_imageV;
    
    CAShapeLayer *_borderLayer;
}
@end

@implementation ZPMagnetItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [self backgroundColor];
    
    _imageV = [[UIImageView alloc] init];
    _imageV.frame = self.bounds;
    _imageV.userInteractionEnabled = YES;
    [self addSubview:_imageV];
    
    [self addBorderLayer];
}

-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1;
    _borderLayer.lineDashPattern = @[@5, @3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [self backgroundColor].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = true;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageV.frame = self.bounds;
}

#pragma mark -
#pragma mark 配置方法

-(UIColor*)backgroundColor{
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}

#pragma mark -
#pragma mark Setter

- (void)setimageWithImageUrl:(NSString *)imageUrl placeholder:(NSString *)placeholder {
    _imageUrl = imageUrl;
    if ([imageUrl hasPrefix:@"http"]) {
        [_imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:placeholder]];
    }else {
        _imageV.image = [UIImage imageNamed:imageUrl];
    }
}

-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
        _borderLayer.hidden = false;
    }else{
        self.backgroundColor = [self backgroundColor];
        _borderLayer.hidden = true;
    }
}

@end
