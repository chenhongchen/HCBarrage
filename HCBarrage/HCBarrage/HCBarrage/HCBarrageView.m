//
//  HCBarrageView.m
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//
//屏幕的尺寸
#define kBV_ScreenF   [[UIScreen mainScreen] bounds]
//屏幕的高度
#define kBV_ScreenH  CGRectGetHeight(kBV_ScreenF)
//屏幕的宽度
#define kBV_ScreenW  CGRectGetWidth(kBV_ScreenF)

#import "HCBarrageView.h"
#import "HCBarrageTrackView.h"

@interface HCBarrageView ()<HCBarrageTrackViewDelegate>
@property (nonatomic, strong) NSArray<HCBarrageTrackView *> *tracks;
@property (nonatomic, assign) NSInteger nextTrackIndex;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> *reusableCellsDM;
@end

@implementation HCBarrageView

#pragma mark - 懒加载
- (NSMutableDictionary *)reusableCellsDM
{
    if (_reusableCellsDM == nil) {
        _reusableCellsDM = [NSMutableDictionary dictionary];
    }
    return _reusableCellsDM;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _trackConfig = [[HCBarrageTrackConfig alloc] init];
        _trackConfig.velocity = 100;
        _trackConfig.spacing = 30;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
//    NSLog(@"dealloc -- HCBarrageView");
}

#pragma mark - 外部方法
- (void)setTracksSize:(HCBarrageTracksSize *)tracksSize
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView removeFromSuperview];
        trackView.delegate = nil;
    }
    _tracksSize = tracksSize;
    [self setupTracks];
}

- (void)setTrackConfig:(HCBarrageTrackConfig *)trackConfig
{
    _trackConfig = trackConfig;
    for (HCBarrageTrackView *trackView in _tracks) {
        trackView.trackConfig = _trackConfig;
    }
}

- (HCBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableSet *cellsM = self.reusableCellsDM[identifier];
    HCBarrageCell *cell = [cellsM anyObject];
    if (cell) {
        [cellsM removeObject:cell];
    }
    return cell;
}

- (void)start
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView start];
    }
}

- (void)stop
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView stop];
    }
}

- (void)pause
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView pause];
    }
}

- (void)resume
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView resume];
    }
}

- (void)sendOneBarrage:(HCBarrageItem *)barrageItem
{
    if (_tracks.count <= 0) {
        return;
    }
    if (_nextTrackIndex >= _tracks.count) {
        _nextTrackIndex = 0;
    }
    HCBarrageTrackView *selTrackView = _tracks[_nextTrackIndex];
    [selTrackView sendOneBarrage:barrageItem];
    _nextTrackIndex++;
}

- (void)insertOneBarrage:(HCBarrageItem *)barrageItem
{
    if (_tracks.count <= 0) {
        return;
    }
    if (_nextTrackIndex >= _tracks.count) {
        _nextTrackIndex = 0;
    }
    HCBarrageTrackView *selTrackView = _tracks[_nextTrackIndex];
    [selTrackView insertOneBarrage:barrageItem];
    _nextTrackIndex++;
}

- (void)sendBarrages:(NSArray <HCBarrageItem *>*)barrageItems
{
    for (HCBarrageItem *item in barrageItems) {
        [self sendOneBarrage:item];
    }
}

- (void)clearBarrages
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView clearBarrages];
    }
}

- (void)clearInsertBarrages
{
    for (HCBarrageTrackView *trackView in _tracks) {
        [trackView clearInsertBarrages];
    }
}

#pragma mark - 重载
- (void)sizeToFit
{
    CGRect rect = self.frame;
    rect.size.height = CGRectGetMaxY(self.tracks.lastObject.frame);
    rect.size.width = kBV_ScreenW;
    rect.origin.x = 0;
    self.frame = rect;
}

#pragma mark - HCBarrageTrackViewDelegate
- (HCBarrageCell *)trackView:(HCBarrageTrackView *)trackView cellForItem:(HCBarrageItem *)item
{
    HCBarrageCell *cell = nil;
    if ([self.delegate respondsToSelector:@selector(barrageView:cellForItem:)]) {
        cell = [self.delegate barrageView:self cellForItem:item];
    }
    return cell;
}

- (CGFloat)trackView:(HCBarrageTrackView *)trackView widthForItem:(HCBarrageItem *)item
{
    CGFloat width = -1;
    if ([self.delegate respondsToSelector:@selector(barrageView:widthForItem:)]) {
        width = [self.delegate barrageView:self widthForItem:item];
    }
    return width;
}

- (void)trackView:(HCBarrageTrackView *)trackView didClickCellForItem:(HCBarrageItem *)item
{
    if ([self.delegate respondsToSelector:@selector(barrageView:didClickCellForItem:)]) {
        [self.delegate barrageView:self didClickCellForItem:item];
    }
}

- (void)trackView:(HCBarrageTrackView *)trackView didUnUseForCell:(HCBarrageCell *)cell
{
    // 进缓存池
    [self enqueueReusableCell:cell];
}

#pragma mark - 内部方法
- (void)setupTracks
{
    NSMutableArray *tracksM = [NSMutableArray array];
    HCBarrageTrackView *lastTrackView = nil;
    for (int i = 0; i < _tracksSize.trackCount; i ++) {
        CGFloat y = CGRectGetMaxY(lastTrackView.frame) + _tracksSize.trackPadding;
        if (i == 0) {
            y = 0;
        }
        HCBarrageTrackView *trackView = [[HCBarrageTrackView alloc] initWithFrame:CGRectMake(0, y, kBV_ScreenW, _tracksSize.trackHeight)];
        trackView.delegate = self;
        trackView.trackConfig = _trackConfig;
        [self addSubview:trackView];
        [tracksM addObject:trackView];
        lastTrackView = trackView;
    }
    _tracks = tracksM;
}

- (void)enqueueReusableCell:(HCBarrageCell *)cell
{
    if (![cell isKindOfClass:[HCBarrageCell class]] || !cell.reuseIdentifier.length) {
        return;
    }
    NSMutableSet *cellsM = self.reusableCellsDM[cell.reuseIdentifier];
    if (cellsM == nil) {
        cellsM = [NSMutableSet set];
        self.reusableCellsDM[cell.reuseIdentifier] = cellsM;
    }
    [cellsM addObject:cell];
}
@end
