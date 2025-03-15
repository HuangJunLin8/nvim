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
    --
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
            require("plugin-config.nvim-tree")
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
            require("plugin-config.bufferline")
        end,
    },

    -- Lualine 状态栏 (延迟加载优化)
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "arkav/lualine-lsp-progress",
        },
        config = function()
            require("plugin-config.lualine")
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
            require("plugin-config.dashboard")
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
            require("plugin-config.blankline")
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
            require("plugin-config.nvim-treesitter")
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

    -- 🔧 Neovim 官方 LSP 配置
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" }, -- 打开文件前加载
    },

    --  -------------------- LSP 增强插件 --------------------------------

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
    },

    -- 📊 LSP 状态指示器（显示后台操作进度）
    {
        "j-hui/fidget.nvim",
        event = "LspAttach", -- 当 LSP 附加到缓冲区时加载
        opts = {
            notification = {
                window = { winblend = 30 }, -- 半透明效果
            },
        },
    },

    -- 🎮 增强 Lua LSP（专门为 Neovim Lua 开发优化）
    {
        "folke/neodev.nvim",
        ft = "lua", -- 仅 Lua 文件加载
    },

    -- =========================================== 编程应用 =====================================================

    -- 代码格式化
    {
        "mhartington/formatter.nvim",
        event = "BufReadPre",
        config = function()
            require("plugin-config.formatter")
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
            require("plugin-config.code_runner")
        end,
    },

    -- 代码注释  快捷键在keybinds
    {
        "tpope/vim-commentary",
        event = "VeryLazy",
    },

    -- 调试器
    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            -- DAP 配置代码将在下一步添加
            local dap = require("dap")

            -- 配置 codelldb 适配器
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            -- C++ 调试配置
            dap.configurations.cpp = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,

                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                    environment = {},
                    externalConsole = false,
                },
            }

            -- 调试 ui 界面配置
            local dapui = require("dapui")
            -- 自动打开 UI
            dap.listeners.before.launch.event_terminated = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- 自定义 UI 布局（可选）
            dapui.setup({
                -- 左侧垂直面板
                {
                    elements = {
                        { id = "scopes", size = 0.6 }, -- 变量作用域
                        { id = "watches", size = 0.3 }, -- 监视表达式
                        { id = "breakpoints", size = 0.1 }, -- 断点列表
                        -- { id = "stacks", size = 0.25 },  -- 调用栈
                    },
                    size = 50, -- 面板宽度
                    position = "left", -- 面板位置
                },

                -- 底部水平面板
                {
                    elements = {
                        { id = "repl", size = 0.4 }, -- 调试控制台
                        { id = "console", size = 0.6 }, -- 程序输出
                    },
                    size = 8, -- 面板高度
                    position = "bottom", -- 面板位置
                },
            })

            -- 虚拟文本: 实时显示变量值
            require("nvim-dap-virtual-text").setup({
                -- 基础显示配置
                enabled = true, -- 默认开启虚拟文本
                commented = false, -- 不在注释中显示变量值
                highlight_changed_variables = true, -- 高亮修改过的变量
                only_first_definition = false, -- 不只显示变量首次定义位置

                -- 视觉美化配置
                virt_text_pos = "eol", -- 显示位置 (eol|inline)
                virt_text_win_col = nil, -- 强制指定列数显示 (nil=自动)

                -- 符号与文字
                -- prefix = "➤ ", -- 变量前缀符号
                -- separator = " ", -- 变量名与值的分隔符

                -- 高亮组定制
                virt_text_hl = "Comment", -- 基础高亮组
                changed_variable_hl = "WarningMsg", -- 变量修改后的高亮组
                error_variable_hl = "ErrorMsg", -- 错误值的高亮组

                -- 显示逻辑控制
                show_stop_reason = true, -- 显示停止原因 (断点/异常等)
                all_frames = false, -- 显示所有栈帧中的变量
                delay = 100, -- 更新延迟 (毫秒)

                -- 高级格式化回调 (自定义显示内容)
                display_callback = function(variable, buf, stackframe, node)
                    local value = variable.value
                    -- 美化浮点数显示
                    if type(value) == "number" and math.floor(value) ~= value then
                        value = string.format("%.2f", value)
                    end
                    return "🐞 " .. variable.name .. " = " .. value
                end,
            })

            -- 智能检测构建系统
            local function detect_build_system()
                local cwd = vim.fn.getcwd()

                -- 优先级: Makefile > CMake > 单文件编译
                if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
                    return "make"
                elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
                    return "cmake"
                else
                    return "single_file"
                end
            end

            -- 获取可执行文件路径
            local function get_executable_path(build_type)
                local default_name = vim.fn.expand("%:t:r") -- 当前文件名（不带扩展名）
                local cwd = vim.fn.getcwd()

                if build_type == "cmake" then
                    return cwd .. "/build/" .. default_name
                elseif build_type == "make" then
                    return cwd .. "/" .. default_name
                else
                    return cwd .. "/" .. default_name
                end
            end

            -- 异步构建任务
            local function async_build(callback)
                local build_type = detect_build_system()

                local cmd = ({
                    make = { "make", "-j4" },
                    cmake = { "cmake", "--build", "build", "--config", "Debug" },
                    single_file = {
                        "g++",
                        "-g",
                        vim.fn.expand("%"),
                        "-o",
                        get_executable_path(build_type),
                    },
                })[build_type]

                -- vim.notify(table.concat(cmd), vim.log.levels.INFO)   -- 调试信息

                vim.fn.jobstart(cmd, {
                    stdout_buffered = true,
                    on_stdout = function(_, data)
                        if data then
                            vim.notify("here1", vim.log.levels.INFO)
                            -- vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
                        end
                    end,
                    on_stderr = function(_, data)
                        if data then
                            vim.notify("here2", vim.log.levels.INFO)
                            -- vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
                        end
                    end,
                    on_exit = function(_, code)
                        if code == 0 then
                            vim.notify("构建成功 🚀", vim.log.levels.INFO)
                            callback(true)
                        else
                            vim.notify("构建失败 ❌", vim.log.levels.ERROR)
                            callback(false)
                        end
                    end,
                })
            end

            -- 自动调试启动器
            local function auto_debug()
                async_build(function(success)
                    if success then
                        local build_type = detect_build_system()
                        local program = get_executable_path(build_type)

                        vim.notify(program, vim.log.levels.INFO)

                        -- 更新调试配置
                        ---@class dap.Configuration
                        ---@field program string|function
                        dap.configurations.cpp = dap.configurations.cpp or {}
                        dap.configurations.cpp[1].program = program

                        -- 启动调试会话
                        dap.continue()
                        -- require("dapui").open()
                    else
                        vim.notify("调试失败 :( ", vim.log.levels.ERROR)
                    end
                end)
            end

            -- 设置调试快捷键
            vim.keymap.set("n", "<F5>", dap.continue)
            -- vim.keymap.set("n", "<F5>", auto_debug)
            vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
            vim.keymap.set("n", "<F10>", dap.step_over)
            vim.keymap.set("n", "<F11>", dap.step_into)
            vim.keymap.set("n", "<F12>", dap.step_out)

            -- 界面快捷键
            vim.keymap.set("n", "<leader>du", dapui.toggle) -- 打开调试界面
            vim.keymap.set("n", "<leader>de", dapui.eval) -- 查看变量的取值
        end,
    },

    -- 调试适配器管理
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" }, -- 自动安装 codelldb
                automatic_installation = true,
            })
        end,
    },

    -- 调试界面
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        event = "VeryLazy",
        dependencies = { "mfussenegger/nvim-dap" },
        config = true,
    },
})
