---
name: '"源力设计系统 (Yuanli Design System)"'
description: Design Library skill specification
---

# 源力设计系统 (Yuanli Design System)

企业级 B2B 管理后台设计规范，服务于字节跳动云服务（ByteCloud）产品线，提供高信息密度、三级骨架布局的纯 CSS/HTML 设计 Token 与组件体系。

---

## 🚨 组件实现硬规则（生成页面时必读）

**以下规则不可覆盖，违反任何一条即视为实现失败：**

1. **禁止使用 Tailwind CSS** — 本库有完整自定义 class 体系（`.top-nav`、`.sidenav`、`.menu-item`、`.data-table` 等），不允许用 `class="text-sm px-4"` 等 Tailwind 工具类替代
2. **禁止使用第三方图标库** — 不允许 Lucide/Heroicons/FontAwesome，本库有专属多色产品图标
3. **组件 HTML 必须从 preview 文件直接复制** — `preview/component-{slug}.html` 是代码模板而非视觉参考，保留所有 class 命名和 DOM 结构
4. **图标必须从片段库取** — Sidenav 图标从 `snippets/sidenav-icons.json` 按键取完整 SVG 内联
5. **样式通过 CSS 文件引入** — `colors_and_type.css` + `components.css`，不引入任何 CDN 框架

---

## 设计理念

**高信息密度** -- 面向 B2B 管理后台场景，在有限屏幕空间内高效呈现大量数据与操作入口。通过紧凑的间距栅格（4px 基准）、精细的字号层级（10px~24px）和三列图表布局，最大化信息承载能力。

**一致性** -- 统一的 Design Token 系统覆盖颜色、字体、间距、阴影、圆角五大维度，所有组件从同一套变量派生样式，确保跨页面、跨模块的视觉语言完全统一。

**可扩展性** -- Token 采用 CSS Custom Properties 实现；组件以独立 HTML 预览文件交付，便于按需提取和二次组合；语义化别名（如 `--color-primary`、`--color-surface`）解耦具体色值与使用场景。

**高效交互** -- 固化的三级骨架布局（TopNav + Sidebar + Content）为用户提供稳定的空间认知；按钮、输入框、表格等核心组件统一 32px 操作高度，降低操作精度要求；状态色体系（success/error/warning）结合前置圆点，实现信息的即时辨识。

---

## 快速上手

### 引入 Design Token

在 HTML 文件的 `<head>` 中引入 Token 样式表：

```html
<link rel="stylesheet" href="colors_and_type.css">
```

引入后，即可在任意元素上使用 CSS 变量：

```css
.my-button {
  background: var(--color-primary);
  color: var(--primary-foreground);
  border-radius: var(--radius-sm);
  height: 32px;
  padding: 5px 16px;
  font-size: var(--font-size-h4);
  line-height: var(--line-height-h4);
  font-family: var(--font-body);
}
```

### 使用组件预览

每个组件在 `preview/` 目录下都有独立的 HTML 预览文件，包含完整的结构、样式和交互状态。生成页面时，直接打开对应文件查看并提取：

```
preview/component-button.html    -- 查看按钮所有变体与状态
preview/component-table.html     -- 查看表格结构与行样式
preview/component-form.html      -- 查看表单布局与校验态
```

### 使用字体工具类

Token 文件同时提供了排版工具类，可直接应用于 HTML 元素：

```html
<h1 class="type-h1">页面标题</h1>
<p class="type-lead">正文描述内容</p>
<span class="type-caption">辅助说明</span>
```

---

## Token 系统概览

### 颜色 Token

| 分类 | Token 示例 | 值域 | 说明 |
|------|-----------|------|------|
| 主色阶 | `--primary-yuanliBlue-1` ~ `--primary-yuanliBlue-7` | #f3f7ff ~ #0055ff | 7 级蓝色递进，主色为 `--primary-yuanliBlue-6: #1664FF` |
| 中性色 | `--text-yuanliNeutral-1` ~ `--text-yuanliNeutral-11` | #ffffff ~ #000b1a | 11 级灰阶，覆盖背景到正文 |
| 边框色 | `--border-yuanliBorder-1` ~ `--border-yuanliBorder-4` | #eaedf1 ~ #959da5 | 4 级边框深度 |
| 成功色 | `--status-yuanliSuccess-2` ~ `--status-yuanliSuccess-7` | #e2f5eb ~ #189959 | 背景到文字 |
| 危险色 | `--status-yuanliDanger-2` ~ `--status-yuanliDanger-7` | #feeced ~ #c43138 | 背景到文字 |
| 警告色 | `--status-yuanliWarning-2` ~ `--status-yuanliWarning-7` | #fdf3de ~ #de9400 | 背景到文字 |
| 语义别名 | `--color-primary`, `--color-surface`, `--color-border` | 按主题映射 | 解耦色值与场景 |
| 图表色 | `--chart-1` ~ `--chart-5` | #1664ff ~ #4e5969 | 数据可视化配色 |
| 交互状态 | `--state-hover`, `--state-focus`, `--state-press` | rgba(22,100,255, 0.08/0.12/0.16) | 通用交互反馈 |

