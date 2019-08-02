//
//  HCBarrageTrackConfig.h
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBarrageTrackConfig : NSObject
/// 弹幕速度(值越大速度越快)
@property (nonatomic, assign) CGFloat velocity;
/// 弹幕最小间距
@property (nonatomic, assign) CGFloat spacing;
@end
