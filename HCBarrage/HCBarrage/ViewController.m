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
@property (nonatomic, strong) HCBarrageView *barrageView;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1、初始化
    _barrageView = [[HCBarrageView alloc] init];
    [self.view addSubview:_barrageView];
    _barrageView.backgroundColor = [UIColor blackColor];
    
    // 2、配置弹轨
    HCBarrageTrackConfig *config = [[HCBarrageTrackConfig alloc] init];
    config.velocity = 100;
    config.spacing = 30;
    _barrageView.trackConfig = config;
    HCBarrageTracksSize *trackSize = [[HCBarrageTracksSize alloc] init];
    trackSize.trackCount = 3;
    trackSize.trackHeight = 50;
    _barrageView.tracksSize = trackSize;
    
    // 3、适配尺寸
    [_barrageView sizeToFit];
    CGRect rect = _barrageView.frame;
    rect.origin.y = 20;
    _barrageView.frame = rect;
    
    // 4、设置代理
    _barrageView.delegate = self;
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
    [timer fire];
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
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"刷新数据" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 0, 100, 44);
        btn.backgroundColor = [UIColor purpleColor];
        [cell.contentView addSubview:btn];
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

- (CGFloat)barrageView:(HCBarrageView *)barrageView widthForItem:(HCBarrageItem *)item
{
    return 100;
}

#pragma mark - 事件
- (void)didClickBtn
{
    NSMutableArray *barragesM = [NSMutableArray array];
    for (int i = 0; i < 30; i ++) {
        KTBarrageItem *item = [[KTBarrageItem alloc] init];
        [barragesM addObject:item];
        item.msg = [NSString stringWithFormat:@"刷新数据%d", i];
    }
    [_barrageView clearBarrages];
    [_barrageView sendBarrages:barragesM];
}
@end
