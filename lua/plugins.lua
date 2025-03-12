
-- 安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- 配置插件
require("lazy").setup({
  -- 主题插件
  {
    "folke/tokyonight.nvim",
    lazy = false,  -- 主题需要立即加载
    priority = 1000,  -- 设置高优先级以确保主题优先加载
  },

  -- 文件树插件
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- 可选，用于文件图标
    },
  },

  -- Bufferline (顶部标签栏)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "moll/vim-bbye"
    }
  },

  -- Lualine (底部状态栏)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress"  -- LSP 进度扩展
    }
  }
})
