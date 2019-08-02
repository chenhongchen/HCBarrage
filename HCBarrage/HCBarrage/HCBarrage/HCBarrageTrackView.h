//
//  HCBarrageTrackView.h
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBarrageItem.h"
#import "HCBarrageCell.h"
#import "HCBarrageTrackConfig.h"

@class HCBarrageTrackView;
@protocol HCBarrageTrackViewDelegate <NSObject>
- (HCBarrageCell *)trackView:(HCBarrageTrackView *)trackView cellForItem:(HCBarrageItem *)item;
- (CGFloat)trackView:(HCBarrageTrackView *)trackView widthForItem:(HCBarrageItem *)item;
- (void)trackView:(HCBarrageTrackView *)trackView didUnUseForCell:(HCBarrageCell *)cell;
@end

@interface HCBarrageTrackView : UIView
/// 弹幕轨道配置
@property (nonatomic, strong) HCBarrageTrackConfig *trackConfig;
/// 代理
@property (nonatomic, weak) id <HCBarrageTrackViewDelegate> delegate;
/// 记录当前最后一个弹幕cell，通过这个cell来计算是显示在哪个弹幕轨道上(暂时未用)
@property (nonatomic, weak, readonly) HCBarrageCell *lastAnimateCell;

/**
 发送一条弹幕
 
 @param barrageItem 一条弹幕数据
 */
- (void)sendOneBarrage:(HCBarrageItem *)barrageItem;

/**
 插入一条弹幕在第一条
 
 @param barrageItem 一条弹幕数据
 */
- (void)insertOneBarrage:(HCBarrageItem *)barrageItem;

/**
 清空弹幕数据
 */
- (void)clearBarrages;

@end