### 字体 Token

| Token | 字号 | 行高 | 用途 |
|-------|------|------|------|
| `--font-size-display` | 24px | 32px | 展示型大标题 |
| `--font-size-h1` | 20px | 28px | 一级标题 |
| `--font-size-h2` | 18px | 26px | 二级标题 / 页面标题 |
| `--font-size-h3` | 16px | 24px | 三级标题 / 模块标题 |
| `--font-size-h4` | 14px | 22px | 四级标题 / 正文操作 |
| `--font-size-lead` | 13px | 22px | 表单项 / 菜单文字 |
| `--font-size-body` | 12px | 20px | 辅助文字 / 坐标轴 |
| `--font-size-caption` | 10px | 18px | 最小辅助文字 |

字体族优先级：`PingFang SC` > `Microsoft YaHei` > `Helvetica Neue` > `Arial` > `sans-serif`

### 间距 Token

| Token | 值 | Token | 值 |
|-------|-----|-------|-----|
| `--space-1` | 4px | `--space-2` | 8px |
| `--space-3` | 12px | `--space-4` | 16px |
| `--space-5` | 20px | `--space-6` | 24px |
| `--space-8` | 32px | `--space-10` | 40px |
| `--space-12` | 48px | `--space-16` | 64px |

基准栅格：4px。所有间距均为 4 的整数倍。

### 圆角 Token

| Token | 值 | 用途 |
|-------|-----|------|
| `--radius-sm` | 4px | 按钮、输入框、Tag、卡片 |
| `--radius-md` | 8px | 弹窗、抽屉 |
| `--radius-lg` | 12px | 大型容器 |
| `--radius-xl` | 16px | 特殊场景 |
| `--radius-full` | 9999px | 圆形头像、胶囊按钮 |

### 阴影 Token

| Token | 值 | 用途 |
|-------|-----|------|
| `--shadow-1` | `0px 1px 2px 0px rgba(12,13,14,0.05)` | 微弱浮起，静态卡片 |
| `--shadow-2` | `0px 2px 6px 0px rgba(12,13,14,0.08)` | 导航栏底阴影 |
| `--shadow-3` | `0px 5px 15px rgba(12,13,14,0.08), 0px 2px 4px rgba(12,13,14,0.04)` | 下拉面板 |
| `--shadow-4` | `0px 15px 35px -2px rgba(12,13,14,0.1), 0px 5px 15px rgba(12,13,14,0.06)` | 弹窗 / Modal |
| `--shadow-5` | `0px 24px 48px -4px rgba(12,13,14,0.12), 0px 8px 20px rgba(12,13,14,0.08)` | 最大浮起层 |

---

## 组件清单

### 操作类

| 组件 | 预览文件 | 说明 |
|------|----------|------|
| Button | `preview/component-button.html` | 按钮（Primary / Default / Text / Disabled） |
| Dropdown | `preview/component-dropdown.html` | 下拉菜单 |

### 导航类

| 组件 | 预览文件 | 说明 |
|------|----------|------|
| Anchor | `preview/component-anchor.html` | 锚点导航 |
| Breadcrumb | `preview/component-breadcrumb.html` | 面包屑 |
| Pagination | `preview/component-pagination.html` | 分页器 |
| Sidenav | `preview/component-sidenav.html` | 侧边导航栏 |
| Steps | `preview/component-steps.html` | 步骤条 |
| Tabs | `preview/component-tabs.html` | 标签页 |
| TopNav | `preview/component-topnav.html` | 顶部导航栏 |

### 数据展示类

| 组件 | 预览文件 | 说明 |
|------|----------|------|
| Avatar | `preview/component-avatar.html` | 头像 |
| Badge | `preview/component-badge.html` | 徽标数 |
| Descriptions | `preview/component-descriptions.html` | 描述列表 |
| Icon | `preview/component-icon.html` | 图标 |
| Progress | `preview/component-progress.html` | 进度条 |
| StatusTag | `preview/component-status-tag.html` | 状态标签（文字/面/描边 3 变体） |
| Table | `preview/component-table.html` | 数据表格 |
| Tooltip | `preview/component-tooltip.html` | 文字气泡提示 |

