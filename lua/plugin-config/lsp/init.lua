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


