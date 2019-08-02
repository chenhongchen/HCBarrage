//
//  HCBarrageView.h
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBarrageCell.h"
#import "HCBarrageTracksSize.h"
#import "HCBarrageTrackConfig.h"

@class HCBarrageView;
@protocol HCBarrageViewDelegate <NSObject>
- (HCBarrageCell *)barrageView:(HCBarrageView *)barrageView cellForItem:(HCBarrageItem *)item;
@optional
/// 如果没有实现这个方法，或返回width小于0，则使用cell自身已有的宽度
- (CGFloat)barrageView:(HCBarrageView *)barrageView widthForItem:(HCBarrageItem *)item;
@end

@interface HCBarrageView : UIView
/// 弹幕轨道位置尺寸
@property (nonatomic, strong) HCBarrageTracksSize *tracksSize;
/// 弹幕轨道配置
@property (nonatomic, strong) HCBarrageTrackConfig *trackConfig;

@property (nonatomic, weak) id <HCBarrageViewDelegate> delegate;

- (HCBarrageCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

/// 启动弹幕功能
- (void)start;

/// 停止弹幕功能
- (void)stop;

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
 发送多条弹幕

 @param barrageItems 多条弹幕数据
 */
- (void)sendBarrages:(NSArray <HCBarrageItem *>*)barrageItems;

/**
 清空弹幕数据
 */
- (void)clearBarrages;
@end