### 数据录入类

| 组件 | 预览文件 | 说明 |
|------|----------|------|
| Cascader | `preview/component-cascader.html` | 级联选择器 |
| Checkbox | `preview/component-checkbox.html` | 多选框 |
| Form | `preview/component-form.html` | 表单 |
| Input | `preview/component-input.html` | 输入框 |
| SegmentedPicker | `preview/component-segmented-picker.html` | 分段选择器 |
| Select | `preview/component-select.html` | 下拉选择器 |
| Slider | `preview/component-slider.html` | 滑动输入条 |
| Switch | `preview/component-switch.html` | 开关 |
| TimePicker | `preview/component-timepicker.html` | 时间选择器 |

### 反馈类

| 组件 | 预览文件 | 说明 |
|------|----------|------|
| Alert | `preview/component-alert.html` | 警告提示（Info/Error/Success/Warning） |
| Drawer | `preview/component-drawer.html` | 抽屉 |
| Message | `preview/component-message.html` | 全局消息提示 |
| Modal | `preview/component-modal.html` | 对话框 |
| Popconfirm | `preview/component-popconfirm.html` | 气泡确认框 |

### 布局类

| 组件 | 预览文件 | 说明 |
|------|----------|------|
| PageHeader | `preview/component-page-header.html` | 页面标题（面包屑 + 标题 + Tag + 按钮 + Tab） |

---

## 页面骨架

源力设计系统采用固定的三级骨架布局，所有页面必须遵循此结构：

```
+------------------------------------------------------------------+
|                      TopNav (48px)                                |
+------------------------------------------------------------------+
|            |                                                      |
|  Sidebar   |               Content                               |
|  (200px)   |             (flex: 1)                               |
|            |                                                      |
|            |                                                      |
|            |                                                      |
+------------+-----------------------------------------------------+
```

### 结构规格

| 区域 | 尺寸 | 背景色 | 说明 |
|------|------|--------|------|
| 整页容器 | `width: 100%; height: 100vh` | -- | `overflow: hidden`，垂直布局 |
| TopNav | 高度 48px，宽度 100% | `#FFFFFF` | 底阴影 `0 2px 6px 0 #0000000D`，左侧 Logo + 汉堡按钮，右侧搜索 + 链接 + 图标 + 头像 |
| Sidebar | 宽度 200px | `#F6F8FA` | 与内容区无间距贴合，含业务标题区（58px）+ 分组菜单 + 底部折叠按钮 |
| Content | `flex: 1` 自适应 | `#FFFFFF` | 内容区距两侧 32px，模块间距 40px |

### 布局代码结构

```html
<div style="width:100%; height:100vh; overflow:hidden; display:flex; flex-direction:column;">
  <!-- TopNav -->
  <header style="height:48px; background:#fff; box-shadow:0 2px 6px 0 #0000000D; display:flex; align-items:center; justify-content:space-between;">
    ...
  </header>
  <!-- Body -->
  <div style="display:flex; flex:1; overflow:hidden;">
    <!-- Sidebar -->
    <aside style="width:200px; background:#F6F8FA; overflow-y:auto;">
      ...
    </aside>
    <!-- Content -->
    <main style="flex:1; overflow-y:auto; background:#fff; padding:0 32px;">
      ...
    </main>
  </div>
</div>
```

---

---

## 文件索引

