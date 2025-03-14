local ok, rainbow_setup = pcall(require, "rainbow-delimiters.setup")
if not ok then
  vim.notify("未找到 rainbow-delimiters 插件", vim.log.levels.ERROR)
  return
end

--  先定义高亮组 (必须在 setup 前)
vim.api.nvim_set_hl(0, "RainbowLevel1", { fg = "#E06C75", bold = true })
vim.api.nvim_set_hl(0, "RainbowLevel2", { fg = "#E5C07B" })
vim.api.nvim_set_hl(0, "RainbowLevel3", { fg = "#98C379" })
vim.api.nvim_set_hl(0, "RainbowLevel4", { fg = "#61AFEF" })
vim.api.nvim_set_hl(0, "RainbowLevel5", { fg = "#C678DD" })
vim.api.nvim_set_hl(0, "RainbowLevel6", { fg = "#56B6C2" })

--  正确调用方式：直接执行返回的函数
rainbow_setup({
  highlight = {
    "RainbowLevel1",
    "RainbowLevel2",
    "RainbowLevel3",
    "RainbowLevel4",
    "RainbowLevel5",
    "RainbowLevel6"
  },
  query = "ts",                      -- 修正为字符串或数组格式
  blacklist = { "markdown", "help" } -- 建议添加排除列表
})
