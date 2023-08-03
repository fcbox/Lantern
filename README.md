# Lantern（花灯）

![](https://github.com/fcbox/Lantern/raw/master/Assets/Banner.png)


Lantern（花灯）是一个基于Swift的高可用视图框架。它基于iOS原生的图片/视频浏览功能进行封装，并提供了更加酷炫的交互方式。此外，它还提供丰富的接口，扩展灵活，能让App快速集成浏览功能。

经过我们一年多的试用和改进，现将Lantern面向社区开源，希望和大家一起改进App图片/视频浏览交互，提供更好的用户体验。

本项目由丰巢研发团队开发维护，并基于[Apache-2.0协议](http://www.apache.org/licenses/LICENSE-2.0)开源的项目，源地址为：[https://github.com/JiongXing/PhotoBrowser](https://github.com/JiongXing/PhotoBrowser)。后续将逐步全面迁移到此处，敬请留意。


## 效果预览

<div>
	<img src="https://github.com/fcbox/Lantern/raw/master/Assets/Home.gif" width = "30%" div/>
	<img src="https://github.com/fcbox/Lantern/raw/master/Assets/Show.gif" width = "30%" div/>
</div>

## 特性

- [x] 基于纯Swift开发
- [x] 支持图片、视频、图片与视频混合浏览
- [x] 支持横向和竖向滚动
- [x] 支持嵌入导航栏
- [x] 支持`push`和`present`打开
- [x] 支持数据源实时变更，框架不持有数据源
- [x] 支持自定义转场动画，框架提供了`Fade`、`Zoom`、`SoomthZoom`三个转场动画的实现
- [x] 支持自定义Cell，框架提供了常用的图片展示Cell的实现
- [x] 支持网络图片加载、查看原图加载，由用户自由选择其他框架进行图片加载与缓存
- [x] 支持各种附加控件的添加，框架提供了两种页面指示器的实现，以及在例子工程提供了加载进度环的实现

## 版本更新记录

### Version 1.1.5

> 2023/08/03

- 新增实况动图预览场景

- 新增视频图片混合场景

- 新增ImageCell拖拽视图回调

- 修复若干问题，优化图片浏览框架

### Version 1.1.4

> 2022/06/23

- 修复图片删除闪退问题

- 内存泄露优化

- 监控网络图片imageView刷新问题

- 长图显示抖动动画效果优化



### Version 1.1.2

> 2021/03/30

- 加载更多新增图片时，图片偏移问题的优化

- 网络图片加载完成后，视图刷新回调优化处理

- 自定义Cell查看原图优化

- Example的Demo文件命名规范

  

### Version 1.1.1

> 2021/01/20

- 优化屏幕旋转时闪屏修复

  

### Version 1.1.0

> 2020/09/16

- 优化LanternCell，支持子类自定义转场动画
- 优化LanternImageCell，暴露方法支持子类自定义创建视图
- 更好支持嵌入导航栏场景下的转场动画
- 视频与图片混合浏览视频的拖拽动画优化
- Example的Demo样式更新，更直观的UI样式

## 接入文档

- [环境与安装](环境与安装.md)
- [基础用法](基础用法.md)
- [高级用法](高级用法.md)

## 更新日志

- [Release Notes](ReleaseNotes.md)

> 深圳市丰巢科技有限公司成立于2015年6月6日，是一家致力以智能快递柜为切入点，提供最后一公里交付解决方案的科技公司。 

