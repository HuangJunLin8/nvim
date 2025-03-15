local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local lsp = require("lspconfig")
local cmp = require("cmp")
local lspkind = require("lspkind")

-- =============================== LSP 核心配置 ===============================
-- :Mason 包管理器
mason.setup({
    ui = {
        border = "rounded",
        height = 0.8,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

-- mason-lspconfig: 自动安装语言服务器
mason_lsp.setup({
    ensure_installed = {
        "lua_ls", -- Lua
        "clangd", -- C/C++
        "pyright", -- Python
        "jsonls", -- JSON
    },
    automatic_installation = true, -- 自动检测并安装缺失的 LSP
})

-- lspconfig修改基础配置:自定义快捷键映射
local on_attach = function(client, bufnr)
    -- 统一键盘映射函数（带服务器能力检查）
    local map = function(method, mode, keys, func, desc)
        if client.supports_method(method) then
            vim.keymap.set(mode, keys, func, {
                buffer = bufnr,
                desc = "LSP: " .. desc,
                noremap = true,
                silent = true,
            })
        end
    end

    --  基础导航
    map("textDocument/definition", "n", "gd", vim.lsp.buf.definition, "跳转到定义")
    map("textDocument/declaration", "n", "gD", vim.lsp.buf.declaration, "跳转到声明")
    map("textDocument/implementation", "n", "gi", vim.lsp.buf.implementation, "跳转到实现")
    map("textDocument/references", "n", "gr", vim.lsp.buf.references, "显示引用")

    --  信息查看
    map("textDocument/hover", "n", "gh", vim.lsp.buf.hover, "悬浮文档")
    --map("textDocument/diagnostic", 'n', 'gp', vim.diagnostic.open_float, '诊断信息')

    --  代码操作
    map("textDocument/rename", "n", "<leader>rn", vim.lsp.buf.rename, "重命名符号")
    map("textDocument/codeAction", "n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")

    -- 格式化需要特殊处理 (用插件 formatter 处理)
    --if client.supports_method("textDocument/formatting") then
    --  vim.keymap.set('n', '<leader>f', function()
    --    vim.lsp.buf.format({
    --      async = true,
    --      filter = function(format_client)
    --        -- 只允许特定客户端格式化
    --        return format_client.name ~= "tsserver"
    --      end
    --    })
    --  end, { buffer = bufnr, desc = 'LSP: 格式化代码' })
    --end

    -- 诊断导航
    vim.keymap.set("n", "gp", vim.diagnostic.open_float, { buffer = bufnr, desc = "诊断信息" })
    vim.keymap.set("n", "gk", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "上一个诊断" })
    vim.keymap.set("n", "gj", vim.diagnostic.goto_next, { buffer = bufnr, desc = "下一个诊断" })

    --  高级用法
    -- 类型定义（需要服务器支持）
    --map("textDocument/typeDefinition", 'n', '<space>D', vim.lsp.buf.type_definition, '类型定义')
end

-- 加载修改后的lspconfig配置
local servers = {
    "clangd", -- C/C++
    "pyright", -- Python
    "jsonls", -- JSON
}

for _, server in ipairs(servers) do
    lsp[server].setup({
        on_attach = on_attach,
    })
end

-- =============================== LSP ui 美化 ================================
-- 诊断图标美化
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    -- 在输入模式下也更新提示，设置为 true 也许会影响性能
    update_in_insert = true,
})
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 诊断延时
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        local ft = vim.bo.filetype
        local delays = {
            lua = 200,
            python = 300,
            javascript = 400,
            _ = 500, -- 默认值
        }
        vim.diagnostic.config({
            virtual_text = { delay = delays[ft] or delays._ },
        })
    end,
})

-- 更多小图标
require("lspkind").init({
    mode = "symbol_text",
    preset = "codicons",

    -- default: {}
    symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
    },
})

-- =============================== LSP 增强配置 ===============================
-- --------------------------LSP 自动补全---------------------------------------------

-- 延迟加载代码片段引擎(得启用这个插件才生效)
vim.g.vsnip_snippet_dir = os.getenv("HOME") .. "/.config/nvim/snippets"

-- 快捷键配置
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local mapping = {

    -- ▼ 基础操作 ▼
    -- 出现补全
    ["<A-.>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    -- 取消补全
    ["<A-,>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ -- 确认选择
        select = true,
        behavior = cmp.ConfirmBehavior.Replace,
    }),

    -- ▼ 导航控制 ▼
    ["<C-k>"] = cmp.mapping.select_prev_item(), -- 上一个选项
    ["<C-j>"] = cmp.mapping.select_next_item(), -- 下一个选项
    ["<C-d>"] = cmp.mapping.scroll_docs(4), -- 向下滚动文档
    ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- 向上滚动文档

    -- ▼ 代码片段操作 ▼
    ["<C-l>"] = cmp.mapping(function(_)
        if vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
        end
    end, { "i", "s" }),

    ["<C-h>"] = cmp.mapping(function()
        if vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
        end
    end, { "i", "s" }),

    -- ▼ 智能 Tab 扩展 ▼
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
            cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
        end
    end, { "i", "s" }),
}

