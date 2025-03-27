-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- rename
local map = vim.api.nvim_set_keymap
-- 复用 opt 参数
local opt = { noremap = true, silent = true }

-- 窗口管理快捷键映射
-- 取消 s 默认功能
map("n", "s", "", opt)
-- windows 分屏快捷键
map("n", "sl", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
-- 关闭当前
map("n", "ss", "<C-w>c", opt)
-- 关闭其他
map("n", "so", "<C-w>o", opt)
-- Alt + hjkl  窗口之间跳转
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

-- 左右比例控制
map("n", "s,", ":vertical resize -20<CR>", opt)
map("n", "s.", ":vertical resize +20<CR>", opt)
map("n", "<C-Left>", ":vertical resize -2<CR>", opt)
map("n", "<C-Right>", ":vertical resize +2<CR>", opt)
-- 上下比例
map("n", "sj", ":resize +10<CR>", opt)
map("n", "sk", ":resize -10<CR>", opt)
map("n", "<C-Down>", ":resize +2<CR>", opt)
map("n", "<C-Up>", ":resize -2<CR>", opt)
-- 等比例
map("n", "s=", "<C-w>=", opt)

-- Terminal相关
map("n", "<leader>t", ":sp | terminal<CR>", opt)
map("n", "<leader>vt", ":vsp | terminal<CR>", opt)
map("t", "<Esc>", "<C-\\><C-n>", opt)
map("t", "<A-h>", [[ <C-\><C-N><C-w>h ]], opt)
map("t", "<A-j>", [[ <C-\><C-N><C-w>j ]], opt)
map("t", "<A-k>", [[ <C-\><C-N><C-w>k ]], opt)
map("t", "<A-l>", [[ <C-\><C-N><C-w>l ]], opt)

-- visual模式下缩进代码
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

map("v", "q", "<Esc>", opt)

-- 上下移动选中文本
map("v", "J", ":move '>+1<CR>gv-gv", opt)
map("v", "K", ":move '<-2<CR>gv-gv", opt)

-- 上下滚动浏览
map("n", "<C-j>", "4j", opt)
map("n", "<C-k>", "4k", opt)
-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

-- 在visual 模式里粘贴不要复制
map("v", "p", '"_dP', opt)

-- 退出
-- 保存并退出
_G.smart_save_quit = function()
    -- 检查当前是否是终端缓冲区
    if vim.bo.buftype == "terminal" then
        -- 使用 ToggleTerm 的关闭命令
        vim.cmd("Lspsaga term_toggle")
        return
    end

    vim.cmd("wall") -- :wall 命令会保存所有已修改的缓冲区
    vim.cmd("qa!") -- 强制退出，避免 :qa 失败

    -- -- 获取当前标签页总数
    -- local buffer_count = vim.fn.len(vim.fn.getbufinfo({buflisted = 1}))

    -- if buffer_count == 1 then
    --   -- 只有一个标签页，直接退出
    --   vim.cmd('qa!') -- 强制退出，避免 :qa 失败
    -- else
    --   -- 多个标签页，弹出确认对话框
    --   local choice = vim.fn.confirm('是否退出所有标签页？', '&Yes\n&No', 1)
    --   if choice == 1 then
    --     -- 用户选择 Yes，退出所有标签页
    --     vim.cmd('qa!')
    --   end
    -- end
end

-- 仅退出不保存
_G.smart_quit = function()
    -- 检查当前是否是终端缓冲区
    if vim.bo.buftype == "terminal" then
        -- 使用 ToggleTerm 的关闭命令
        vim.cmd("Lspsaga term_toggle")
        return
    end

    -- 获取所有已列出的缓冲区
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })

    -- 检查是否有未保存的缓冲区
    local unsaved_buffers = {}
    for _, buf in ipairs(buffers) do
        if buf.changed == 1 then -- `changed == 1` 表示有修改未保存
            table.insert(unsaved_buffers, buf.name ~= "" and buf.name or "[未命名缓冲区]")
        end
    end

    -- 如果有未保存的缓冲区，询问是否保存
    if #unsaved_buffers > 0 then
        local msg = "检测到未保存的缓冲区:\n"
            .. table.concat(unsaved_buffers, "\n")
            .. "\n是否保存后退出？"
        local choice = vim.fn.confirm(msg, "&No\n&Yes\n&Cancel", 3)
        if choice == 2 then
            vim.cmd("wall") -- 保存所有缓冲区
        elseif choice == 3 then
            return -- 取消操作，不退出
        end
    end

    vim.cmd("qa!") -- 只有一个标签页，直接强制退出

    -- -- 获取当前标签页总数
    -- local buffer_count = vim.fn.len(vim.fn.getbufinfo({buflisted = 1}))

    -- if buffer_count == 1 then
    --   -- 只有一个标签页，直接退出
    --   vim.cmd('qa!') -- 强制退出，避免 :qa 失败
    -- else
    --   -- 多个标签页，弹出确认对话框
    --   local choice = vim.fn.confirm('是否退出所有标签页？', '&Yes\n&No', 1)
    --   if choice == 1 then
    --     -- 用户选择 Yes，退出所有标签页
    --     vim.cmd('qa!')
    --   end
    -- end
end

vim.api.nvim_set_keymap("n", "qq", "<Cmd>lua _G.smart_save_quit()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q", "<Cmd>lua _G.smart_quit()<CR>", { noremap = true, silent = true })

-- map("n", "q", ":q<CR>", opt)
-- map("n", "qq", ":wqa<CR>", opt)
map("n", "Q", ":q!<CR>", opt)
map("i", "jj", "<ESC>", opt)

map("n", "<Leader>s", ":w<CR>", opt) -- 空格 + w 保存
map("n", "<C-s>", ":w<CR>", opt) -- 空格 + w 保存

-- insert 模式下，跳到行首行尾
map("n", "<C-h>", "I<ESC>", opt)
map("n", "<C-l>", "A<ESC>", opt)

-- 插件内部快捷键在对应的插件.lua里
-- 启动插件的快捷键在plugins.lua里

-- 普通模式：注释当前行（等效于 gcc）
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })

-- 可视模式：注释选中行（等效于 gc）
vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment selection" })

-- 复制整个文件到剪贴板（支持错误处理）
vim.keymap.set("n", "<leader>a", function()
    -- 检查文件内容有效性
    if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
        vim.notify("空文件，无内容可复制", vim.log.levels.WARN)
        return
    end

    -- 全选并复制到系统剪贴板
    vim.cmd("silent %yank +")
    vim.notify("已复制全文到剪贴板", vim.log.levels.INFO)
end, { desc = "复制全文到剪贴板" })
