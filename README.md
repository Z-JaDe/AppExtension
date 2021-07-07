# AppExtension

[![CI Status](https://travis-ci.org/Z-JaDe/AppExtension.svg?branch=master)](https://travis-ci.org/Z-JaDe/AppExtension)
![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat)
![Swift version](https://img.shields.io/badge/swift-5.1-orange.svg)

App框架


## iOS开发排雷手册
以下几点需要正确理解。

### 一、在dealloc中设置属性
如 一个类有一个数组属性array，在dealloc中添加清空数组逻辑 写成

```objective-c
- (void)dealloc {
    _array = [NSMutableArray array];
}
```
乍一看就是是在清空数组，实际上是在释放self时给self的属性赋值，安排的妥妥的
### 二、把dealloc写在分类里面
因为dealloc比较特殊，所以一般人会认为它就像load方法一样可以在分类里面被自动调用。实际上写在分类里面会覆盖主类实现，找个UIViewController分类，在里面隐晦的写成
```objective-c
@implementation UIViewController (DiDiao)
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
```
乍一看是在释放通知，实际上因为写在分类里面，导致主类资源回收异常，崩起来连原因都找不到。
### 三、把对象属性声明成assign
这个一般比较容易发现，不过如果是二方库Bundle化，悄悄的在m文件里面私有声明，在主工程根本搜索不到。一旦成功隐藏bug，指针野起来，什么Crash检测工具都不好使。
普通属性声明比较容易发现，必要时可以利用OBJC_ASSOCIATION_ASSIGN和OBJC_ASSOCIATION_RETAIN_NONATOMIC达到目的，一般人想不到。
### 四、巧用运行时
运行时是个好东西，一方面能体现自己见多识广，也能对代码任意扩展。
- 多用用SizzleSelector，轻松替换原有实现，能涉及整个App，测试同学总会灵魂拷问: "为啥别的app正常，你这里就不行"
- 在必要的时候使用NSClassFromString创建类，生成对象，美其名曰解耦。
- 可以通过字符串拼接生成类名，如类HomeCell和HomeModel，完全可以根据HomeModel获取类名@"HomeModel"，再截掉@"Model"，拼上@"Cell"，得到@"HomeCell"，这样就能轻易实现两个类的绑定，不是你自己，别人都不知道。如果后来者觉得HomeCell无用把它删了。出现问题，也可以轻松甩锅: "谁让你乱动代码的?，不懂别动！"
### 五、多用魔法数
- 比较常见的场景是网络数据，无需格式化，直接解析成字典或者数组，轻松实现代码。别人苦逼用了好长时间建立模型，你直接用字典光速实现逻辑，老板都对你投来赞许的目光，加油！
- 多用 0 1 2 true false，少用枚举。不过缺点是要悄悄写个文档备注下 0 1 2分别代表什么意思，要不过两天你自己都忘了。
### 六、在子线程更新UI
不必多说，轻则让同事调试半天怀疑人生: "明明设置了属性却没作用？" 重则线上Crash。
### 七、一个方法写上个几百行，一个类定义个几十个方法
一方面方便向老板展示项目的复杂度，另一方面，除了你别人也不好维护，也不敢动。牢牢把握地位。
### 八、延时操作
如果一些代码流程问题，巧用dispatch_after，让代码自己过一会儿跑跑看。这样的写法即使同事也不好指责你，毕竟代码流程问题有可能本身就是他埋下的。
### 九、打乱界面生命周期
- 在界面出现前主动调用控制器的self.view，因为隐晦的提前调用了viewDidLoad
- viewDidAppear不写super，或者写成 

```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
```
虽然现在没啥问题，但是有可能在你离职后第N天，才出现了莫名其妙的问题: "View怎么创建了2次？", "属性明明创建了但是没作用？", 同事们直呼小可爱。
### 十、在Base类中添加业务代码
在Base中巧用isKindOfClass，写上几个ifelse，判断当前是A类时处理XXX,当前是B类时处理XXXX。让同事想要重构时 XCode直接Error 999+。
### 十一、高度抽象业务代码
结合消息转发、继承、Merge、Zip几个方式组合使用，高度抽象业务代码，让其他人都捉摸不透你封装的代码在哪里: "这代码怎么跑通的？"。牢牢把握架构师角色，你的项目只能你来架构。

### 附加
- 多把问题甩给系统、缓存: "抓捕周树人和我鲁迅有什么关系？"
- 巧妙运用内存泄露: "明明什么都没动，内存却悄悄的稳步上涨"
- 在一些高频方法里面添加一些看起来高深实际上没啥用的逻辑，最好绕几个弯: "虽然没崩溃，但是App用起来就是卡卡的"
