# netPlayer Web

[简体中文](../README.md) | **English**

## Introduction

<img src="../assets/icon.png" width="100px" alt="netPlayer Web Logo">

[![License](https://img.shields.io/badge/License-MIT-dark_green)](../LICENSE)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.41.6-blue)](https://flutter.dev)

**An elegant web-based music player powered by the Subsonic API.**

[netPlayer Next](https://github.com/Zhoucheng133/netPlayer-Next) | [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile) | **★ netPlayer Web**

This is a web-focused fork/adaptation of [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile), designed to run seamlessly in browsers as a PWA (Progressive Web App).

---

## Feature Comparison

For detailed features, please refer to the [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile) repository. Key differences on the Web version:

| Feature | netPlayer Mobile | netPlayer Web |
| :--- | :---: | :---: |
| Song download & offline playback | ✅ | ❌ |
| Lyrics | ✅ | ❌ |
| Remote control desktop netPlayer | ✅ | ❌ |

---

## Deployment & Usage

### 1. Static Hosting Deployment
Deploy the static build files from the Release artifacts to any static hosting provider (e.g., GitHub Pages, Vercel, Netlify). This repository includes a built-in GitHub Actions workflow (`.github/workflows/deploy.yml`) for automatic deployment to GitHub Pages.

> [!IMPORTANT]
> - **Protocol Mixing**: Avoid mixing HTTP and HTTPS. If your web app is hosted via HTTPS, it cannot send requests to an HTTP-only Subsonic server.
> - **iOS PWA Note**: When running as a PWA on iOS, it is recommended to keep the app in the foreground. Background execution may occasionally prevent automatic track switching.

### 2. PWA Support
This project supports PWA installation. On some mobile devices, the bottom navigation bar might overlap with content; you can adjust the bottom spacing in the app settings.

---

## Local Build & Development

1. Install Flutter (this project uses Flutter **`3.41.6`**). See [Flutter Installation Guide](https://docs.flutter.dev/get-started/install).
2. Clone the repository and install dependencies:
   ```bash
   git clone https://github.com/Zhoucheng133/netPlayer-Web.git
   cd netPlayer-Web
   flutter pub get
   ```
3. Build for web:
   ```bash
   flutter build web
   ```
   For custom subpath deployments (e.g., GitHub Pages), specify `--base-href`:
   ```bash
   flutter build web --base-href /netPlayer-Web/
   ```

---

## Links

- [Subsonic API Reference](http://www.subsonic.org/pages/api.jsp)
- [netPlayer Mobile](https://github.com/Zhoucheng133/netPlayer-Mobile)
