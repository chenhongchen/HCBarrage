//
//  KTBarrageCell.m
//  HCBarrage
//
//  Created by chc on 2019/8/2.
//  Copyright © 2019 CHC. All rights reserved.
//

#import "KTBarrageCell.h"

@interface KTBarrageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation KTBarrageCell
#pragma mark - 懒加载
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        UILabel *textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:textLabel];
        _textLabel = textLabel;
        textLabel.numberOfLines = 1;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = [UIColor whiteColor];
    }
    return _textLabel;
}

#pragma mark - 外部方法
- (void)setItem:(KTBarrageItem *)item
{
    _item = item;
    [self setupData];
    [self setupFrame];
}

- (void)setupData
{
    KTBarrageItem *item = (KTBarrageItem *)_item;
    self.textLabel.text = item.msg;
}

- (void)setupFrame
{
    CGFloat selfH = CGRectGetHeight(self.frame);
    [self.textLabel sizeToFit];
    CGRect rect = self.textLabel.frame;
    rect.size.height = selfH;
    self.textLabel.frame = rect;
    
    rect = self.frame;
    rect.size.width = self.textLabel.bounds.size.width;
    self.frame = rect;
    
    self.contentView.frame = self.bounds;
}

@end
