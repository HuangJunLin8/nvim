local status, ident_blankline = pcall(require, "ibl")
if not status then
    vim.notify("没有找到 indent_blankline")
    return
end

local hooks = require("ibl.hooks")

--  颜色调整参数 (修复透明度处理方式)
local color_opacity = 100 -- 透明度百分比 (0~100)
local color_brightness = 0.8 -- 亮度系数

--  修复后的颜色生成函数
local function adjust_color(hex_color)
    -- 去除 # 符号
    local hex = hex_color:gsub("#", "")

    -- 提取 RGB 分量
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)

    -- 应用亮度调整
    r = math.floor(r * color_brightness)
    g = math.floor(g * color_brightness)
    b = math.floor(b * color_brightness)

    -- 返回新颜色（不带透明度）
    return string.format("#%02X%02X%02X", r, g, b)
end

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    local base_colors = {
        Red = "#E06C75",
        Yellow = "#E5C07B",
        Blue = "#61AFEF",
        Green = "#98C379",
        Cyan = "#56B6C2",
    }

    for name, color in pairs(base_colors) do
        --  正确设置透明度参数
        vim.api.nvim_set_hl(0, "Rainbow" .. name, {
            fg = adjust_color(color),
            blend = color_opacity, -- 使用 blend 参数控制透明度
        })
    end

    --  修正层级对应关系
    vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { link = "RainbowCyan" }) -- 匹配第一层
    vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { link = "RainbowGreen" }) -- 匹配第二层
end)

--  统一层级顺序配置
local rainbow_highlight = {
    "RainbowCyan", -- 层级1
    "RainbowYellow", -- 层级2
    "RainbowBlue", -- 层级3
    "RainbowGreen", -- 层级4
    "RainbowRed", -- 层级5
}

--  配置 rainbow-delimiters
vim.g.rainbow_delimiters = {
    highlight = rainbow_highlight,
    blacklist = { "markdown", "help" },
}

ident_blankline.setup({
    --  基础显示配置
    -- char = "│",                -- 缩进线字符
    -- char = '¦',
    -- char = '┆',
    -- char = '│',
    -- char = "⎸",
    indent = {
        char = "│",
        highlight = rainbow_highlight,
    },

    scope = {
        enabled = false,
        show_start = false,
        show_end = false,
        highlight = rainbow_highlight,
    },

    --  文件类型控制(不加竖线的文件)
    exclude = {
        filetypes = {
            "dashboard",
            "packer",
            "terminal",
            "help",
            "log",
            "markdown",
            "TelescopePrompt",
            "lsp-installer",
            "lspinfo",
            "toggleterm",
        },
        buftypes = {
            "terminal",
            "nofile",
        },
    },

    --  性能优化参数
    debounce = 150, -- 更新延迟 (ms)
})

--  保留原有高亮组定义（需与彩虹颜色关联）
vim.cmd([[
  highlight IndentBlanklineContextChar guifg=#61AFEF gui=nocombine
]])

--  注册作用域高亮策略（必须）
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
