
### 基本用法

以下代码取自项目Example例子工程，更详细完整的代码请打开例子工程查看，下文是其关键代码的讲解。

#### 1.先实例化一个图片浏览器对象。

注意每次打开图片浏览，都应该重新实例化（重新实例化的开销很小，不必担心）。

```swift
let lantern = Lantern()
```

#### 2.实时提供图片总量。

因考虑到数据源有可能是在浏览过程中变化的，所以Lantern框架（以下简称'框架'）将会在适当时机调用闭包动态获取当前用户的数据源数量，类似`UITableView`的机制。

```swift
lantern.numberOfItems = {
    self.dataSource.count
}
```

#### 3.刷新项视图。

框架的项视图(展示单张图片的View)是复用的，由最多3个视图重复使用来实现无限数量的图片浏览。

在每个项视图需要被刷新时，`reloadCellAtIndex`闭包将会被调用，用户应当在此时更新对应数据源的视图展示。

框架默认实现并使用了`LanternImageCell`作为项视图，用户也可以自由定制项视图，更多细节在下文介绍。

`LanternImageCell`有一个`imageView`视图，用户只需要对其加载图片即可正常使用。

```swift
lantern.reloadCellAtIndex = { context in
    let lanternCell = context.cell as? LanternImageCell
    let indexPath = IndexPath(item: context.index, section: indexPath.section)
    lanternCell?.imageView.image = self.dataSource[indexPath.item].localName.flatMap { UIImage(named: $0) }
}
```

#### 4.指定打开图片浏览器时定位到哪一页。

所赋的值应当在用户数据源的范围内，如数据源共有10项，则`pageIndex`允许范围是`0~9`。

```swift
lantern.pageIndex = indexPath.item
```

#### 5.显示图片浏览器

浏览器主类`Lantern`是一个`UIViewController`，支持导航栏`push`，也支持模态`present`。
框架提供的`show()`方法封装实现了常见的打开方式。

无参调用`show()`方法的时候，默认使用了`present`模态打开一个不带导航栏的图片浏览器。

```swift
lantern.show()
```

