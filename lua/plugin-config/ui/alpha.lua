local status, alpha = pcall(require, "alpha")
if not status then
    vim.notify("没有找到 alpha.nvim")
    return
end

local dashboard = require("alpha.themes.dashboard")

-- 设置 header
dashboard.section.header.val = {
    [[  ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷  ]],
    [[  ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇  ]],
    [[  ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽  ]],
    [[  ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕  ]],
    [[  ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕  ]],
    [[  ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕  ]],
    [[  ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄  ]],
    [[  ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕  ]],
    [[  ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿  ]],
    [[  ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  ]],
    [[  ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟  ]],
    [[  ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠  ]],
    [[  ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙  ]],
    [[  ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣  ]],
    [[                                  ]],
}

-- #a899ff - 浅紫色
-- #9d7cd8 - 柔和紫色
-- #7e57c2 - 深紫色
-- #8a2be2 - 蓝紫色

vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#a899ff", bold = true }) -- 使用紫色（Hex: #a899ff）
dashboard.section.header.opts.hl = "AlphaHeader"


-- 设置快捷功能
dashboard.section.buttons.val = {
    dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
    dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
    dashboard.button("c", "  Edit Config", ":e ~/.config/nvim/init.lua<CR>"),
    dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
}

-- 设置 footer
dashboard.section.footer.val = {
    "     🚀 Happy Coding with Neovim!",
    "https://github.com/HuangJunLin8/nvim.git",
}

-- 设置紫色的 Footer 颜色
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#9ece6a", bold = true })
dashboard.section.footer.opts.hl = "AlphaFooter"

-- 蓝色：#7aa2f7
-- 绿色：#9ece6a
-- 黄色：#e0af68
-- 粉色：#f7768e

-- 配置布局
dashboard.config.opts.noautocmd = true
alpha.setup(dashboard.config)



--      header2 = {
--        [[          ▀████▀▄▄              ▄█ ]],
--        [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
--        [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
--        [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
--        [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
--        [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
--        [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
--        [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
--        [[   █   █  █      ▄▄           ▄▀   ]],
--    },
