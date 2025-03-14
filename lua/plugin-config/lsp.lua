local lsp = require('lspconfig')
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')

  -- 🛠️ LSP/DAP/Linter 管理器（用于安装语言服务器）
mason.setup({
  ui = {
    border = 'rounded',
    height = 0.8,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})


-- 自动安装语言服务器
mason_lsp.setup({
  ensure_installed = {
    "lua_ls",                    -- Lua
    "clangd",                    -- C/C++
    "pyright",                   -- Python
    "jsonls",                    -- JSON
  },
  automatic_installation = true, -- 自动检测并安装缺失的 LSP
})


-- 获取增强的 LSP 能力（用于补全）
--local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- 自定义快捷键映射
local on_attach = function(client, bufnr)
  -- 使用 vim.keymap.set 的 buffer 局部映射
  local map = function(mode, keys, func, desc)
    vim.keymap.set(mode, keys, func, {
      buffer = bufnr,
      desc = 'LSP: ' .. desc,
      noremap = true,
      silent = true
    })
  end

  -- 导航类快捷键
  map('n', 'gd', vim.lsp.buf.definition, '跳转到定义')
  map('n', 'gD', vim.lsp.buf.declaration, '跳转到声明')
  map('n', 'gi', vim.lsp.buf.implementation, '跳转到实现')
  map('n', 'gr', vim.lsp.buf.references, '显示引用')

  -- 信息查看
  map('n', 'gh', vim.lsp.buf.hover, '悬浮文档')
  map('n', 'gp', vim.diagnostic.open_float, '诊断信息')

  -- 代码操作
  map('n', '<leader>rn', vim.lsp.buf.rename, '重命名符号')
  map('n', '<leader>ca', vim.lsp.buf.code_action, '代码操作')
  map('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true }) -- 异步格式化
  end, '格式化代码')

  -- 诊断导航
  map('n', 'gk', vim.diagnostic.goto_prev, '上一个诊断')
      map('n', 'gj', vim.diagnostic.goto_next, '下一个诊断')

  -- 类型定义（可选）
  -- map('n', '<space>D', vim.lsp.buf.type_definition, '类型定义')
end

-- 其他语言服务器配置（通用模式）
local servers = {
  'clangd',  -- C/C++
  'pyright', -- Python
  'jsonls'   -- JSON
}

for _, server in ipairs(servers) do
  lsp[server].setup({
    on_attach = on_attach,
    --capabilities = capabilities
  })
end

-- 🎮 增强 Lua LSP（专门为 Neovim Lua 开发优化）
require('neodev').setup() -- 必须前置配置
lsp.lua_ls.setup({
  on_attach = on_attach,
  --capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true)
      },
      telemetry = { enable = false }
    }
  }
})



-- 📊 LSP 状态指示器（显示后台操作进度）
require("fidget").setup({
  notification = {
    -- ▼ 窗口配置 ▼
    window = {
      border = "rounded"   -- 统一边框样式
    },
  },

  -- ▼ 进度条配置 ▼
  progress = {
    display = {
      done_icon = "✓",   -- 完成图标
      progress_style = { -- 动画样式
        pattern = "dots",
        period = 1
      }
    }
  },

})
