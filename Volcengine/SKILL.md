---
name: "源力设计系统 (Yuanli Design System)"
description: Design Library skill specification
---

> ## 🚨 PRD 驱动页面生成规则（最高优先级）
>
> 当根据用户输入的 PRD（产品需求文档）生成页面时，**必须**遵循以下流程：
>
> 1. **完整阅读 PRD**：逐段精读 PRD 全文，不可跳读或粗略扫描
> 2. **提取页面清单**：列出 PRD 中涉及的所有独立页面（主页面 + 子页面 + 弹窗/抽屉）
> 3. **分析交互状态**：识别每个页面中的所有支线交互状态，包括但不限于：
>    - 空状态 / 加载状态 / 错误状态
>    - 表单校验失败状态
>    - 弹窗/抽屉/确认框
>    - 展开/收起、切换 Tab 后的内容变化
>    - 不同角色/权限下的差异视图
>    - 批量操作 / 选中状态
> 4. **逐一实现**：确保每个页面和每个交互状态都被生成，不可遗漏任何 PRD 中描述的内容
>
> **判断标准**：PRD 中描述的每一个页面、每一种交互状态，在最终输出中都必须有对应实现。遗漏任何页面或状态 = 实现不完整。

> ## 🚨 组件实现硬规则（最高优先级，不可覆盖）
>
> ### 强制流程
>
> 1. **匹配模板**：根据页面类型从 `ui_kits/` 选择最接近的模板：
>    | 页面需求 | 模板路径 |
>    |---------|---------|
>    | 列表页（带tab） | `ui_kits/list-page/index.html` |
>    | 列表页（不带tab） | `ui_kits/list-page-no-tabs/index.html` |
>    | 数据看板 | `ui_kits/data-dashboard/index.html` |
>    | 基础详情页（无tab） | `ui_kits/detail-basic-page/index.html` |
>    | 详情页（带tab） | `ui_kits/detail-tab-page/index.html` |
>    | 带右侧信息模块的详情页 | `ui_kits/detail-with-sidebar/index.html` |
>    | 配置页 | `ui_kits/config-page/index.html` |
>
>    **有匹配模板时**：Read 模板完整 HTML 作为骨架 → 保留 TopNav + Sidenav + 布局不动 → 只修改内容区
>
>    **无匹配模板时**：从任意模板中复制 TopNav + Sidenav + PageHeader 骨架 → 内容区从 `preview/component-{slug}.html` 自由组合组件
>
> 2. **组件使用**：所有组件从 `preview/component-{slug}.html` **原样复制** HTML 插入（包括所有 class 名、内联 SVG、DOM 结构），仅改文字和数据
>
> 3. **Dispatch 规则（面向调度层）**：生成任何页面时，dispatch 指令中**必须**写 `Read ui_kits/{type}/index.html`（或 `Read ui_kits/list-page/index.html` 取骨架），让 Sub-Agent 自行读取文件。**禁止**在 dispatch 文本中描述/转述模板结构代替文件读取——无论页面多复杂，Sub-Agent 都必须直接 Read 原始文件获取完整 HTML。
>
> **判断标准**：生成代码中每个组件的 CSS class 名必须与 preview / UI Kit 中**完全一致**。写出了 preview 中不存在的 class 名 = 实现失败。
>
> ### 禁止清单
>
> | 禁止项 | 原因 |
> |--------|------|
> | Tailwind CSS（`class="text-sm px-4 bg-gray-100"` 等） | 与本库自定义 class 冲突 |
> | Lucide / Heroicons / FontAwesome / 任何第三方图标库 | 本库有专属多色图标 |
> | 自行编写简化 SVG 代替库中图标 | 库中 SVG 含 linearGradient/filter，手写无法还原 |
> | 改变 preview 中的 class 命名或 DOM 层级 | 必须保持原始结构 |
> | CDN 引入 Tailwind/Bootstrap/图标库 | 页面必须自包含 |
> | 给组件额外添加 `border` 属性 | 本库中 `.checkbox-box`、`.select-labeled` 等组件使用 `box-shadow` 模拟边框，若页面样式再加 `border` 会导致双重描边。禁止在页面 `<style>` 中对这些组件写 `border` |
>
> ### 图标规则
>
> - **Sidenav 图标**：从 `preview/component-sidenav.html` 复制 `<span class="menu-icon">` 中的完整 SVG。预置 6 种图标可混搭，如需更多从 `assets/icons/sidenav-icon/{name}.svg` 读取
> - **Logo**：从 `snippets/nav-logo.html` 读取
> - **通用 UI 图标**：简单内联 `<svg>` + `stroke="currentColor"`
> - 绝不使用 `<i class="lucide-xxx">` 语法
>
> ### 样式规则
>
> ```html
> <link rel="stylesheet" href="../../colors_and_type.css">
> <link rel="stylesheet" href="../../components.css">
> ```
> - 页面布局样式写在 `<style>` 中，用 `var(--token-name)` 引用 Token
> - 颜色用 `var(--color-primary)` 等语义变量，不硬编码 hex（SVG fill/stroke 除外）
> - 禁止引入任何第三方 CSS 框架

