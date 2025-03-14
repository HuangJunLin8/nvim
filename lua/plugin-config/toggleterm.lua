-- 浮动终端配置
local M = {}

function M.setup()
  require("toggleterm").setup({
    size = 15,
    open_mapping = nil, -- 禁用插件自带的默认快捷键
    direction = "float",
    float_opts = {
      border = "rounded",
      width = function()
        return math.floor(vim.o.columns * 0.8)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.7)
      end,
    },
    on_open = function(term)
      -- 设置终端专用快捷键
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "t",
        "jj",
        "<C-\\><C-n>", -- 退出终端插入模式
        { noremap = true, silent = true }
      )
      vim.cmd("startinsert!") -- 刚开始自动进入插入模式
    end,

  })

  -- 打开终端k
  vim.keymap.set("n", "<leader>p", function()
    local cmd = "ToggleTerm direction=float"
    vim.cmd(cmd)
  end, { desc = "打开终端" })

  -- 设置编译运行快捷键（需要插件加载后执行）
  -- vim.keymap.set("n", "<A-j>", function()
  --   local filename = vim.fn.expand("%:t:r") -- 获取无扩展名的文件名
  --   local cmd = string.format(
  --     "TermExec cmd='clear; g++ %% -o %s && ./%s || echo \"编译失败\"; rm -f %s' direction=float",
  --     filename,
  --     filename,
  --     filename
  --   )
  --   vim.cmd(cmd)
  -- end, { desc = "编译运行 C++" })
end

-- 通用终端配置（所有终端实例生效）
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false -- 禁用行号
    vim.opt_local.signcolumn = "no" -- 隐藏标记列
    vim.opt_local.relativenumber = false
  end,
})

return M
