local status, lualine = pcall(require, "lualine")
if not status then
  vim.notify("没有找到 lualine.nvim")
  return
end

lualine.setup({
  options = {
    theme = "auto",
    component_separators = { left = "|", right = "|"},
    section_separators = { left = "", right = "" }
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff", "diagnostics"},
    lualine_c = {"filename"},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  }
})