```
yuanli-page-generator-v2/
|
+-- SKILL.md                          # 页面生成规则与设计规范文档
+-- README.md                         # 本文件 - 品牌文档
+-- colors_and_type.css               # Design Tokens (CSS Custom Properties)
|                                       含 :root 亮色变量 + 排版工具类
+-- components.css                    # 聚合组件 CSS（从 preview HTML 提取）
+-- css.json                          # Token JSON 映射（含 hex/opacity/isPrimary 元数据）
+-- library-consumption.json          # 下游消费契约（推荐读取顺序、消费层级）
+-- uikit-plan.json                   # 组件白名单、页面蓝图、slot 分配
|
+-- components/                       # 组件契约目录
|   +-- index.json                    # 组件注册表（32 个组件索引）
|   +-- alert.json                    # Alert 组件契约
|   +-- button.json                   # Button 组件契约
|   +-- table.json                    # Table 组件契约
|   +-- ... (共 32 个 {slug}.json)
|
+-- preview/                          # 组件预览 HTML（36 个文件）
|   +-- component-alert.html          # Alert 警告提示
|   +-- component-anchor.html         # Anchor 锚点导航
|   +-- component-avatar.html         # Avatar 头像
|   +-- component-badge.html          # Badge 徽标
|   +-- component-breadcrumb.html     # Breadcrumb 面包屑
|   +-- component-button.html         # Button 按钮
|   +-- component-cascader.html       # Cascader 级联选择
|   +-- component-checkbox.html       # Checkbox 多选框
|   +-- component-descriptions.html   # Descriptions 描述列表
|   +-- component-drawer.html         # Drawer 抽屉
|   +-- component-dropdown.html       # Dropdown 下拉菜单
|   +-- component-form.html           # Form 表单
|   +-- component-icon.html           # Icon 图标
|   +-- component-input.html          # Input 输入框
|   +-- component-message.html        # Message 全局提示
|   +-- component-modal.html          # Modal 对话框
|   +-- component-page-header.html    # PageHeader 页面标题
|   +-- component-pagination.html     # Pagination 分页器
|   +-- component-popconfirm.html     # Popconfirm 气泡确认
|   +-- component-progress.html       # Progress 进度条
|   +-- component-segmented-picker.html # SegmentedPicker 分段选择
|   +-- component-select.html         # Select 选择器
|   +-- component-sidenav.html        # Sidenav 侧边导航
|   +-- component-slider.html         # Slider 滑动条
|   +-- component-status-tag.html     # StatusTag 状态标签
|   +-- component-steps.html          # Steps 步骤条
|   +-- component-switch.html         # Switch 开关
|   +-- component-table.html          # Table 表格
|   +-- component-tabs.html           # Tabs 标签页
|   +-- component-timepicker.html     # TimePicker 时间选择
|   +-- component-tooltip.html        # Tooltip 气泡提示
|   +-- component-topnav.html         # TopNav 顶部导航
|   +-- ui-base-colors.html           # 基础色板展示
|   +-- ui-base-radius-shadow.html    # 圆角与阴影展示
|   +-- ui-base-spacing-tokens.html   # 间距 Token 展示
|   +-- ui-base-typography.html       # 字体排版展示
|   +-- preview-scaffold.css          # 预览页面公共样式
|
+-- snippets/                         # 片段库
|   +-- nav-logo.html                 # TopNav Logo（浅色，引用 assets/logo.svg）
|   +-- sidenav-icons.json            # Sidenav 图标片段库（53 个业务图标 SVG）
|   +-- sidenav-icons.html            # Sidenav 图标可视化预览
|
+-- assets/                           # 静态资源
|   +-- logo.svg                      # 浅色 Logo（SVG）
|   +-- icons/                        # SVG 图标（597 个）
|   |   +-- sidenav-icon/             # 侧边导航专用图标（53 个）
|   |   +-- *.svg                     # 通用图标
|
+-- ui_kits/                          # 页面样板（5 个）
    +-- detail-with-sidebar/index.html    # 带右侧信息模块的详情页
    +-- list-page/index.html   # 列表页
    +-- data-dashboard/index.html   # 数据看板页
    +-- detail-basic-page/index.html       # 基础详情页
    +-- config-page/index.html # 配置页
```

---

## 页面类型支持

源力设计系统定义了三种标准页面类型，每种类型有独立的设计规范和还原校验清单：

| 页面类型 | 背景色 | 核心构成 | 规范章节 |
|----------|--------|----------|----------|
| 列表页 | #FFFFFF | PageHeader + FilterBar + DataTable + BatchBar + Pagination | SKILL.md "列表页设计规范" |
| 详情页 | #FFFFFF | Breadcrumb + PageHeader + Tabs + DetailsDisplay + 右侧信息卡片 | SKILL.md "详情页设计规范" |
| 图表页 | #FFFFFF | 时间筛选条 + 3列图表卡片网格 + 折线图 | SKILL.md "图表页设计规范" |

---

## 品牌标识

| 属性 | 值 |
|------|-----|
| 主色名称 | 源力蓝 (Yuanli Blue) |
| 主色色值 | #1664FF |
| 字体族 | PingFang SC / Microsoft YaHei / Helvetica Neue |
| 设计基准 | 4px 栅格、32px 操作高度、48px 导航高度 |
| 适用场景 | 字节跳动云服务（ByteCloud）B2B 管理后台 |
