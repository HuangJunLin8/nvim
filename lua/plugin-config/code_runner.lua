local status, run = pcall(require, "code_runner")
if not status then
    vim.notify("没有找到 code_runner")
    return
end

run.setup({
    -- 终端模式选择
    --mode = "tab",
    --mode = "float",
    --mode = "toggle",
    mode = "term",

    -- 启动时进入插入模式（参见 ':h inserting-ex' 帮助文档）
    startinsert = true,
    insert_prefix = "",

    term = {
        -- 终端打开位置（如果 mode 不为 term 则此选项无效）
        position = "bot",
        -- 终端窗口高度（当 mode 为 tab 时此选项无效）
        size = 11,
    },

    float = {
        -- 关闭浮动窗口的快捷键
        close_key = "q",
        -- 浮动窗口边框样式（参见 ':h nvim_open_win' 帮助文档）
        --border = "shadow",
        --border = "single"   -- 单线边框（默认）
        --border = "double"   -- 双线边框
        border = "rounded", -- 圆角边框
        --border = "solid"    -- 无间隔实线
        --border = "shadow"   -- 阴影效果（无实际边框，通过阴影营造悬浮感）  丑
        --border = "none"     -- 无边框

        -- 测量值范围 0-1（表示相对于窗口的比例）
        height = 0.75,
        width = 0.75,
        x = 0.5, -- 水平居中
        y = 0.5, -- 垂直居中

        -- 浮动窗口边框高亮组（参见 ':h winhl'）
        border_hl = "FloatBorder",
        -- 浮动窗口内容区域高亮组
        float_hl = "Normal",

        -- 窗口透明度（参见 ':h winblend'）
        blend = 0,
    },

    filetype = {
        cpp = function()
            local c_base = {
                "cd $dir &&",
                "g++ -std=c++17  $fileName -o",
                "/tmp/$fileNameWithoutExt",
            }
            local c_exec = {
                "&& /tmp/$fileNameWithoutExt &&",
                "rm /tmp/$fileNameWithoutExt",
            }
            local full_cmd = table.concat(vim.list_extend(c_base, c_exec))
            require("code_runner.commands").run_from_fn(full_cmd)
        end,
    },
})

vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })
