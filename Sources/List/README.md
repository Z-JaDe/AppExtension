# ListAdapter
iOS ListAdapter

## 目标
* 尽量不使用runtime等操作
* 在支持TableView、CollectionView的同时，可以便捷扩展到其他列表类
* 在可以一键使用的同时，保证可以自由使用任意组件，低粒度降低耦合性
* 不使用Rx、Diff等三方库，但是提供接口，方便扩展

## 拆分List
分为Core、Table、Collection模块
* Core不涉及UI，只做逻辑性封装
* Table包含了局部动画刷新、静态Cell、

## 组件细分
* UI刷新
* 对比新旧数据Diff
* Model解析成Cell 
* 高度计算
* 高度缓存
* TableView常见静态Cell封装
* 多种类型Cell支持