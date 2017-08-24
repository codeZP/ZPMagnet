//
//  ZPMagnetView.m
//  ZPMagnetDemo
//
//  Created by yueru on 2017/8/24.
//  Copyright © 2017年 赵攀. All rights reserved.
//

#import "ZPMagnetView.h"
#import "ZPMagnetItem.h"

//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;


@interface ZPMagnetView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    //被拖拽的item
    ZPMagnetItem *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    //正在拖拽的image
    NSString *_dragingImageUrl;
}
@end

@implementation ZPMagnetView

static NSString *ID = @"XLChannelItem";

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = (self.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
    flowLayout.itemSize = CGSizeMake(cellWidth,cellWidth/2.0f);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ZPMagnetItem class] forCellWithReuseIdentifier:ID];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.3f;
    [_collectionView addGestureRecognizer:longPress];
    
    _dragingItem = [[ZPMagnetItem alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth/2.0f)];
    _dragingItem.hidden = true;
    [_collectionView addSubview:_dragingItem];
}

#pragma mark -
#pragma mark LongPressMethod
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point{
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_collectionView bringSubviewToFront:_dragingItem];
    ZPMagnetItem *item = (ZPMagnetItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = true;
    //更新被拖拽的item
    _dragingItem.hidden = false;
    _dragingItem.frame = item.frame;
    _dragingImageUrl = item.imageUrl;
    [_dragingItem setimageWithImageUrl:_dragingImageUrl placeholder:self.placeholder];
    [item setimageWithImageUrl:nil placeholder:self.placeholder];
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}

//正在被拖拽、、、
-(void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        _dragingItem.frame = endFrame;
    }completion:^(BOOL finished) {
        _dragingItem.hidden = true;
        ZPMagnetItem *item = (ZPMagnetItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
        [item setimageWithImageUrl:_dragingImageUrl placeholder:self.placeholder];
        item.isMoving = false;
    }];
}

#pragma mark -
#pragma mark 辅助方法

//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            dragIndexPath = indexPath;
            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            targetIndexPath = indexPath;
        }
    }
    return targetIndexPath;
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrls.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZPMagnetItem* item = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [item setimageWithImageUrl:self.imageUrls[indexPath.row] placeholder:self.placeholder];
    return item;
}

#pragma mark -
#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)rearrangeInUseTitles
{
    id obj = [self.imageUrls objectAtIndex:_dragingIndexPath.row];
    [self.imageUrls removeObject:obj];
    [self.imageUrls insertObject:obj atIndex:_targetIndexPath.row];
}

-(void)reloadData
{
    [_collectionView reloadData];
}
@end
