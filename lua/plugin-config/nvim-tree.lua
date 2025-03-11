local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
    vim.notify("没有找到 nvim-tree: " .. tostring(nvim_tree), vim.log.levels.ERROR)
    return
end

-- 列表操作快捷键
local list_keys = require('keybindings').nvimTreeList

nvim_tree.setup({
    -- 不显示 git 状态图标
    git = {
        enable = false,
    },
    -- 更新当前工作目录
    update_cwd = true,
    -- 更新焦点文件
    update_focused_file = {
        enable = true,
        update_cwd = true,
    },
    -- 隐藏 .文件 和 node_modules 文件夹
    filters = {
        dotfiles = true,
        custom = { 'node_modules' },
    },
    view = {
        -- 宽度
        width = 40,
        -- 侧边栏位置，可以是 'left' 或 'right'
        side = 'left',
        -- 不显示行号
        number = false,
        relativenumber = false,
        -- 显示图标
        signcolumn = 'yes',
    },
    actions = {
        open_file = {
            -- 首次打开大小适配
            resize_window = true,
            -- 打开文件时关闭
            quit_on_open = true,
        },
    },
    -- Linux 使用 xdg-open
    system_open = {
        cmd = 'xdg-open',
    },
})

-- 自动关闭
vim.cmd([[
  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
