local lsp = require("lspconfig")
local util = require("lspconfig/util")

-- 通用 on_attach 和 capabilities 配置（需提前定义）
local on_attach = function(client, bufnr)
    -- 你的按键映射和其他附件逻辑
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Pyright 专属配置
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
                typeCheckingMode = "basic", -- 类型检查强度：strict|basic|off
                stubPath = "./stubs", -- 自定义类型存根路径（无需绝对路径）

                -- 高级诊断控制（按需添加）
                diagnosticSeverityOverrides = {
                    reportUnusedImport = "warning",
                    reportMissingImports = "error",
                    reportUndefinedVariable = "warning",
                },

                -- 忽略特定类型的错误（正则表达式）
                ignore = { "Django*", "Flask*" }, -- 忽略框架相关误报
            },
        },
    },
    -- 可选：文件类型关联
    filetypes = { "python", "django", "jinja.html" },
})
