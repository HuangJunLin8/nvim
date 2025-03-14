local status, ident_blankline = pcall(require, "ibl")
if not status then
  vim.notify("没有找到 indent_blankline")
  return
end

ident_blankline.setup({
  --  基础显示配置
  -- char = "│",                -- 缩进线字符
  -- char = '¦',
  -- char = '┆',
  -- char = '│',
  -- char = "⎸",
  indent = { char = "│" },

  scope = {
    enabled = true,
    show_start = true
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

--  自定义高亮组
vim.cmd([[
  highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine
  highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine
  highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine
  highlight IndentBlanklineContextChar guifg=#61AFEF gui=nocombine
]])
