local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("Telescope 未找到")
  return
end

-- 推荐安装的外部依赖（终端执行）
-- sudo apt install ripgrep 或 brew install ripgrep
-- npm install -g fd-find

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

    mappings = {  -- 这里设置快捷键
      i = {
        -- 上下移动
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<Down>"] = "move_selection_next",
        ["<Up>"] = "move_selection_previous",

        -- 历史记录
        ["<C-n>"] = "cycle_history_next",
        ["<C-p>"] = "cycle_history_prev",

        -- 关闭窗口
        ["<C-q>"] = "close",

        -- 预览窗口上下滚动
        ["<C-u>"] = "preview_scrolling_up",
        ["<C-d>"] = "preview_scrolling_down",
      },

      n = {
--        ["j"] = "move_selection_next",
--        ["k"] = "move_selection_previous",
        ["q"] = "close",

      }
    }
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