cmp.setup({
    -- ▼ 代码片段引擎配置 ▼
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- 仅启用 vsnip
        end,
    },

    -- ▼ 补全源配置 ▼
    sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 }, -- 最高优先级
        { name = "vsnip", priority = 900 }, -- 代码片段
        { name = "buffer", priority = 750 }, -- 缓冲区内容
        { name = "path", priority = 500 }, -- 文件路径
    }),

    -- ▼ 快捷键映射 ▼
    mapping = mapping,

    -- ▼ 图标格式化配置 ▼
    formatting = {
        expandable_indicator = true, -- 显示可扩展代码片段标记
        fields = { "abbr", "kind", "menu" }, -- 显示顺序和字段

        format = lspkind.cmp_format({
            mode = "symbol_text", -- 显示图标 + 文本
            --mode = "symbol", -- 显示图标 + 文本
            maxwidth = {
                menu = 50, -- 菜单最大宽度
                abbr = 50, -- 补全项最大宽度
            },
            ellipsis_char = "…", -- 截断符号
            show_labelDetails = true,
            before = function(entry, vim_item)
                -- 动态加载检测
                if not package.loaded["lspkind"] then
                    require("lspkind").init()
                end

                -- 添加来源类型图标
                --        vim_item.menu = ({
                --          nvim_lsp = " ",
                --          vsnip = " ",
                --          buffer = "📑",
                --          path = "📁"
                --         })[entry.source.name]
                return vim_item
            end,
        }),
    },

    -- ▼ 实验性功能 ▼
    experimental = {
        ghost_text = true, -- 幽灵文本预览
        native_menu = false,
    },

    -- ▼ 性能优化参数 ▼
    performance = {
        -- █ 异步处理预算（毫秒）
        -- 控制异步操作的总体时间预算
        async_budget = 18, -- 默认 15ms

        -- █ 确认补全项时的解析超时
        -- 影响 LSP 补全项详细信息加载
        confirm_resolve_timeout = 500, -- 默认 500ms

        -- █ 去抖动延迟（毫秒）
        -- 防止快速连续输入时的频繁刷新
        debounce = 50, -- 默认 15ms

        -- █ 补全源响应超时（毫秒）
        -- 单个补全源的最大等待时间
        fetching_timeout = 500, -- 默认 500ms

        -- █ 过滤上下文预算（毫秒）
        -- 影响补全项过滤性能
        filtering_context_budget = 200, -- 默认 200ms

        -- █ 最大显示条目数
        -- 同时显示的补全建议最大数量
        max_view_entries = 20, -- 默认 200

        -- █ 节流间隔（毫秒）
        -- 控制补全请求的最小间隔
        throttle = 30, -- 默认 5ms
    },
})

-- ▼ 命令行补全配置 ▼
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
        { name = "cmdline", keyword_length = 3 },
    }),
})

-- ▼ 括号补全配置 ▼
require("nvim-autopairs").setup({
    enable_abbrev = false, -- 禁用缩写扩展
    ignored_next_char = "[%w%.]", -- 遇到字母或数字不触发补全
    check_ts_interval = 150, -- treesitter 检查间隔（ms）
    fast_wrap = {
        max_length = 80, -- 超过 80 列不自动换行
        wrap_pattern = "\\w+", -- 仅对单词换行
        map = "<M-e>", -- 快速换行快捷键
    },
    check_ts = true, -- 基于 treesitter 的智能配对
    disable_filetype = { "TelescopePrompt", "neo-tree" },
    cmp_autopairs = {
        enable = true, -- 启用 cmp 集成
        map_char = {
            all = "(", -- 所有括号类型触发补全
            tex = "{", -- LaTeX 文件特殊处理
        },
    },
})

-- ▼ 确保与 cmp 的事件绑定 ▼
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- 🎮 增强 Lua LSP（专门为 Neovim Lua 开发优化）
require("neodev").setup()

lsp.lua_ls.setup({
    on_attach = on_attach,
    --capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
            diagnostics = {
                disable = { "missing-fields" }, -- 禁用缺少字段的警告
            },
        },
    },
})

-- 📊 LSP 状态指示器（显示后台操作进度）
require("fidget").setup({
    notification = {
        -- ▼ 窗口配置 ▼
        window = {
            border = "rounded", -- 统一边框样式
        },
    },

    -- ▼ 进度条配置 ▼
    progress = {
        display = {
            done_icon = "✓", -- 完成图标
            progress_style = { -- 动画样式
                pattern = "dots",
                period = 1,
            },
        },
    },
})
