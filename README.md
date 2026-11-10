# netPlayer Web

## 简介

<img src="./assets/icon.png" width="100px">

![License](https://img.shields.io/badge/License-MIT-dark_green)

**基于Subsonic API的播放器**

[netPlayer Next](https://github.com/Zhoucheng133/netPlayer-Next) | [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile) | **★ netPlayer Web**

这是[netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile)的分支版本，用来以网页的形式搭建netPlayer (PWA)

## 功能

详细见[netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile)仓库，区别如下

|功能|netPlayer Mobile|netPlayer Web|
|-|-|-|
|下载歌曲和离线播放|✅|❌
|歌词|✅|❌
|远程控制桌面版netPlayer|✅|❌

## 使用

直接部署Release的静态页面文件即可

> [!IMPORTANT]
> 注意不要混用http和https服务，https页面无法请求http的接口

另外本项目支持PWA安装在你的设备上，在一些移动设备上底部的导航条可能遮挡内容，你可以在设置中设置底部的空隙

## 在你的设备上构建

- 安装Flutter，安装步骤见[Flutter - Quick start](https://docs.flutter.cn/get-started/quick)，本项目使用的Flutter版本为`3.41.6`
- 使用这个命令构建
  ```bash
  flutter build web
  ```

## 一些API

[Subsonic API](http://www.subsonic.org/pages/api.jsp)