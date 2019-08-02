//
//  HCBarrageCell.m
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//

#import "HCBarrageCell.h"

@interface HCBarrageCell ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation HCBarrageCell
#pragma mark - 懒加载
- (UIView *)contentView
{
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

#pragma mark - 初始化
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
@end
