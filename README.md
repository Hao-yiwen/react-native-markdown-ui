# react-native-markdownUI

[![version](https://img.shields.io/badge/version-0.1.0-blue)](package.json)
[![license](https://img.shields.io/badge/license-MIT-green)](package.json)
[![platform](https://img.shields.io/badge/native-iOS-lightgrey)](expo-module.config.json)
[![Expo SDK](https://img.shields.io/badge/Expo%20SDK-~52-000020)](package.json)

在 **iOS** 上用原生 SwiftUI 渲染 Markdown 字符串的 Expo Module。JS 侧把 `content` 交给名为 `ReactNativeMarkDownUI` 的原生视图；原生视图使用随仓库分发的 [MarkdownUI](ios/MarkdownUI.xcframework)（GitHub 主题）和 cmark-gfm 预编译框架完成排版。

这个仓库从 Expo Module 脚手架改来，示例工程的名字仍是 `expo-settings-example`。原生渲染只做了 Apple 平台。Android 入口是占位实现，仓库里没有 Web 实现，也没有发布到 npm。

## 已有能力

| 平台 | 现状 |
| --- | --- |
| iOS | `ReactNativeMarkDownUI` 原生视图。传入 Markdown 字符串，使用 MarkdownUI 的 `gitHub` 主题渲染，并按内容高度更新布局（最小高度 44，高度变化有 0.1 秒动画）。每次更新内容后发出 `onLoad`，`nativeEvent.status` 为 `"success"`。 |
| Android | `src/index.android.ts` 把组件换成 React Native 的 `Text`，原生模块是空对象。`content` 不会被当作 Markdown 渲染。 |
| Web | 没有对应实现。`src/index.ts` 注释里提到的 `ExpoSettingsModule.web.ts` 不在仓库中。 |

JS 层没有暴露换主题、自定义样式块或调用原生方法的接口。`ReactNativeMarkDownUIModule` 的 Swift 定义里只有视图、`content` 属性和 `onLoad` 事件。

示例 `example/App.tsx` 每 50ms 追加一个字符，演示这段 Markdown 的流式显示：

- 一级、二级标题
- 粗体、斜体、粗斜体
- Swift 围栏代码块
- 嵌套无序列表

## 组件属性

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| `content` | `string` | 要渲染的 Markdown 文本。 |
| `onLoad` | `(event: { nativeEvent: { status: string } }) => void` | 原生视图更新内容后触发。当前实现传入的 `status` 是 `"success"`。 |
| `style` | `StyleProp<ViewStyle>` | 传给原生视图的样式。 |

```tsx
import { ReactNativeMarkDownUI } from "react-native-markdownUI";

<ReactNativeMarkDownUI
  content={"# 标题\n\n一段 **粗体** 文本。"}
  onLoad={({ nativeEvent: { status } }) => {
    console.log(status);
  }}
  style={{ width: "100%", backgroundColor: "white", minHeight: 44 }}
/>
```

默认导出是原生模块对象（Swift 侧没有额外方法）。组件请使用具名导出 `ReactNativeMarkDownUI`，与示例一致。

## 技术栈

库本身 `dependencies` 为空，原生能力放在 `ios/`。版本取自各 `package.json` 与 lockfile。

| 依赖 | 版本 | 角色 |
| --- | --- | --- |
| expo（dev / peer `*`） | 52.0.25 | Expo Modules API：`requireNativeView`、`requireNativeModule` |
| expo-module-scripts | 4.0.3 | `build` / `lint` / `clean` 等脚本 |
| react-native（dev） | 0.76.0 | 库的开发依赖；peer 为 `*` |
| @types/react | 18.3.18 | 类型（声明范围 `~18.3.12`） |
| ExpoModulesCore | 由宿主 App 提供 | `ios/ReactNativeMarkDownUI.podspec` 的唯一 Pod 依赖 |

示例应用 `example/package.json`（lockfile 解析结果）：

| 依赖 | 版本 |
| --- | --- |
| expo | 52.0.25 |
| react | 18.3.1 |
| react-native | 0.76.6 |
| typescript | 5.7.3 |

示例开启了 New Architecture（`example/app.json` 的 `newArchEnabled`，以及 `example/ios/Podfile.properties.json`）和 Hermes。Android 工程配置为 `minSdk` 24、`compileSdk` 35、`targetSdk` 34、Kotlin 1.9.24、NDK `26.1.10909125`。

原生侧：

- Swift 源码语言版本：podspec 写明 Swift 5.4
- 预编译 MarkdownUI：`Info.plist` 版本号 1.0，最低系统 iOS 15.0，使用 Apple Swift 6.0（effective 5.10）、iOS 18.0 SDK 编译
- `cmark_gfm`、`cmark_gfm_extensions`：`Info.plist` 版本号 1.0，`MinimumOSVersion` 为 **18.0**
- podspec 声明的平台是 iOS 15.1 与 tvOS 15.1；示例 Podfile 的部署目标默认也是 15.1。xcframework 实际只有 `ios-arm64` 和 `ios-arm64_x86_64-simulator`，没有 tvOS 切片

## 目录

```text
.
├── src
│   ├── index.ts                         # 默认入口：导出模块、组件和类型
│   ├── index.android.ts                 # Android 占位入口
│   ├── ReactNativeMarkDownUI.tsx        # requireNativeView 封装
│   ├── ReactNativeMarkDownUIModule.ts   # requireNativeModule 封装
│   └── ReactNativeMarkDownUI.types.ts   # content / onLoad / style
├── ios
│   ├── ReactNativeMarkDownUI.swift      # SwiftUI 宿主视图与高度计算
│   ├── ReactNativeMarkDownUIModule.swift
│   ├── ReactNativeMarkDownUI.podspec    # 打包三个 xcframework
│   ├── MarkdownUI.xcframework
│   ├── cmark_gfm.xcframework
│   └── cmark_gfm_extensions.xcframework
├── example                              # Expo 示例，工程名 expo-settings-example
│   ├── App.tsx                          # 逐字追加 Markdown 的演示
│   ├── app.json                         # 应用名、bundle id、New Architecture
│   ├── metro.config.js                  # 把包名指向上级目录
│   ├── ios                            # 预生成的 iOS 工程（CocoaPods）
│   └── android                        # 预生成的 Android 工程
├── expo-module.config.json              # platforms 只有 apple
├── package.json                         # 包名 react-native-markdownUI，版本 0.1.0
└── tsconfig.json                        # 输出目录 build/
```

`example` 的显示名、slug、iOS bundle identifier 和 Android `applicationId` 都是脚手架留下的 `expo-settings-example` / `expo.modules.settings.example`。

## 环境要求

编译 JS 包：

- Node.js。本文档的安装与构建在 Node.js 22.23.4、npm 10.9.9 上跑通
- 本机若能找到 `yarn`，`expo-module` 的脚本会通过 `yarn exec` 调用 `tsc`（当前环境为 Yarn 1.22.22）

运行示例的 iOS 原生界面还需要：

- macOS、Xcode、CocoaPods
- 与上面框架最低系统一致的模拟器或真机。cmark 两个框架的 `MinimumOSVersion` 是 18.0，而 Podfile / podspec 仍写着 15.1

自定义原生视图不能在 Expo Go 里加载，需要 `expo run:ios` 这类开发构建。

## 安装与运行

包名含有大写字母。向 npm registry 查询 `react-native-markdownUI` 会得到 404，并提示名称不能包含大写字母，因此不能用 `npm install react-native-markdownUI` 从公共 registry 安装。示例通过 Metro 别名直接引用仓库根目录。

### 编译模块

在仓库根目录：

```bash
npm ci
npm run build
```

`package.json` 的 `main` 是 `build/index.js`，`types` 是 `build/index.d.ts`。`build/` 已写入 `.gitignore`。

`expo-module-build` 在交互终端、且未设置 `CI` 或 `EXPO_NONINTERACTIVE` 时会加上 `--watch` 并保持进程。只要一次性编译时：

```bash
CI=1 npm run build
```

本次在非 TTY 的终端中执行 `npm ci --ignore-scripts` 与 `npm run build`，编译成功并生成 `build/`。`npm run lint`（`expo-module lint`）退出码为 0，现有源码有 19 条 Prettier / import 顺序警告、没有 error。

`npm test` 对应 `expo-module test`，会启动交互式 Jest watcher。仓库里没有 `__tests__`，这里没有跑测试。

### 运行 iOS 示例

以下步骤需要 macOS 与 Xcode。当前环境是 Linux，没有执行。

```bash
# 仓库根目录
npm ci
CI=1 npm run build

cd example
npm ci
npx expo run:ios
```

示例已经配置好本地联调：

- `example/package.json` 的 `expo.autolinking.nativeModulesDir` 指向仓库根目录
- `example/metro.config.js` 监听上级目录，并把 `react-native-markdownUI` 解析到 `..`
- `example/tsconfig.json` 把同一包名映射到 `../src/index`

根目录还有两个只能在 macOS 上使用的脚本：`npm run open:ios`（`xed example/ios`）、`npm run open:android`（`open -a "Android Studio"`）。

### Android 示例

`example/android` 是 Expo 预生成工程，脚本为：

```bash
cd example
npm run android
```

即便工程能编过，模块在 Android 上仍是上面的 `Text` 占位，看不到 Markdown 排版。本环境没有安装 Android SDK / 模拟器，没有编译或启动该工程。

### 接到自己的 Expo 应用

把本仓库作为本地路径或 git 依赖放进应用的 `node_modules` 后，Expo autolinking 会读取 `expo-module.config.json`，只注册 Apple 模块 `ReactNativeMarkDownUIModule`。iOS 需要重新执行 prebuild / `pod install`（`npx expo run:ios` 会带上这一步）。Android 与 Web 没有对应原生实现。

## 脚本

| 命令 | 作用 |
| --- | --- |
| `npm run build` | `expo-module build`，把 `src/` 编译到 `build/` |
| `npm run clean` | `expo-module clean`，删除编译产物 |
| `npm run lint` | `expo-module lint` |
| `npm test` | `expo-module test`，交互式 Jest |
| `npm run prepare` / `npm run prepublishOnly` | Expo Module 的发布前脚本 |
| `npm run open:ios` / `npm run open:android` | 用 macOS 打开示例的 Xcode / Android Studio 工程 |

## 备注

- 许可：`package.json` 声明为 MIT。仓库根目录没有单独的 `LICENSE` 文件。
- 作者与仓库：`yw.hao`，<https://github.com/Hao-yiwen/react-native-markdown-ui>。
- 主题写死为 MarkdownUI 的 `.gitHub`，JS 不能切换。
- 原生视图在主线程替换 SwiftUI 根视图，并用 `systemLayoutSizeFitting` 计算高度。
- 仓库里的图片是 Expo 模板图标和启动图（`example/assets/`、各平台资源目录），没有 Markdown 界面截图。
