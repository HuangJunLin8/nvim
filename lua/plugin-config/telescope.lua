local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Telescope 未找到")
  return
end

-- 推荐安装的外部依赖（终端执行）
-- sudo apt install ripgrep 或 brew install ripgrep
-- npm install -g fd-find

-- 引入快捷键配置
local keys = require("keybindings")

telescope.setup({
  defaults = {
    initial_mode = "insert",       -- 打开窗口默认为插入模式
    layout_strategy = "horizontal", -- 布局策略 (vertical/horizontal/flex)
    layout_config = {
      width = 0.9,                -- 窗口宽度占比
      height = 0.8                -- 窗口高度占比
    },

    path_display = { "smart" },    -- 智能路径显示（缩短长路径）
    file_ignore_patterns = {       -- 忽略文件类型
      "node_modules",
      ".git/",
      "__pycache__"
    },

    mappings = keys.telescope_mappings  -- 引用外部映射表
  },

  pickers = {
    find_files = {
      theme = "dropdown",         -- 下拉式皮肤
      previewer = false           -- 禁用预览
    },

    live_grep = {
      theme = "cursor",           -- 光标居中皮肤
      additional_args = { "--hidden" } -- 搜索隐藏文件
    }
  },
})