# 源力设计系统 (Yuanli Design System)

企业级 B2B 管理后台设计规范，服务于字节跳动云服务（ByteCloud）产品线。主色 `#1664FF`（源力蓝），4px 栅格基准，32px 操作高度，48px 导航高度。

---

## Token 系统

所有 Token 定义在 `colors_and_type.css`（CSS 变量）和 `css.json`（JSON 映射）中。生成页面时直接引用变量，无需记忆具体值。

| 类别 | 命名规则 | 示例 |
|------|---------|------|
| 颜色-语义 | `--color-{role}` | `--color-primary`, `--color-text-1`, `--color-border` |
| 颜色-色阶 | `--{palette}-{level}` | `--primary-6`, `--danger-5`, `--grey-4` |
| 间距 | `--space-{n}` (4px × n) | `--space-1`(4px) ~ `--space-16`(64px) |
| 圆角 | `--radius-{size}` | `--radius-sm`(4px), `--radius-md`(8px), `--radius-lg`(12px) |
| 阴影 | `--shadow-{1-5}` | `--shadow-1`(微浮) ~ `--shadow-5`(最大浮起) |
| 字号 | `--font-size-{level}` | `--font-size-h1`(20px) ~ `--font-size-caption`(10px) |

本设计系统仅支持亮色模式，不提供暗色主题。

---

## 组件

共 32 个组件，完整注册表见 `components/index.json`。每个组件在 `preview/component-{slug}.html` 有可直接复制的代码模板。

---

## 页面骨架

```
+------------------------------------------------------------------+
|                      TopNav (48px)                                |
+------------------------------------------------------------------+
|            |                                                      |
|  Sidebar   |               Content                               |
|  (200px)   |             (flex: 1)                               |
|            |                                                      |
+------------+-----------------------------------------------------+
```

| 区域 | 尺寸 | 背景色 | 说明 |
|------|------|--------|------|
| TopNav | 高 48px，宽 100% | `#FFFFFF` | 底阴影，左 Logo + 汉堡，右搜索 + 链接 + 图标 + 头像 |
| Sidebar | 宽 200px | `#F6F8FA` | 业务标题区 + 分组菜单 + 底部折叠按钮 |
| Content | `flex: 1` | `#FFFFFF` | 内边距 32px，模块间距 40px |

---

## 页面类型

| 类型 | 核心构成 |
|------|---------|
| 列表页（带tab） | PageHeader(含Tab) + FilterBar + DataTable + Pagination |
| 列表页（不带tab） | PageHeader(无Tab，底部border分隔) + FilterBar + DataTable + Pagination |
| 详情页 | Breadcrumb + PageHeader + Tabs + DetailsDisplay |
| 图表页 | 时间筛选条 + 3列图表卡片网格 |

---

## 🔍 质量验证（页面生成后执行）

### 检查 1：框架组件来源
- TopNav 使用 `.top-nav` + 子 class，结构来自 `preview/component-topnav.html`
- Sidenav 使用 `.sidenav` + `.menu-item` + `.menu-icon`，图标为完整多色内联 SVG
- PageHeader 使用 `.page-header-comp` + 子 class

### 检查 2：内容组件来源
页面中每个 UI 区块必须使用对应 `preview/component-{slug}.html` 中的结构和 class 名。若出现 Tailwind 工具类（`text-sm`、`px-4`）或 Lucide class（`lucide-*`），即为不通过。

### 检查 3：Token 规范
- 颜色用 `var(--color-*)` / `var(--primary-*)` 等变量，不硬编码 hex
- 间距为 4px 倍数，圆角用 `var(--radius-*)`
- 字体用 `var(--font-size-*)` 或工具类 `.type-h1` ~ `.type-caption`

### 检查 4：完整性
- `<head>` 引入 `colors_and_type.css` + `components.css`
- 无 Tailwind/Lucide/Bootstrap CDN 引用
- SVG 图标完整（含 `<defs>`、`<linearGradient>`）

| 结果 | 条件 |
|------|------|
| ✅ 通过 | 4 项全部满足 |
| ❌ 不通过 | 使用了 Tailwind/Lucide 替代组件，需重新生成 |

---

> **流程总结**：读 preview 取组件 HTML → 原样复制粘贴 → 只改文字数据 → 引入 Token CSS → 验证通过后交付。