-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- rename
local map = vim.api.nvim_set_keymap
-- 复用 opt 参数
local opt = {noremap = true, silent = true }



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
map("n", "q", ":q<CR>", opt)
map("n", "qq", ":wq<CR>", opt)
map("n", "Q", ":q!<CR>", opt)
map("i", "jj", "<ESC>", opt)

map("n", "<Leader>s", ":w<CR>", opt) -- 空格 + w 保存

-- insert 模式下，跳到行首行尾
map("i", "<C-h>", "<ESC>I", opt)
map("i", "<C-l>", "<ESC>A", opt)


-- 插件快捷键

-- nvim-tree
-- space + m 键打开关闭tree
map("n", "<A-m>", ":NvimTreeToggle<CR>", opt)


-- Buffer 标签页导航
map("n", "<leader>h", ":BufferLineCyclePrev<CR>", opt)  -- ← 切换到左侧标签页
map("n", "<leader>l", ":BufferLineCycleNext<CR>", opt)  -- → 切换到右侧标签页

-- Buffer 关闭操作
map("n", "<leader>w", ":Bdelete!<CR>", opt)            -- 安全关闭当前标签页（vim-bbye 插件）
map("n", "<leader>bl", ":BufferLineCloseRight<CR>", opt) -- 关闭右侧所有标签页（不含当前）
map("n", "<leader>bh", ":BufferLineCloseLeft<CR>", opt)  -- 关闭左侧所有标签页（不含当前）
map("n", "<leader>bc", ":BufferLinePickClose<CR>", opt)   -- 交互式选择关闭目标标签页


-- Telescope 全局快捷键
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", opt)
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", opt)


-- 导出 Telescope 专用映射表
local M = {}

M.telescope_mappings = {
  i = {
    ["<C-j>"] = "move_selection_next",          -- 下移选项
    ["<C-k>"] = "move_selection_previous",       -- 上移选项
    ["<C-n>"] = "cycle_history_next",           -- 搜索历史下翻
    ["<C-p>"] = "cycle_history_prev",           -- 搜索历史上翻
    ["<C-q>"] = "close",                        -- 关闭窗口
    ["<C-u>"] = "preview_scrolling_up",         -- 预览窗口上滚
    ["<C-d>"] = "preview_scrolling_down",       -- 预览窗口下滚
  },
  n = {
    ["q"] = "close"                             -- 普通模式关闭
  }
}

return M
