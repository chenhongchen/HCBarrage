# HCBarrage
## 1、主要功能：
提供弹幕开始、停止、暂停、恢复、单条发送、批量发送、插入的接口；
可设定弹轨数、弹轨高度，可设定弹幕的速度和每条弹幕间的间隙；
自定义弹幕cell，可监听cell点击事件；
目前只支持水平从右到左出弹幕；

## 2、使用：
### 2.1、初始化及启用弹幕
```
// 1、初始化
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
```

### 2.2、代理
```
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
```

### 2.3、启用、停止、暂停、恢复弹幕功能
```
/// 启动弹幕功能
- (void)start;

/// 停止弹幕功能
- (void)stop;

/// 暂停弹幕
- (void)pause;

/// 恢复弹幕
- (void)resume;
```
### 2.4、发送弹幕、清除弹幕数据
```
/**
发送一条弹幕

@param barrageItem 一条弹幕数据
*/
- (void)sendOneBarrage:(HCBarrageItem *)barrageItem;

/**
发送多条弹幕

@param barrageItems 多条弹幕数据
*/
- (void)sendBarrages:(NSArray <HCBarrageItem *>*)barrageItems;

/**
清空弹幕数据
*/
- (void)clearBarrages;
```
### 2.5、插入弹幕、清除插入的弹幕数据
```
/**
插入一条弹幕

@param barrageItem 一条弹幕数据
*/
- (void)insertOneBarrage:(HCBarrageItem *)barrageItem;

/**
清空插入的弹幕数据
*/
- (void)clearInsertBarrages;
```
## 注意：
1、-barrageView:widthForItem:这个代理方法没实现，或这个方法返回值小于0，则cell的宽取cell.bound.size.width，否则取返回的width；

2、cell要继承HCBarrageCell类，弹幕数据模型要继承HCBarrageItem类；

## 说明：
参考文章：[https://www.cnblogs.com/ChengYing-Freedom/p/8025210.html](https://www.cnblogs.com/ChengYing-Freedom/p/8025210.html)
