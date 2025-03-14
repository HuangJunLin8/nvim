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


  -- 文件树插件 (快捷键触发加载)
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<A-m>", "<cmd>NvimTreeToggle<cr>", desc = "文件树切换" }
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("plugin-config.nvim-tree")
    end
  },


  -- Bufferline 标签栏 (快捷键触发 + BufEnter 事件)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    keys = {
      { "<leader>h", "<cmd>BufferLineCyclePrev<cr>", desc = "左标签页" },
      { "<leader>l", "<cmd>BufferLineCycleNext<cr>", desc = "右标签页" },
      { "<leader>w", "<cmd>Bdelete!<cr>", desc = "关闭标签页" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "闭右侧所有标签页（不含当前"},
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "关闭左侧所有标签页（不含当前）"},
      { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "交互式选择关闭目标标签页"}
    },
    event = "BufEnter",  -- 保留事件触发作为备用加载条件
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "moll/vim-bbye"
    },
    config = function()
      require("plugin-config.bufferline")
    end
  },

  -- Lualine 状态栏 (延迟加载优化)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "arkav/lualine-lsp-progress"
    },
    config = function()
      require("plugin-config.lualine")
    end
  },


  -- Telescope 搜索套件 (快捷键核心触发)
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "文件搜索" },
      { "<C-f>", "<cmd>Telescope live_grep<cr>", desc = "内容搜索" },
      { "<leader>fe", "<cmd>Telescope env<cr>", desc = "环境变量" }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "LinArcX/telescope-env.nvim", config = true }  -- 内联配置依赖项
    },
    config = function()
      require("plugin-config.telescope")
    end
  },


  -- Dashboard 启动页 (VimEnter 事件触发)
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim"
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require("plugin-config.dashboard")
    end
  },

  -- Treesitter 语法高亮 (混合触发策略)
  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<leader>ts", "<cmd>TSUpdate<cr>", desc = "更新语法" }  -- 添加实用快捷键
    },
    event = { "BufReadPost", "BufNewFile" },  -- 更精准的触发事件
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("plugin-config.nvim-treesitter")
    end
  },


  -- =========================================== LSP 插件组 =====================================================
  -- 🛠️ LSP/DAP/Linter 管理器（用于安装语言服务器）
  {
    "williamboman/mason.nvim",
    cmd = "Mason",  -- 只有输入 :Mason 命令时加载
    build = ":MasonUpdate",
  },

  -- 🌉 Mason 与 lspconfig 的桥梁（自动配置已安装的 LSP）
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" }, -- 明确声明依赖
    event = "User FileOpened", -- 文件打开后延迟加载
  },

  -- 🔧 Neovim 官方 LSP 客户端配置（基础 LSP 功能）
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" }, -- 打开文件前加载
  },

  --"hrsh7th/cmp-nvim-lsp",            -- 🔌 补全引擎的 LSP 数据源（若启用需配合 nvim-cmp）

  -- 📊 LSP 状态指示器（显示后台操作进度）
  {
    "j-hui/fidget.nvim",
    event = "LspAttach", -- 当 LSP 附加到缓冲区时加载
    opts = {
      notification = {
        window = { winblend = 30 } -- 半透明效果
      }
    }
  },

  -- 🎮 增强 Lua LSP（专门为 Neovim Lua 开发优化）
  {
    "folke/neodev.nvim",
    ft = "lua", -- 仅 Lua 文件加载
  }

})





