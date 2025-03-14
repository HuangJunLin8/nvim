-- 定义要加载的主题名称
-- local colorscheme = "tokyonight-storm"
-- local colorscheme = "tokyonight-night"
-- local colorscheme = "tokyonight-day"
local colorscheme = "tokyonight-moon"

-- 配置 tokyonight.nvim
require("tokyonight").setup({
    transparent = false, -- 是否启用透明背景
    terminal_colors = true, -- 启用终端颜色
    styles = {
        comments = { italic = true }, -- 注释使用斜体
        keywords = { italic = true }, -- 关键字使用斜体
        functions = { bold = true }, -- 函数名称使用粗体
        variables = {}, -- 变量使用默认样式
    },
    sidebars = { "qf", "help" }, -- 侧边栏样式
    dim_inactive = false, -- 是否降低非活动窗口的亮度
    lualine_bold = false, -- 是否在 lualine 中使用粗体
})


-- 尝试加载主题
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " 没有找到！")
    return
end

