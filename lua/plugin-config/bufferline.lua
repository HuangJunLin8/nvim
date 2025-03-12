local status, bufferline = pcall(require, "bufferline")
if not status then
  vim.notify("没有找到 bufferline.nvim")
  return
end

bufferline.setup({
  options = {
    mode = "buffers",
    numbers = "none",
    close_command = "bdelete! %d",
    offsets = {
      { filetype = "NvimTree", text = "文件树", highlight = "Directory" }
    },
    separator_style = "slant",
    show_buffer_icons = true,
    diagnostics = "nvim_lsp"
  }
})

