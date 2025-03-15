local mason = require("mason")
local mason_lsp = require("mason-lspconfig")

-- :Mason 包管理器配置
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