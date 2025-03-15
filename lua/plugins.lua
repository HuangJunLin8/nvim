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
    -- =========================================== 界面美化组 =====================================================
    -- 主题插件
    {
        "folke/tokyonight.nvim",
        priority = 1000, -- 设置高优先级以确保主题优先加载
        config = function()
            require("colorscheme")
        end,
    },

    -- 文件树插件 (快捷键触发加载)
    {
        "nvim-tree/nvim-tree.lua",
        keys = {
            { "<A-m>", "<cmd>NvimTreeToggle<cr>", desc = "文件树切换" },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("plugin-config.ui.nvim-tree")
        end,
    },

    -- Bufferline 标签栏 (快捷键触发 + BufEnter 事件)
    {
        "akinsho/bufferline.nvim",
        version = "*",
        keys = {
            { "<leader>h", "<cmd>BufferLineCyclePrev<cr>", desc = "左标签页" },
            { "<leader>l", "<cmd>BufferLineCycleNext<cr>", desc = "右标签页" },
            { "<leader>q", "<cmd>Bdelete!<cr>", desc = "关闭标签页" },
            { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "闭右侧所有标签页（不含当前" },
            { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "关闭左侧所有标签页（不含当前）" },
            { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "交互式选择关闭目标标签页" },
        },
        event = "BufEnter", -- 保留事件触发作为备用加载条件
        dependencies = {
            "moll/vim-bbye",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("plugin-config.ui.bufferline")
        end,
    },

    -- Lualine 状态栏 (延迟加载优化)
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            -- "arkav/lualine-lsp-progress",  -- 不在底部栏显示进度条（用fidget ）
        },
        config = function()
            require("plugin-config.ui.lualine")
        end,
    },

    -- Dashboard 启动页 (VimEnter 事件触发)
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.opt.showtabline = 0
        end,
        config = function()
            require("plugin-config.ui.dashboard")
        end,
    },

    -- 更多图标
    {
        "onsails/lspkind.nvim",
        event = "InsertEnter",
    },

    -- 彩虹括号插件
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "BufReadPost",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "lukas-reineke/indent-blankline.nvim",
        },
        --config = function()
        --  require("plugin-config.rainbow")
        --end
    },

    -- 竖线提示
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPost",
        main = "ibl",
        config = function()
            require("plugin-config.ui.blankline")
        end,
    },

    -- =========================================== 核心功能组 =====================================================
    -- Telescope 搜索套件 (快捷键核心触发)
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "文件搜索" },
            { "<C-f>", "<cmd>Telescope live_grep<cr>", desc = "内容搜索" },
            { "<leader>fe", "<cmd>Telescope env<cr>", desc = "环境变量" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "LinArcX/telescope-env.nvim", config = true }, -- 内联配置依赖项
        },
        config = function()
            require("plugin-config.telescope")
        end,
    },

    -- Treesitter 语法高亮 (混合触发策略)
    {
        "nvim-treesitter/nvim-treesitter",
        keys = {
            { "<leader>ts", "<cmd>TSUpdate<cr>", desc = "更新语法" },
        },
        event = { "BufReadPost", "BufNewFile" }, -- 更精准的触发事件
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("plugin-config.code.nvim-treesitter")
        end,
    },

    -- =========================================== LSP 全家桶 =====================================================
    --  -------------------- LSP 核心插件 --------------------------------
    -- 🛠️ LSP/DAP/Linter 管理器
    {
        "williamboman/mason.nvim",
        cmd = "Mason", -- 只有输入 :Mason 命令时加载
        build = ":MasonUpdate",
        priority = 900,
    },

    -- 🌉 Mason 与 lspconfig 的桥梁（自动配置已安装的 LSP）
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" }, -- 明确声明依赖
        event = "User FileOpened", -- 文件打开后延迟加载
    },

    -- LSP 配置
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }, -- 打开文件前加载
        dependencies = {
            -- 注意： 若打开lualine.lua 里的 lsp-progress 那两行加载图标配置, 这个状态指示就不会生效
            "j-hui/fidget.nvim", -- 状态指示
            "folke/neodev.nvim", -- neovim 开发
        },
        config = function()
            require("plugin-config.lsp.init")
        end,
    },

    -- 自动补全
    {
        "hrsh7th/nvim-cmp", -- 补全引擎核心
        event = "InsertEnter", -- 插入模式时加载
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSP 补全数据源
            "hrsh7th/cmp-buffer", -- 缓冲区补全
            "hrsh7th/cmp-path", -- 路径补全
            "hrsh7th/cmp-cmdline", -- 命令行补全
            --"rafamadriz/friendly-snippets", -- 预定义代码片段
            "hrsh7th/cmp-vsnip", -- vsnip 引擎集成
            "hrsh7th/vim-vsnip", -- vsnip 片段引擎
            "windwp/nvim-autopairs", --  括号自动配对增强插件
        },
        config = function()
            require("plugin-config.lsp.cmp")
        end,
    },

    -- -- 📊 LSP 状态指示器（显示后台操作进度）
    -- {
    --     "j-hui/fidget.nvim",
    --     event = "LspAttach", -- 当 LSP 附加到缓冲区时加载
    -- },

    -- -- 🎮 增强 Lua LSP（专门为 Neovim Lua 开发优化）
    -- {
    --     "folke/neodev.nvim",
    --     ft = "lua", -- 仅 Lua 文件加载
    -- },

    -- =========================================== 编程应用 =====================================================

    -- 代码格式化
    {
        "mhartington/formatter.nvim",
        event = "BufReadPre",
        config = function()
            require("plugin-config.code.formatter")
        end,
    },

    -- 浮动终端
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        priority = 700,
        config = function()
            require("plugin-config.toggleterm").setup()
        end,
    },

    -- 文件执行
    {
        "CRAG666/code_runner.nvim",
        version = "*",
        priority = 700,
        --dependencies = { "akinsho/toggleterm.nvim" },
        config = function()
            require("plugin-config.code.code_runner")
        end,
    },

    -- 代码注释  快捷键在keybinds
    {
        "tpope/vim-commentary",
        event = "VeryLazy",
    },

    -- 自动项目根目录
    {
        "airblade/vim-rooter",
        event = { "VimEnter", "BufReadPost" },
        -- config = function()
        -- 可选：配置触发模式 (默认已很智能，通常不需要额外配置)
        -- vim.g.rooter_patterns = { ".git", "pyproject.toml", "setup.py", "requirements.txt" } -- 添加你的项目标识文件
        -- vim.g.rooter_manual_only = 0 -- 0=自动切换，1=手动触发
        -- end,
    },

    -- =============================================== 代码调试 ============================================
    -- 调试器
    {
        "mfussenegger/nvim-dap",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",

            -- ui 界面
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",

            -- 实时变量提示
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            require("plugin-config.dap.init")
        end,
    },

    -- 调试适配器管理
    {
        "jay-babu/mason-nvim-dap.nvim",
        lazy = true,
        opts = {
            ensure_installed = {
                "codelldb", -- C/C++ 调试器
                "debugpy", --  Python 调试器
            },
            automatic_installation = true,
            handlers = {
                function(config)
                    -- 统一处理所有适配器配置
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
        },
    },

    -- =============================================== python 相关 ============================================
    -- python 虚拟环境选择
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python", --optional
            -- { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup({
                settings = {
                    search = {
                        my_venvs = {
                            -- command = "fd python$ /opt/miniconda3/envs/ | grep bin",
                            command = "fd python$ /opt/miniconda3/envs/ | grep bin | grep -v ipython",
                        },
                    },
                },
            })
        end,
        keys = {
            { "<leader>cc", "<cmd>VenvSelect<cr>" },
        },
    },
})
