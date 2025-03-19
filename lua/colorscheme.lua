-- local colorscheme = "tokyonight-moon"
local colorscheme = "catppuccin-mocha"

local function apply_colorscheme()
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not status_ok then
        vim.notify("Colorscheme " .. colorscheme .. " 没有找到！", vim.log.levels.ERROR)
        return
    end
end

-- 配置 tokyonight.nvim
if colorscheme:find("tokyonight") then
    local status, tokyonight = pcall(require, "tokyonight")
    if status then
        tokyonight.setup({
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = { bold = true },
            },
            sidebars = { "qf", "help" },
            dim_inactive = false,
            lualine_bold = false,
        })
    else
        vim.notify("tokyonight.nvim 未找到", vim.log.levels.ERROR)
    end
end

-- 配置 catppuccin.nvim
if colorscheme:find("catppuccin") then
    local status, catppuccin = pcall(require, "catppuccin")
    if status then
        catppuccin.setup({
            flavour = "mocha",
            transparent_background = false,
            term_colors = true,
            integrations = {
                treesitter = true,
                lsp_trouble = true,
                cmp = true,
            },
        })
    else
        vim.notify("catppuccin.nvim 未找到", vim.log.levels.ERROR)
    end
end

-- 应用主题
apply_colorscheme()

