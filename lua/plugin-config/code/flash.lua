local status, flash = pcall(require, "flash")
if not status then
    vim.notify("没有找到 flash.nvim")
    return
end

flash.setup({
    modes = {
        search = {
            jump = {
                -- 核心配置：启用 Treesitter 节点跳转
                treesitter = {
                    enabled = true, -- 开启集成
                    highlight = { backdrop = false }, -- 关闭背景高亮避免干扰
                },
            },
        },
    },
    -- 优化标签字符（与你的代码语言适配）
    labels = "asdghklqwertyuiopzxcvbnmfjASDGHKLQWERTYUIOPZXCVBNMFJ",
    label = {
        style = "overlay", -- 更简洁的标签显示
        uppercase = false, -- 禁用大写字母
        rainbow = {
            enabled = true, -- 彩虹色标签
            shade = 5, -- 色阶范围
        },
    },
})
