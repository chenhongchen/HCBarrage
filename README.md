# HCBarrage
## 1、主要功能：提供单条发送、批量发送、插入弹幕的接口；可设定弹轨数、弹轨高度，可设定弹幕的速度和每条弹幕间的间隙；自定义弹幕cell；目前只支持水平从右到左出弹幕；

## 2、使用：
### 2.1、初始化
```
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

### 2.3、发送和清除为发送的弹幕
```
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
```
## 注意：
-barrageView:widthForItem:这个代理方法没实现，或返回值小于0，则宽取cell.bound.size.width；
cell要继承HCBarrageCell类，弹幕数据模型要集成HCBarrageItem类；

## 说明：
参考文章：![](https://www.cnblogs.com/ChengYing-Freedom/p/8025210.html)
