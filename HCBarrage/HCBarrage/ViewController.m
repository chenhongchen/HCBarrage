//
//  ViewController.m
//  HCBarrage
//
//  Created by chc on 2019/8/1.
//  Copyright © 2019 CHC. All rights reserved.
//
//屏幕的尺寸
#define kScreenF   [[UIScreen mainScreen] bounds]
//屏幕的高度
#define kScreenH  CGRectGetHeight(kScreenF)
//屏幕的宽度
#define kScreenW  CGRectGetWidth(kScreenF)

#import "ViewController.h"
#import "HCBarrageTrackView.h"
#import "HCBarrageView.h"
#import "KTBarrageCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, HCBarrageViewDelegate>
@property (nonatomic, weak) HCBarrageView *barrageView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1、初始化弹幕
    HCBarrageView *barrageView = [[HCBarrageView alloc] init];
    [self.view addSubview:barrageView];
    _barrageView = barrageView;
    _barrageView.backgroundColor = [UIColor blackColor];
    
    // 2、配置弹轨属性
    HCBarrageTrackConfig *config = [[HCBarrageTrackConfig alloc] init];
    config.velocity = 100;
    config.spacing = 30;
    _barrageView.trackConfig = config;
    
    // 3、设置弹轨size
    HCBarrageTracksSize *trackSize = [[HCBarrageTracksSize alloc] init];
    trackSize.trackCount = 3;
    trackSize.trackHeight = 50;
    _barrageView.tracksSize = trackSize;
    
    // 4、适配尺寸
    [_barrageView sizeToFit];
    CGRect rect = _barrageView.frame;
    rect.origin.y = 20;
    _barrageView.frame = rect;
    
    // 5、设置代理
    _barrageView.delegate = self;
    
    // 6、启用弹幕
    [_barrageView start];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(_barrageView.frame);
    CGFloat width = kScreenW;
    CGFloat height = kScreenH - y;
    tableView.frame = CGRectMake(x, y, width, height);
}

-(void)sendMessage
{
    KTBarrageItem *item = [[KTBarrageItem alloc] init];
    item.userName = @[@"张三",@"李四",@"王五",@"赵六",@"七七",@"八八",@"九九",@"十十",@"十一",@"十二",@"十三",@"十四"][arc4random()%12];
    item.msg = @[@"阿达个人",@"都是vsqe12qwe",@"胜多负少的凡人歌,胜多负少的凡人歌,胜多负少的凡人歌",@"委屈翁二群二",@"12312",@"热帖柔荑花",@"发彼此彼此",@"OK泼墨",@"人体有图图",@"额外热无若无",@"微软将围"][arc4random()%11];
    [_barrageView sendOneBarrage:item];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIButton *insterBtn = [[UIButton alloc] init];
        [insterBtn setTitle:@"插入" forState:UIControlStateNormal];
        [insterBtn addTarget:self action:@selector(didClickInsterBtn) forControlEvents:UIControlEventTouchUpInside];
        insterBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 0, 40, 44);
        insterBtn.backgroundColor = [UIColor purpleColor];
        [cell.contentView addSubview:insterBtn];
        
        UIButton *resumeBtn = [[UIButton alloc] init];
        [resumeBtn addTarget:self action:@selector(didClickResumeBtn) forControlEvents:UIControlEventTouchUpInside];
        [resumeBtn setTitle:@"继续" forState:UIControlStateNormal];
        [cell.contentView addSubview:resumeBtn];
        resumeBtn.backgroundColor = [UIColor grayColor];
        resumeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 40, 44);
        
        UIButton *pauseBtn = [[UIButton alloc] init];
        [pauseBtn addTarget:self action:@selector(didClickPauseBtn) forControlEvents:UIControlEventTouchUpInside];
        [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [cell.contentView addSubview:pauseBtn];
        pauseBtn.backgroundColor = [UIColor grayColor];
        pauseBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 0, 40, 44);
        
        UIButton *stopBtn = [[UIButton alloc] init];
        [stopBtn addTarget:self action:@selector(didClickStopBtn) forControlEvents:UIControlEventTouchUpInside];
        [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [cell.contentView addSubview:stopBtn];
        stopBtn.backgroundColor = [UIColor grayColor];
        stopBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 160, 0, 40, 44);
        
        UIButton *startBtn = [[UIButton alloc] init];
        [startBtn addTarget:self action:@selector(didClickStartBtn) forControlEvents:UIControlEventTouchUpInside];
        [startBtn setTitle:@"开始" forState:UIControlStateNormal];
        [cell.contentView addSubview:startBtn];
        startBtn.backgroundColor = [UIColor grayColor];
        startBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 40, 44);
        
        UIButton *removeBtn = [[UIButton alloc] init];
        [removeBtn addTarget:self action:@selector(didClickRemoveBtn) forControlEvents:UIControlEventTouchUpInside];
        [removeBtn setTitle:@"移除" forState:UIControlStateNormal];
        [cell.contentView addSubview:removeBtn];
        removeBtn.backgroundColor = [UIColor grayColor];
        removeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 240 - 10, 0, 40, 44);
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    KTBarrageItem *item = [[KTBarrageItem alloc] init];
    item.msg = [NSString stringWithFormat:@"点击了第 %ld 行", indexPath.row];
    [_barrageView insertOneBarrage:item];
}

#pragma mark - UITableViewDelegate
- (HCBarrageCell *)barrageView:(HCBarrageView *)barrageView cellForItem:(HCBarrageItem *)item
{
    static NSString *identifier = @"KTBarrageCell";
    HCBarrageCell *cell = [barrageView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[KTBarrageCell alloc] initWithReuseIdentifier:identifier];
        NSLog(@"创建cell");
    }
    cell.frame = CGRectMake(0, 0, 0, _barrageView.tracksSize.trackHeight);
    cell.item = item;
    return cell;
}

//- (CGFloat)barrageView:(HCBarrageView *)barrageView widthForItem:(HCBarrageItem *)item
//{
//    return 100;
//}

- (void)barrageView:(HCBarrageView *)barrageView didClickCellForItem:(HCBarrageItem *)item
{
    NSString *msg = [NSString stringWithFormat:@"点击了弹幕:%@", ((KTBarrageItem *)item).msg];
    UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alterView show];
}

#pragma mark - 事件
- (void)didClickInsterBtn
{
    [_barrageView start];
    NSMutableArray *barragesM = [NSMutableArray array];
    for (int i = 0; i < 30; i ++) {
        KTBarrageItem *item = [[KTBarrageItem alloc] init];
        [barragesM addObject:item];
        item.msg = [NSString stringWithFormat:@"插入数据%d", i];
    }
    [_barrageView clearBarrages];
    [_barrageView sendBarrages:barragesM];
}

- (void)didClickStopBtn
{
    [_barrageView stop];
    [_timer invalidate];
}

- (void)didClickStartBtn
{
    // 6、启用弹幕
    [_barrageView start];
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)didClickPauseBtn
{
    [_barrageView pause];
}

- (void)didClickResumeBtn
{
    [_barrageView resume];
}

- (void)didClickRemoveBtn
{
    [_barrageView removeFromSuperview];
}
@end
