local status, ident_blankline = pcall(require, "ibl")
if not status then
  vim.notify("没有找到 indent_blankline")
  return
end

local hooks = require "ibl.hooks"

--  主题同步钩子（必须保留）
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  -- 彩虹括号颜色定义
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

  -- 保持原有缩进线颜色关联
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { link = "RainbowRed" })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { link = "RainbowYellow" })
end)

--  彩虹括号共享配置
local rainbow_highlight = {
  "RainbowRed",    -- 层级1
  "RainbowYellow", -- 层级2
  "RainbowBlue",   -- 层级3
  "RainbowGreen",  -- 层级4
  "RainbowCyan"    -- 层级5
}

--  配置 rainbow-delimiters
vim.g.rainbow_delimiters = {
  highlight = rainbow_highlight,
  blacklist = { "markdown", "help" }

}


ident_blankline.setup({
  --  基础显示配置
  -- char = "│",                -- 缩进线字符
  -- char = '¦',
  -- char = '┆',
  -- char = '│',
  -- char = "⎸",
  indent = {
    char = "│",
    highlight = rainbow_highlight
  },

  scope = {
    enabled = true,
    show_start = true,
    highlight = rainbow_highlight
  },

  --  文件类型控制(不加竖线的文件)
  exclude = {
    filetypes = {
      "dashboard",
      "packer",
      "terminal",
      "help",
      "log",
      "markdown",
      "TelescopePrompt",
      "lsp-installer",
      "lspinfo",
      "toggleterm",
    },
    buftypes = {
      "terminal",
      "nofile",
    }
  },

  --  性能优化参数
  debounce = 150, -- 更新延迟 (ms)

})

--  保留原有高亮组定义（需与彩虹颜色关联）
vim.cmd([[
  highlight IndentBlanklineContextChar guifg=#61AFEF gui=nocombine
]])

--  注册作用域高亮策略（必须）
hooks.register(
  hooks.type.SCOPE_HIGHLIGHT,
  hooks.builtin.scope_highlight_from_extmark
)
