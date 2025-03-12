-- 检查 bufferline 插件是否加载成功
local status, bufferline = pcall(require, "bufferline")
if not status then
  vim.notify("没有找到 bufferline.nvim")
  return
end

-- bufferline 核心配置
bufferline.setup({
  options = {
    -- 显示模式：buffers 显示缓冲区列表，tabs 显示标签页列表
    mode = "buffers",
    -- 标签编号显示方式：none|ordinal|buffer_id
    numbers = "none",
    -- 关闭标签命令（使用 vim-bbye 插件避免布局破坏）
    close_command = "Bdelete! %d",
    -- 右键关闭命令
    right_mouse_command = "Bdelete! %d",
    
    -- 侧边栏偏移配置（适配文件树布局）
    offsets = {
      {
        filetype = "NvimTree",     -- 关联文件树插件
        text = "File Explorer",    -- 侧边栏标题
        highlight = "Directory",   -- 高亮样式组
        text_align = "left"       -- 标题对齐方式
      }
    },
    
    -- 诊断信息集成（使用 nvim 内置 LSP）
    diagnostics = "nvim_lsp",

    -- 可选，显示 LSP 报错图标
    ---@diagnostic disable-next-line: unused-local

    -- 自定义诊断指示器（显示错误/警告数量及图标）
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        -- : 错误 | : 警告 | : 其他
        local sym = e == "error" and " " or (e == "warning" and " " or "")
        s = s .. n .. sym  -- 拼接显示格式：数量 + 图标
      end
      return s
    end,
    
    -- 标签分隔符样式（可选: slant, thick_thin, thin等）
    separator_style = "slant",
    -- 显示文件类型图标（需要 nvim-web-devicons 插件）
    show_buffer_icons = true
  }
})

