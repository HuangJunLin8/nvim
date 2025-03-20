-- 安全加载 nvim-tree 插件并检查是否安装
local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
  vim.notify("没有找到 nvim-tree: " .. tostring(nvim_tree), vim.log.levels.ERROR)
  return
end

-- 配置 nvim-tree 文件浏览器
nvim_tree.setup({
  git = { enable = true }, -- 禁用 git 状态显示
  update_cwd = true, -- 更新时同步当前工作目录
  update_focused_file = { -- 自动聚焦当前打开文件
    enable = true,
    update_cwd = true,
  },
  filters = { -- 文件过滤配置
    dotfiles = true, -- 显示隐藏文件（以点开头的文件）
    custom = { "node_modules" }, -- 排除 node_modules 目录
  },
  view = { -- 视图布局配置
    width = 28, -- 侧边栏宽度
    side = "left", -- 显示在左侧
    number = false, -- 禁用行号
    relativenumber = false, -- 禁用相对行号
    signcolumn = "yes", -- 显示标记列（用于 git 等提示）
  },
  actions = { -- 文件操作配置
    open_file = {
      resize_window = true, -- 打开文件时自动调整窗口大小
      quit_on_open = false, -- 打开文件时不自动关闭侧边栏
    },
  },
  system_open = { cmd = "xdg-open" }, -- Linux 系统默认打开方式

  -- 自定义按键映射配置
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    -- 保留默认快捷键设置
    api.config.mappings.default_on_attach(bufnr)

    -- 自定义快捷键：逗号切换隐藏文件显示
    vim.keymap.set("n", ",", api.tree.toggle_hidden_filter, {
      buffer = bufnr,
      desc = "切换隐藏文件显示",
      nowait = true,
    })
  end,
})

-- 当只剩下文件树窗口时自动关闭
-- vim.cmd([[
--   autocmd WinEnter * ++nested if winnr('$') == 1 && &filetype == 'NvimTree' | quit | endif
-- ]])



-- 可选：映射快捷键
-- vim.api.nvim_set_keymap('n', '<Leader>q', '<Cmd>lua _G.smart_quit()<CR>', { noremap = true, silent = true })
