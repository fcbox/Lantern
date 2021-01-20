# Lantern（花灯）

![](https://github.com/fcbox/Lantern/raw/master/Assets/Banner.png)

## 背景

本项目由丰巢研发团队开发维护，并基于[Apache-2.0协议](http://www.apache.org/licenses/LICENSE-2.0)开源。

> 深圳市丰巢科技有限公司成立于2015年6月6日，致力以智能快递柜 
为切入点提供最后一公里交付解决方案，通过加强智能设备与人、快递及商用网点点链接，在解决末端物流配送难题上同步提供多元化的交付服务。 

> Lantern基于图片/视频浏览功能做封装，满足主流交互方式，提供丰富的接口，扩展灵活，高度定制化，可以使App快速集成浏览功能。现Lantern面向社区开源，和大家一起关注App图片/视频浏览交互的演进。

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

- [ReleaseNotes](ReleaseNotes.md)
