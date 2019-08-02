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
        [self checkStartAnimatiom];
    }
    return self;
}

#pragma mark - 外部方法
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

#pragma mark - 内部方法
- (void)checkStartAnimatiom
{
    //当有数据信息的时候
    if (self.dataSourcesM.count>0) {
        //开始动画
        [self startAnimation];
    }
    //延迟执行，在主线程中不能调用sleep()进行延迟执行
    //调用自身方法，构成一个无限循环，不停的轮询检查是否有弹幕数据
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_minSpaceTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf checkStartAnimatiom];
    });
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
