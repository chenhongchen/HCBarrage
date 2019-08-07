//
//  HCBarrageTrackView.m
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//

//屏幕的尺寸
#define kTV_ScreenF   [[UIScreen mainScreen] bounds]
//屏幕的高度
#define kTV_ScreenH  CGRectGetHeight(kTV_ScreenF)
//屏幕的宽度
#define kTV_ScreenW  CGRectGetWidth(kTV_ScreenF)

#import "HCBarrageTrackView.h"

@interface HCBarrageTrackView()
{
    CGFloat _minSpaceTime;  /** 最小间距时间 */
}

/** 数据源 */
@property (nonatomic,retain)NSMutableArray *dataSourcesM;
@property (nonatomic, weak) HCBarrageCell *lastAnimateCell;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isPause;
@end

@implementation HCBarrageTrackView

#pragma mark - 懒加载
- (NSMutableArray *)dataSourcesM
{
    if (_dataSourcesM == nil) {
        _dataSourcesM = [NSMutableArray array];
    }
    return _dataSourcesM;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"dealloc -- HCBarrageTrackView");
}

#pragma mark - 外部方法
- (void)start
{
    if (_isEnabled == YES) {
        return;
    }
    _isEnabled = YES;
    _isPause = NO;
    _minSpaceTime = 1;
    [self checkStartAnimatiom];
}

- (void)stop
{
    _isEnabled = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkStartAnimatiom) object:nil];
    for (UIView *view in self.subviews) {
        [view.layer removeAllAnimations];
    }
}

- (void)pause
{
    _isPause = YES;
    for (HCBarrageCell *cell in self.subviews) {
        if (![cell isKindOfClass:[HCBarrageCell class]]) {
            continue;
        }
        [cell pauseAnimation];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkStartAnimatiom) object:nil];
}

- (void)resume
{
    if (!_isPause) {
        return;
    }
    _isPause = NO;
    for (HCBarrageCell *cell in self.subviews) {
        if (![cell isKindOfClass:[HCBarrageCell class]]) {
            continue;
        }
        [cell resumeAnimation];
    }
    CGFloat lastPosition = _lastAnimateCell.layer.presentationLayer.frame.size.width + _lastAnimateCell.layer.presentationLayer.frame.origin.x;
    _minSpaceTime = ((lastPosition - kTV_ScreenW) + _trackConfig.spacing) / _trackConfig.velocity;
    [self performSelector:@selector(checkStartAnimatiom) withObject:nil afterDelay:_minSpaceTime];
}

- (void)sendOneBarrage:(HCBarrageItem *)barrageItem
{
    [self.dataSourcesM addObject:barrageItem];
}

- (void)insertOneBarrage:(HCBarrageItem *)barrageItem
{
    [self.dataSourcesM insertObject:barrageItem atIndex:0];
}

- (void)clearBarrages
{
    [self.dataSourcesM removeAllObjects];
}

#pragma mark - 事件
- (void)didClickSelf:(UITapGestureRecognizer *)gesture
{
    //获取点击在self上的位置
    CGPoint touchPoint = [gesture locationInView:self];
    for (HCBarrageCell *cell in self.subviews) {
        if (![cell isKindOfClass:[HCBarrageCell class]]) {
            continue;
        }
        //点击了动画区域
        if ([cell.layer.presentationLayer hitTest:touchPoint]) {
            if ([self.delegate respondsToSelector:@selector(trackView:didClickCellForItem:)]) {
                [self.delegate trackView:self didClickCellForItem:cell.item];
            }
        }
        //点击了动画之外的区域
        else{
            
        }
    }
}

#pragma mark - 内部方法
- (void)checkStartAnimatiom
{
    if (_isEnabled == NO) {
        return;
    }
    //当有数据信息的时候
    if (self.dataSourcesM.count>0) {
        //开始动画
        [self startAnimation];
    }
    //调用自身方法，构成一个无限循环，不停的轮询检查是否有弹幕数据
    [self performSelector:@selector(checkStartAnimatiom) withObject:nil afterDelay:_minSpaceTime inModes:@[NSRunLoopCommonModes]];
}

- (void)startAnimation
{
    if (_trackConfig.velocity <= 0) {
        return;
    }
    
    // 取出第一条数据
    HCBarrageItem *item = [self.dataSourcesM firstObject];
    
    // 获取cell
    HCBarrageCell *cell = nil;
    if ([self.delegate respondsToSelector:@selector(trackView:cellForItem:)]) {
        cell = [self.delegate trackView:self cellForItem:item];
    }
    
    if (![cell isKindOfClass:[HCBarrageCell class]]) {
        //将这个弹幕数据移除
        [self.dataSourcesM removeObject:item];
        return;
    }
    
    //
    [self addSubview:cell];
    
    // 设置cell的frame
    CGRect rect = cell.frame;
    rect.origin.y = 0;
    rect.size.height = CGRectGetHeight(self.frame);
    rect.origin.x = kTV_ScreenW;
    cell.frame = rect;
    if ([self.delegate respondsToSelector:@selector(trackView:widthForItem:)]) {
        CGFloat width = [self.delegate trackView:self widthForItem:item];
        if (width >= 0) {
            rect.size.width = [self.delegate trackView:self widthForItem:item];
            cell.frame = rect;
        }
    }
    
    //不管弹幕长短，速度要求一致。 V(速度) 为固定值 = 100(可根据实际自己调整)
    // S = 屏幕宽度+弹幕的宽度  V = 100(可根据实际自己调整)
    // V(速度) = S(路程)/t(时间) -------> t(时间) = S(路程)/V(速度);
    CGFloat duration = (cell.frame.size.width + kTV_ScreenW)/ _trackConfig.velocity;
    
    //最小间距运行时间为：弹幕从屏幕外完全移入屏幕内的时间 + 间距的时间
    _minSpaceTime = (cell.frame.size.width + _trackConfig.spacing) / _trackConfig.velocity;
    
    //最后做动画的view
    _lastAnimateCell = cell;
    //弹幕UI开始动画
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //运行至左侧屏幕外
        CGRect rect =  cell.frame;
        rect.origin.x = - rect.size.width;
        cell.frame = rect;
    } completion:^(BOOL finished) {
        //重新加入重用池
        if ([self.delegate respondsToSelector:@selector(trackView:didUnUseForCell:)]) {
            [self.delegate trackView:self didUnUseForCell:cell];
        }
    }];
    
    //将这个弹幕数据移除
    [self.dataSourcesM removeObject:item];
}
@end
