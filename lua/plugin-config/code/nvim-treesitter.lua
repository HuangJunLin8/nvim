-- 文件路径：lua/plugin-config/nvim-treesitter.lua
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  vim.notify("没有找到 nvim-treesitter")
  return
end

treesitter.setup({
  -- 安装语言解析器 (推荐安装列表)
  ensure_installed = {
    "bash",
    "c",
    "cpp",
--    "css",
--    "go",
    "html",
    "java",
    "javascript",
    "json",
    "lua",
    "python",
--    "rust",
--    "tsx",
--    "typescript",
    "vim",
    "yaml"
  },

  -- 自动安装缺失的解析器
  auto_install = true,

  -- 代码高亮模块
  highlight = {
    enable = true,
    use_languagetree = true,  -- 启用语言树优化
    additional_vim_regex_highlighting = false,
    disable = function(_, bufnr)
      -- 禁用大文件高亮
      local max_filesize = 1024 * 1024 -- 1MB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },

  -- 增量选择模块( 回车扩选，删除所选，tab大扩选)
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",      -- 进入选择模式
      node_incremental = "<CR>",    -- 扩大选择范围
      node_decremental = "<BS>",    -- 缩小选择范围
      scope_incremental = "<TAB>",  -- 选择整个作用域
    },
  },

  -- 代码缩进模块(=)
  indent = {
    enable = true,
    disable = { "python", "yaml" } -- 某些语言缩进需要禁用
  },


  -- 折叠配置（需在 setup 外部设置）
  fold = {
    enable = true,
    disable = { "markdown" }        -- 禁用特定语言的折叠checkhealth treesitter
  }
})


-- 全局折叠设置 (zc   zo)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99              -- 默认不折叠
vim.opt.foldtext = [[ substitute(getline(v:foldstart), '\t', repeat(' ',&tabstop), 'g') . '...' ]]

