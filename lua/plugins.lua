
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
    config = function()
      require("colorscheme") -- 独立颜色配置文件
    end
  },

  -- 文件树插件
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- 可选，用于文件图标
    },
    config = function()
      require("plugin-config.nvim-tree")
    end
  },

  -- Bufferline (顶部标签栏)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "moll/vim-bbye"
    },
    event = "BufEnter", -- 缓冲区事件触发加载
    config = function()
      require("plugin-config.bufferline")
    end
  },

  -- Lualine (底部状态栏)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress"  -- LSP 进度扩展
    },
    event = "VeryLazy", -- 延迟加载
    config = function()
      require("plugin-config.lualine")
    end
  },

  -- Telescope （文件搜索）
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugin-config.telescope")
    end
  },

  -- 新增 telescope-env 扩展
  {
    "LinArcX/telescope-env.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }, -- 声明依赖
    config = function()
      require("telescope").load_extension("env")
    end
  }


})
