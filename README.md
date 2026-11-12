# netPlayer Web

**简体中文** | [English](./document/en.md)

## 简介

<img src="./assets/icon.png" width="100px" alt="netPlayer Web Logo">

[![License](https://img.shields.io/badge/License-MIT-dark_green)](./LICENSE)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.41.6-blue)](https://flutter.dev)

**基于 Subsonic API 的优雅网页端音乐播放器**

[netPlayer Next](https://github.com/Zhoucheng133/netPlayer-Next) | [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile) | **★ netPlayer Web**

这是 [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile) 的 Web 分支版本，支持作为 PWA（渐进式网页应用）安装到您的设备上随时随地使用。

---

## 功能对比

详细功能请参考 [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile) 仓库。与移动端相比，Web 端的差异如下：

| 功能 | netPlayer Mobile | netPlayer Web |
| :--- | :---: | :---: |
| 下载歌曲和离线播放 | ✅ | ❌ |
| 歌词展示 | ✅ | ❌ |
| 远程控制桌面版 netPlayer | ✅ | ❌ |

---

## 部署与使用

### 1. 直接部署
直接将 Release 发布的静态页面文件部署到任意静态托管服务（如 GitHub Pages、Vercel、Netlify 等）即可。本项目已内置 GitHub Actions 自动部署工作流（位于 `.github/workflows/deploy.yml`）。

> [!IMPORTANT]
> - **协议注意**：请避免混用 HTTP 与 HTTPS 服务。若您的网页部署在 HTTPS 下，将无法请求 HTTP 的 Subsonic API 接口。
> - **iOS PWA 注意**：若在 iOS 设备上以 PWA 方式使用，建议保持应用在前台运行，后台运行可能会导致无法自动切换下一首歌曲。

### 2. PWA 适配
本项目支持安装为 PWA。在部分移动设备的浏览器中，底部系统导航条可能会遮挡内容，您可以在**设置**中调整底部边距/空隙。

---

## 本地构建与开发

1. 安装 Flutter（本项目使用版本为 **`3.41.6`**），详见 [Flutter 官方文档](https://docs.flutter.dev/get-started/install)。
2. 克隆仓库并安装依赖：
   ```bash
   git clone https://github.com/Zhoucheng133/netPlayer-Web.git
   cd netPlayer-Web
   flutter pub get
   ```
3. 构建 Web 版本：
   ```bash
   flutter build web
   ```
   若要部署到子路径（如 GitHub Pages），请指定 `--base-href`：
   ```bash
   flutter build web --base-href /netPlayer-Web/
   ```

---

## 相关链接

- [Subsonic API 文档](http://www.subsonic.org/pages/api.jsp)
- [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile)
