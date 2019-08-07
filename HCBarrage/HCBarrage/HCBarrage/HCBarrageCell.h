//
//  HCBarrageCell.h
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBarrageItem.h"

@interface HCBarrageCell : UIView
{
    HCBarrageItem *_item;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong) HCBarrageItem *item;

/// 暂停动画
- (void)pauseAnimation;
/// 恢复动画
- (void)resumeAnimation;
@end
