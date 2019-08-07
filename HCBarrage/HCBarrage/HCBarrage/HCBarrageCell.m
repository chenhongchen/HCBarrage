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

#pragma mark - 外部方法
- (void)pauseAnimation
{
    // 取出当前的时间点，就是暂停的时间点
    CFTimeInterval pausetime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 设定时间偏移量，让动画定格在那个时间点
    [self.layer setTimeOffset:pausetime];
    
    // 将速度设为0
    [self.layer setSpeed:0.0f];
    
}

- (void)resumeAnimation
{
    // 获取暂停的时间
    CFTimeInterval pausetime = self.layer.timeOffset;
    
    // 计算出此次播放时间(从暂停到现在，相隔了多久时间)
    CFTimeInterval starttime = CACurrentMediaTime() - pausetime;
    
    // 将时间偏移量设为0(重新开始)；
    self.layer.timeOffset = 0.0;
    
    // 设置开始时间(beginTime是相对于父级对象的开始时间,系统会根据时间间隔帮我们算出什么时候开始动画)
    self.layer.beginTime = starttime;
    
    // 将速度恢复，设为1
    self.layer.speed = 1.0;
    
}

#pragma mark - 初始化
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)dealloc
{
//    NSLog(@"dealloc -- HCBarrageCell");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
@end
