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

local lspsaga = require("lspsaga")
lspsaga.setup({ -- defaults ...
    debug = false,
    use_saga_diagnostic_sign = true,
    -- diagnostic sign
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    diagnostic_header_icon = "  ",
    -- code action title icon
    code_action_icon = " ",
    code_action_prompt = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
    finder_definition_icon = "  ",
    finder_reference_icon = "  ",
    max_preview_lines = 10,
    finder_action_keys = {
        -- open = "o",
        open = "<CR>",
        vsplit = "s",
        split = "i",
        -- quit = "q",
        quit = "<ESC>",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    },
    code_action_keys = {
        -- quit = "q",
        quit = "<ESC>",
        exec = "<CR>",
    },
    rename_action_keys = {
        -- quit = "<C-c>",
        quit = "<ESC>",
        exec = "<CR>",
    },
    definition_preview_icon = "  ",
    border_style = "single",
    rename_prompt_prefix = "➤",
    rename_output_qflist = {
        enable = false,
        auto_open_qflist = false,
    },
    server_filetype_map = {},
    diagnostic_prefix_format = "%d. ",
    diagnostic_message_format = "%m %c",
    highlight_prefix = false,
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
