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
	-- 主题: tokyonight
	{
		"folke/tokyonight.nvim",
		preority = 1000, -- 设置高优先级以确保主题优先加载
	},

	-- 主题: catppuccin
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},

	-- 文件树
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	branch = "v3.x",
	-- 	keys = { { "<A-m>", "<cmd>Neotree toggle<cr>", desc = "文件树切换" } },
	-- 	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	-- 	config = function()
	-- 		require("neo-tree").setup({
	-- 			close_if_last_window = true, -- 如果只剩文件树窗口，关闭时退出 Neovim
	-- 			enable_git_status = true, -- 显示 Git 状态
	-- 			enable_diagnostics = false, -- 显示诊断信息
	-- 			window = {
	-- 				width = math.floor(vim.o.columns * 0.2), -- 根据总列数设置为 20% 宽度
	-- 				mappings = {
	-- 					["o"] = "open", -- 打开/关闭文件夹
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

    -- 文件树
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
			{ "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "关闭当前标签页" },
			{ "<leader>wl", "<cmd>BufferLineCloseRight<cr>", desc = "闭右侧所有标签页（不含当前" },
			{ "<leader>wh", "<cmd>BufferLineCloseLeft<cr>", desc = "关闭左侧所有标签页（不含当前）" },
			{ "<leader>wc", "<cmd>BufferLinePickClose<cr>", desc = "交互式选择关闭目标标签页" },
		},
		event = "BufEnter", -- 保留事件触发作为备用加载条件
		dependencies = {
			"echasnovski/mini.bufremove",
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

	-- 消息管理: noice.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy", -- 延迟加载插件，加快启动速度
		dependencies = {
			"MunifTanjim/nui.nvim", -- 提供 UI 支持的依赖插件
			"rcarriga/nvim-notify", -- 替换 Neovim 默认的通知系统，提供更美观的消息弹窗
		},
		config = function()
			require("noice").setup({
				timeout = 1000,
				routes = {
					{
						filter = {
							event = "lsp",
							kind = "progress", -- 过滤掉 LSP 某些消息
							any = {
								{ find = "Processing file symbols" },
								{ find = "Processing full semantic tokens" },
								{ find = "Diagnosing lua_ls" },
							},
						},
						opts = { skip = true }, -- 不显示
					},
				},

				-- LSP 相关配置
				lsp = {
					override = {
						-- 覆盖 LSP 的 markdown 渲染方式，使其使用 noice 的 UI
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						-- 覆盖 cmp 的文档渲染方式，确保 noice 的 UI 生效
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- 预设功能开关
				presets = {
					bottom_search = true, -- 使用底部命令栏显示搜索结果
					command_palette = true, -- 使用类似命令面板的界面取代传统命令行
					long_message_to_split = true, -- 当消息过长时，将其分割到浮动窗口显示
					inc_rename = true, -- 关闭内置的增量重命名 UI（可以选择其他插件提供类似功能）
				},
			})
		end,
	},

	-- 启动界面插件: alpha.nvim
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-telescope/telescope.nvim", -- 依赖 Telescope 用于项目和文件搜索
		},
		init = function()
			vim.opt.showtabline = 0 -- 启动时不显示 TabLine
		end,
		config = function()
			require("plugin-config.ui.alpha")
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
		dependencies = {
			{
				"echasnovski/mini.indentscope", -- 高亮当前的缩进线
				version = "*",
				config = function()
					require("mini.indentscope").setup({
						draw = {
							delay = 100, -- 延迟显示，避免闪烁
							animation = require("mini.indentscope").gen_animation.none(),
						},
						symbol = "│", -- 自定义缩进符号
						options = {
							try_as_border = true, -- 如果可能，将缩进线作为边界线显示
						},
					})
				end,
			},
		},
		config = function()
			require("plugin-config.ui.blankline")
		end,
	},

	-- 快捷键提示
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"folke/snacks.nvim",
		config = function()
			require("snacks").setup({
				popup = {
					border = "rounded", -- 使用圆角边框
					highlight = "NormalFloat", -- 使用浮动窗口的默认高亮
				},
				hints = {
					enable = true, -- 启用提示信息
				},
				notifications = {
					enable = true, -- 启用通知弹窗
				},
			})
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
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag", -- 添加 nvim-ts-autotag 自动补全标签
		},
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
			-- "j-hui/fidget.nvim", -- 状态指示(用notice.nvim 替换)
			"folke/neodev.nvim", -- neovim 开发
			"folke/trouble.nvim", -- 添加 trouble.nvim 集中显示诊断信息
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
			--"rafamadriz/friendly-snippets", -- 预定义代码片段 (cmp.lua 里面也要注释才能关闭这个补全)
			"hrsh7th/cmp-vsnip", -- vsnip 引擎集成
			"hrsh7th/vim-vsnip", -- vsnip 片段引擎
			"windwp/nvim-autopairs", --  括号自动配对增强插件
		},
		config = function()
			require("plugin-config.lsp.cmp")
		end,
	},

	-- LSP 体验增强
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc"),
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
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

	-- 浮动终端 ( 在 lspsaga 里面配置 ：Lspsaga term_toggle)
	-- {
	-- "akinsho/toggleterm.nvim",
	-- version = "*",
	-- priority = 700,
	-- config = function()
	-- require("plugin-config.ui.toggleterm").setup()
	-- end,
	-- },

	-- 文件执行
	{
		"CRAG666/code_runner.nvim",
		version = "*",
		priority = 700,
		silent = true,
		--dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			require("plugin-config.code.code_runner")
		end,
	},

	-- todo 高亮
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
	},

	-- 代码注释  快捷键在keybinds
	{
		"folke/ts-comments.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("ts-comments").setup({})
		end,
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

	-- 快速跳转
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>j",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash 跳转",
			},
		},
		config = function()
			require("plugin-config.code.flash")
		end,
	},

	-- to do 研究
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- 变量高亮
	{
		"RRethy/vim-illuminate", -- 官方仓库地址
		event = "BufReadPost", -- 文件打开后自动加载
		config = function()
			-- 基础配置
			require("illuminate").configure({
				-- 高亮延迟（毫秒）
				delay = 150,
				-- 忽略文件类型
				filetypes_denylist = {
					"dirvish",
					"fugitive",
					"alpha",
					"NvimTree",
					"lazy",
					"neogitstatus",
					"Trouble",
					"text",
				},
				-- 高亮模式（可选：'underline', 'icon', 'none'）
				modes = { "n", "v" },
			})

			-- 自定义高亮颜色（修改为你主题的颜色）
			-- vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "Visual" })
			-- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "IncSearch" })
			-- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "WarningMsg" })

			-- 绑定快捷键（可选）
			-- vim.keymap.set("n", "<Leader>hl", function()
			-- require("illuminate").toggle()
			-- end, { desc = "切换高亮" })
		end,
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
