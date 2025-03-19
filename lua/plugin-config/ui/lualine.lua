local status, lualine = pcall(require, "lualine")
if not status then
  vim.notify("没有找到 lualine.nvim")
  return
end

-- 获取当前颜色主题（适配 colorscheme 配置）
local colorscheme = vim.g.colors_name or "tokyonight"


lualine.setup({
  options = {
    theme = colorscheme,  -- 自动同步当前主题
    component_separators = { left = "|", right = "|" },
    section_separators = { left = " ", right = "" },  -- 使用 Powerline 风格分隔符
    disabled_filetypes = {
      statusline = { "neo-tree", "NvimTree" }, -- 禁用在 neo-tree 中显示
      -- winbar = { "neo-tree" },     -- 如果你也用 winbar，可以同时禁用
    },

  },
  extensions = { "nvim-tree", "toggleterm" },  -- 扩展支持
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {
      "filename",
      {
        -- "lsp_progress",   -- 配置参考：https://github.com/linrongbin16/lsp-progress.nvim/blob/main/lua/lsp-progress/defaults.lua
        -- spinner_symbols = { " ", " ", " ", " ", " ", " " },  -- LSP 加载动画
        -- spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        -- spinner_symbols = { "󰪞 ", "󰪟 ", "󰪠 ", "󰪡 ", "󰪢 ", "󰪣 ", "󰪤 " };
      }
    },
    lualine_x = {
      "filesize",
      -- {
      --   "fileformat",
      --   symbols = {
      --     unix = "LF",    -- 统一换行符标识
      --     dos = "CRLF",
      --     mac = "CR"
      --   }
      -- },
      "encoding",
      "filetype"
    },
    lualine_y = {"progress"},
    lualine_z = {"location"}
  }
})
