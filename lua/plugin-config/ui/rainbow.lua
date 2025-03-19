local ok, rainbow_setup = pcall(require, "rainbow-delimiters.setup")
if not ok then
    vim.notify("未找到 rainbow-delimiters 插件", vim.log.levels.ERROR)
    return
end

--  先定义高亮组 (必须在 setup 前)
--vim.api.nvim_set_hl(0, "RainbowLevel1", { fg = "#E06C75", bold = true })
--vim.api.nvim_set_hl(0, "RainbowLevel2", { fg = "#E5C07B" })
--vim.api.nvim_set_hl(0, "RainbowLevel3", { fg = "#98C379" })
--vim.api.nvim_set_hl(0, "RainbowLevel4", { fg = "#61AFEF" })
--vim.api.nvim_set_hl(0, "RainbowLevel5", { fg = "#C678DD" })
--vim.api.nvim_set_hl(0, "RainbowLevel6", { fg = "#56B6C2" })

vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

local rainbow_highlight = {
    "RainbowRed", -- 层级1
    "RainbowYellow", -- 层级2
    "RainbowBlue", -- 层级3
    "RainbowGreen", -- 层级4
    "RainbowCyan", -- 层级5
}

-- █ 正确调用方式：直接执行返回的函数
rainbow_setup({
    highlight = rainbow_highlight,
    query = "ts", -- 修正为字符串或数组格式
    blacklist = { "markdown", "help" }, -- 建议添加排除列表
})
