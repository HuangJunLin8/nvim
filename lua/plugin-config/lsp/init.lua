local mason_lsp = require("mason-lspconfig")
local lsp = require("lspconfig")

require("plugin-config.lsp.mason")

-- LSP ui
require("plugin-config.lsp.lsp_ui")

--  Neovim Lua 开发优化
require("neodev").setup()

-- lspconfig修改基础配置:   自定义快捷键映射
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

    --  ------------------------------快捷键配置: 基础版本-------------------------------
    -- 基础导航
    -- map("textDocument/definition", "n", "gd", vim.lsp.buf.definition, "跳转到定义")
    -- map("textDocument/declaration", "n", "gD", vim.lsp.buf.declaration, "跳转到声明")
    -- map("textDocument/implementation", "n", "gi", vim.lsp.buf.implementation, "跳转到实现")
    -- map("textDocument/references", "n", "gr", vim.lsp.buf.references, "显示引用")

    --  信息查看
    -- map("textDocument/hover", "n", "gh", vim.lsp.buf.hover, "悬浮文档")
    -- 诊断导航
    -- vim.keymap.set("n", "gp", vim.diagnostic.open_float, { buffer = bufnr, desc = "诊断信息" })
    -- vim.keymap.set("n", "gk", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "上一个诊断" })
    -- vim.keymap.set("n", "gj", vim.diagnostic.goto_next, { buffer = bufnr, desc = "下一个诊断" })

    --  代码操作
    -- map("textDocument/rename", "n", "<leader>rn", vim.lsp.buf.rename, "重命名符号")
    -- map("textDocument/codeAction", "n", "<leader>ca", vim.lsp.buf.code_action, "代码操作")

    --  高级用法
    -- 类型定义（需要服务器支持）
    --map("textDocument/typeDefinition", 'n', '<space>D', vim.lsp.buf.type_definition, '类型定义')

    -- ------------------------------快捷键配置: lspsaga 美化版本--------------------------------------------
    -- 基础导航
    map("textDocument/definition", "n", "gd", "<cmd>Lspsaga preview_definition<CR>", "跳转到定义")
    map("textDocument/references", "n", "gr", "<cmd>Lspsaga lsp_finder<CR>", "显示引用")

    --  信息查看
    map("textDocument/hover", "n", "gh", "<cmd>Lspsaga hover_doc<cr>", "悬浮文档")

    -- 诊断导航
    vim.keymap.set("n", "gp", "<cmd>Lspsaga show_line_diagnostics<CR>", { buffer = bufnr, desc = "诊断信息" })
    vim.keymap.set("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { buffer = bufnr, desc = "上一个诊断" })
    vim.keymap.set("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", { buffer = bufnr, desc = "下一个诊断" })

    --  代码操作
    map("textDocument/rename", "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", "重命名符号") -- 调用 lspsaga 美化
    map("textDocument/codeAction", "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", "代码操作") -- 调用 lspsaga 美化

    -- 额外功能
    vim.keymap.set("n", "<leader>p", "<cmd>Lspsaga term_toggle<cr>", { buffer = bufnr, desc = "打开终端" })

    -- 在终端创建时自动设置 jj 退出映射
    vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*", -- 匹配所有终端
        callback = function(args)
            -- 仅处理 Lspsaga 的浮动终端（根据窗口特征判断）
            local win_config = vim.api.nvim_win_get_config(0)
            if win_config.relative ~= "" then -- 浮动窗口特征
                vim.api.nvim_buf_set_keymap(0, "t", "jj", [[<C-\><C-n>]], {
                    noremap = true,
                    silent = true,
                    nowait = true,
                    desc = "退出终端模式",
                })
            end
        end,
    })

    -- 格式化代码 (用插件 formatter 替代)
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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- lua 诊断配置
lsp.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
            diagnostics = {
                -- 禁用特定类型警告
                disable = {
                    "missing-fields", -- 缺少字段警告
                    "unused-local", -- 未使用的局部变量
                    -- "unused-vararg", -- 未使用的可变参数
                    -- "unused-parameter", -- 未使用的函数参数
                    -- "unused-function", -- 未使用的函数
                },
            },
        },
    },
})

-- python 诊断配置
lsp.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        pyright = {
            disableLanguageServices = false, -- 核心功能开关
            disableOrganizeImports = false, -- 自动整理导入
        },
        python = {
            analysis = {
                autoSearchPaths = true, -- 自动识别项目结构
                diagnosticMode = "workspace", -- 更智能的跨文件诊断
                typeCheckingMode = "off", -- 类型检查强度：strict|basic|off
                stubPath = "./stubs", -- 自定义类型存根路径（无需绝对路径）

                -- 高级诊断控制（按需添加）
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "info",
                    reportMissingImports = "error",
                    -- reportUndefinedVariable = "warning",
                },

                -- 忽略特定类型的错误（正则表达式）
                ignore = { "Django*", "Flask*" }, -- 忽略框架相关误报
            },
        },
    },
    -- 可选：文件类型关联
    filetypes = { "python", "django", "jinja.html" },
})
