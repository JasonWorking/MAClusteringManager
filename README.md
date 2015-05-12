# MAClusteringManager

### Demo 

![image](https://raw.githubusercontent.com/JasonWorking/MAClusteringManager/master/makerCluster.gif)


###点聚合算法说明

MAAnnotationClustering使用基于网格的点聚合算法，即：将当前mapView上可见区域划分成等大小的网格（网格大小根据缩放等级调整）Cell[0],Cell[1],Cell[2] ...，对于Cell[i],找出位于Cell[i]范围内的所有annotaion存为数组a[]，若a[]的元素个数为0，则不需要作为一个点显示，若a[]的元素个数为1，则作为普通的点，若a[]的元素个数大于或等于2，则将a[]中所有元素的平均经纬度作为一个簇的中心经纬度，以一个MAAnnotaionCluster实例代替。
由上述算法可见，如果不对annotaions以一种便于搜索的方式存储的话，每次需要找出一个Cell的点需要遍历一次所有annotaion,复杂度为O(N),N为annotaion个数，Cell个数为M的话，算法复杂度为O(N*M).
		
		
[Quad-Tree](http://en.wikipedia.org/wiki/Quadtree)非常适合这种区域分割的搜索。可以将搜索算法的复杂度降为O(H*M),H为树的深度。

该Demo仿照[TBAnnotationClustering](https://github.com/JasonWorking/TBAnnotationClustering)写的。

### Cluster目录下

####底层数据结构： Quad Tree 
1. GTQuadTreeNode.h / .m ：为Quad-Tree中的节点类（含一些用于坐标计算的inline函数和结构体）
2. GTQuadTree.h / .m ：为Quad-Tree中类 封装了插入annotation操作 `insertAnnotaion:(id<MAAnnotaion>)annotaion`和枚举给定范围内的所有annotaion点的操作：`- (void)enumerateAnnotationsInBox:(MABoundingBox)box usingBlock:(void (^)(id<MAAnnotation> obj))block;` 


####自定义遵循MAAnotation协议的类MAAnnotationCluster : NSObject <MAAnnotation>
1. 一个该类的实例代表一个簇，annotations为该簇下的所有annotation

####MAClusteringManager类为管理者，与ViewController直接交互。
1. 初始化时将调用 `- (instancetype)initWithAnnotations:(NSArray *)annotations;`方法，该方法会建立一个Quad-Tree，将给定的annotaions存到一个Quad-Tree中，便于后面分簇时的搜索
2. 实例方法`- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect
                                 withZoomScale:(double)zoomScale;`将使一个给定的MapRect中的annotaion聚类后返回，zoomScale用来调整前述的Cell的大小。
                                 
3. 实例方法`- (void)displayAnnotations:(NSArray *)annotations
                 onMapView:(MAMapView *)mapView;`会将给定的annotation显示到mapView上，这里处理了给定的annotaions种已经有一部分显示在mapView上了，所以只会增加还没有在mapView上的部分annotaion，且会删除不在给定annotaions数组里的annotaion.

4. 所有计算操作均可以方法到一个独立的queue里去算，在`- (void)displayAnnotations:(NSArray *)annotations
                 onMapView:(MAMapView *)mapView;`中会获得mainQueue.
                 
                 
###View 目录下
 MAClusterAnnotaionView 为一个自定义的AnnotationView ，用于在mapView上显示一个圆形的图案，以表示这是一个簇，有多个annotation被聚合。圆形的大小会根据所含的annotation的个数的多少自动增大或减小。函数为： f(x) = 1 / (exp(-alpha* x *beta) + 1)

####  MAAnimator 协议
1. 定义了一个通用的加动画的操作 ： `- (void)addAnimationToView:(UIView *)view;`, 
MAClusterAnimator类为一个遵循MAAnimator的类 实现了给view加入一个bounce动画的操作


### MAClusteringManager的使用

1.在ViewController中加入

```
	@property (nonatomic, strong) MAClusteringManager *clusteringManager;
	@property (nonatomic, strong) MAClusterAnimator *animator;
```	
	
2.初始化mapView后创建clusteringManager 和 animator

```
	// annotationArray 为POI点数组
	self.clusteringManager = [[MAClusteringManager alloc] initWithAnnotations:annotationArray];
    self.clusteringManager.delegate = self;
    _animator = [MAClusterAnimator new];
```

3.在mapView的delegate回调中，在一个新的queue中进行分簇计算,`[self.clusteringManager displayAnnotations:annotations onMapView:mapView];
`

```
-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
   	 NSLog(@"center coordinate : (%f,%f)", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    double newLevel = mapView.zoomLevel;
    if (self.lastZoomLevel != newLevel) {
        NSLog(@"Zoom level changed to :%f ! ",newLevel);
        self.lastZoomLevel = newLevel;
        // When zoom level changed, We add a new operation queue to do the clustering
        [[NSOperationQueue new] addOperationWithBlock:^{
            double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
            NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
            
            // The clusteringManager will get the main queue to do the UI stuff.
            [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
        }];
    }
}

```

4.在mapView的delegate回调中根据annotion的类来判断要显示普通的annataionView还是要显示MAClusterView


```
	- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:	(id<MAAnnotation>)annotation
{
    static NSString *const AnnotatioViewReuseID = @"AnnotatioViewReuseID";
    static NSString *const ClusterAnnotationReuseID = @"ClusterAnnotationReuseID";
        
    if ([annotation isKindOfClass:[MAAnnotationCluster class]]) {
        MAAnnotationCluster *cluster = (MAAnnotationCluster *)annotation;
        cluster.title = [NSString stringWithFormat:@"%zd items",[cluster.annotations count]];
        
        MAClusterAnnotationView *clusterView = (MAClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ClusterAnnotationReuseID];
        if (!clusterView) {
            clusterView = [[MAClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ClusterAnnotationReuseID];
            clusterView.canShowCallout = YES;
            clusterView.clusterColor = (arc4random()%10)/2 == 0 ? [UIColor colorWithRed: 0.021 green: 0.422 blue: 0.884 alpha: 1] : [UIColor colorWithRed:255.0/255.0 green:95/255.0 blue:42/255.0 alpha:1.0];
        }
        
        clusterView.count = [((MAAnnotationCluster *)annotation).annotations count];
        return clusterView;
        
    }else {
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotatioViewReuseID];
        
        if (!annotationView) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotatioViewReuseID];
        }
        annotationView.pinColor = MAPinAnnotationColorRed;
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }

    
}

```

5.在增加annotation到mapView上时用animator给annotationView加bounce动画：

```
	- (void)mapView:(MAMapView *)mapView
	didAddAnnotationViews:(NSArray *)views
{
    
    __weak __typeof(self) weakSelf = self;
    [views  enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
        __strong   __typeof(weakSelf) strongSelf = weakSelf;
        if ([obj isKindOfClass:[MAClusterAnnotationView class]]) {
            [strongSelf.animator addAnimationToView:obj];
        }
    }];
}

```
 
               
   






 