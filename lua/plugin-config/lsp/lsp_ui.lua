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


--  LSP 状态指示器（显示后台操作进度）
require("fidget").setup({
    -- notification = {
    --     -- ▼ 窗口配置 ▼
    --     -- window = {
    --         -- border = "rounded", -- 统一边框样式
    --     -- },
    -- },

    -- -- ▼ 进度条配置 ▼
    -- progress = {
    --     display = {
    --         done_icon = "✓", -- 完成图标
    --         progress_style = { -- 动画样式
    --             pattern = "dots",
    --             period = 1,
    --         },
    --     },
    -- },
})
