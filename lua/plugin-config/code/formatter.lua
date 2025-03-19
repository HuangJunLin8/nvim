local status, formatter = pcall(require, "formatter")
if not status then
    vim.notify("没有找到 formatter.nvim")
    return
end

-- 获取工具路径工具函数
local util = require("formatter.util")

-- 文件类型专属配置
formatter.setup({
    filetype = {
        javascript = {
            -- Prettier 配置（带项目级配置检测）
            function()
                return {
                    exe = "prettier",
                    args = {
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--config-precedence=prefer-file", -- 优先使用项目配置
                        "--tab-width=2",
                        "--use-tabs=false",
                    },
                    stdin = true,
                }
            end,
            -- ESLint 自动修复
            require("formatter.filetypes.javascript").eslint,
        },
        lua = {
            -- Stylua 强制空格缩进    cargo install stylua --features lua53
            function()
                return {
                    exe = "stylua",
                    args = {
                        "--indent-type=Spaces",
                        "--indent-width=4",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },
        python = {
            -- Black 配置        sudo apt install black
            function()
                return {
                    exe = "black",
                    args = { "-q", "--line-length=88", "-" },
                    stdin = true,
                }
            end,
        },
        -- 新增 C/C++ 配置
        c = {
            function()
                return {
                    exe = "clang-format", -- 需要先安装 clang-format   sudo apt install clang-format
                    args = {
                        "--assume-filename=." .. vim.fn.expand("%:e"), -- 自动识别文件类型
                        "--style=file", -- 优先使用项目中的 .clang-format 文件
                        "-", -- 从 stdin 读取
                    },
                    stdin = true,
                }
            end,
        },
        cpp = {
            function()
                return {
                    -- 缩进在 ~/.clang-format  里面修改
                    exe = "clang-format",
                    args = {
                        "--assume-filename=." .. vim.fn.expand("%:e"),
                        "--style=file",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },

        ["*"] = {
            -- 全局删除行尾空格
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

-- 绑定格式化快捷键
vim.keymap.set("n", "<leader>f", ":Format<CR>", {
    silent = true,
    desc = "使用 Formatter 格式化代码",
})
