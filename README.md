# Neovim 配置说明

这是一个高度定制化的 Neovim 配置，基于 Lua 编写，使用 lazy.nvim 作为插件管理器。配置包含了丰富的功能模块，包括界面美化、代码补全、LSP、调试等。

## 使用说明

要使用此 Neovim 配置，请按照以下步骤操作：

1. 确保已安装 Neovim (>= 0.9.0)。
2. 克隆本仓库到 `~/.config/nvim` 目录：
   ```
   git clone https://github.com/HuangJunLin8/nvim ~/.config/nvim
   ```
3. 启动 Neovim，插件将自动安装。
4. 使用提供的快捷键和功能模块来增强您的编辑体验。

## 快捷键说明

### 窗口管理
- `sl`: 垂直分屏
- `sh`: 水平分屏  
- `ss`: 关闭当前窗口
- `so`: 关闭其他窗口
- `<A-h/j/k/l>`: 在窗口间跳转
- `s,`/`s.`: 调整窗口宽度
- `sj`/`sk`: 调整窗口高度
- `s=`: 等比例调整窗口

### 文件操作
- `<A-m>`: 切换文件树 (NvimTree)
- `<leader>s`: 保存文件
- `<C-s>`: 保存文件

### 标签页操作
- `<leader>h`: 切换到左侧标签页
- `<leader>l`: 切换到右侧标签页  
- `<leader>q`: 关闭当前标签页
- `<leader>wl`: 关闭右侧所有标签页（不含当前）
- `<leader>wh`: 关闭左侧所有标签页（不含当前）
- `<leader>wc`: 交互式选择关闭目标标签页

### 终端操作
- `<leader>t`: 水平分割打开终端
- `<leader>vt`: 垂直分割打开终端
- `<Esc>`: 退出终端模式
- `<A-h/j/k/l>`: 在终端窗口间跳转

### 代码编辑
- `<C-_>`: 注释/取消注释当前行
- `<leader>f`: 使用 Formatter 格式化代码
- `gcc`: 注释/取消注释当前行
- `gc`: 注释/取消注释选中行
- `<leader>a`: 复制整个文件内容
- `J`/`K`: 上下移动选中文本
- `<C-j>`/`<C-k>`: 快速上下移动
- `<C-u>`/`<C-d>`: 快速上下滚动
- `<C-h>`: 跳转到行首
- `<C-l>`: 跳转到行尾
- `q`: 退出当前窗口
- `qq`: 保存并退出
- `Q`: 强制退出
- `jj`: 退出插入模式
- `<C-Left>`/`<C-Right>`: 调整窗口宽度
- `<C-Up>`/`<C-Down>`: 调整窗口高度
- `p`: 粘贴时不覆盖剪贴板内容

### 搜索功能
- `<C-p>`: 文件搜索 (Telescope)
- `<C-f>`: 内容搜索 (Telescope)
- `<leader>fe`: 环境变量搜索 (Telescope)
- `<C-j>`: 移动到下一个选择项
- `<C-k>`: 移动到上一个选择项
- `<C-n>`: 循环历史记录到下一个
- `<C-p>`: 循环历史记录到上一个
- `<C-q>`: 关闭搜索窗口
- `<C-u>`: 向上滚动预览
- `<C-d>`: 向下滚动预览

### LSP 功能
- `gd`: 跳转到定义
- `gD`: 跳转到声明
- `gi`: 跳转到实现
- `gr`: 显示引用
- `gh`: 悬浮文档
- `gp`: 显示诊断信息
- `gk`: 上一个诊断
- `gj`: 下一个诊断
- `<leader>rn`: 重命名符号
- `<leader>ca`: 代码操作
- `<leader>p`: 打开终端
- `<A-.>`: 出现补全
- `<A-,>`: 取消补全
- `<CR>`: 确认选择
- `<C-k>`: 上一个选项
- `<C-j>`: 下一个选项
- `<C-d>`: 向下滚动文档
- `<C-u>`: 向上滚动文档
- `<C-l>`: 插入代码片段
- `<C-h>`: 上一个代码片段
- `<Tab>`: 智能补全
- `<S-Tab>`: 上一个补全项

### 调试功能
- `<leader>cc`: 选择 Python 虚拟环境
- `<leader>rr`: 运行代码
- `<leader>rf`: 运行文件
- `<leader>rft`: 在新标签页中运行文件
- `<leader>rp`: 运行项目
- `<leader>rc`: 关闭运行
- `<leader>crf`: 设置文件类型
- `<leader>crp`: 设置项目

## 插件列表

- 界面美化: tokyonight.nvim, nvim-tree, bufferline.nvim, lualine.nvim
- 核心功能: telescope.nvim, nvim-treesitter
- LSP: mason.nvim, nvim-lspconfig, nvim-cmp
- 调试: nvim-dap, mason-nvim-dap.nvim
- Python: venv-selector.nvim

## 项目结构

```
.
├── init.lua                # Neovim 初始化配置文件
├── lazy-lock.json          # 插件锁定文件
├── lua                     # Lua 配置目录
│   ├── basic.lua           # 基础配置
│   ├── colorscheme.lua     # 颜色主题配置
│   ├── keybindings.lua     # 快捷键配置
│   ├── plugin-config       # 插件配置目录
│   │   ├── code            # 代码相关插件配置
│   │   │   ├── code_runner.lua
│   │   │   ├── flash.lua
│   │   │   ├── formatter.lua
│   │   │   └── nvim-treesitter.lua
│   │   ├── dap             # 调试相关插件配置
│   │   │   ├── cpp.lua
│   │   │   ├── init.lua
│   │   │   └── python.lua
│   │   ├── lsp             # LSP 相关插件配置
│   │   │   ├── cmp.lua
│   │   │   ├── init.lua
│   │   │   ├── lsp_ui.lua
│   │   │   └── mason.lua
│   │   ├── telescope.lua   # Telescope 插件配置
│   │   └── ui              # 界面相关插件配置
│   │       ├── blankline.lua
│   │       ├── bufferline.lua
│   │       ├── dashboard.lua
│   │       ├── lualine.lua
│   │       ├── nvim-tree.lua
│   │       ├── rainbow.lua
│   │       └── toggleterm.lua
│   └── plugins.lua         # 插件管理配置
└── README.md               # 项目说明文件
```
