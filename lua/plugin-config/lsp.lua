local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
local lsp = require('lspconfig')

-- 获取增强的 LSP 能力（用于补全）
--local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- =============================== LSP 核心配置 ===============================
-- :Mason 包管理器
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


-- mason-lspconfig: 自动安装语言服务器
mason_lsp.setup({
  ensure_installed = {
    "lua_ls",                    -- Lua
    "clangd",                    -- C/C++
    "pyright",                   -- Python
    "jsonls",                    -- JSON
  },
  automatic_installation = true, -- 自动检测并安装缺失的 LSP
})


-- lspconfig修改基础配置:自定义快捷键映射
local on_attach = function(client, bufnr)
  -- 统一键盘映射函数（带服务器能力检查）
  local map = function(method, mode, keys, func, desc)
    if client.supports_method(method) then
      vim.keymap.set(mode, keys, func, {
        buffer = bufnr,
        desc = 'LSP: ' .. desc,
        noremap = true,
        silent = true
      })
    end
  end

  --  基础导航
  map("textDocument/definition", 'n', 'gd', vim.lsp.buf.definition, '跳转到定义')
  map("textDocument/declaration", 'n', 'gD', vim.lsp.buf.declaration, '跳转到声明')
  map("textDocument/implementation", 'n', 'gi', vim.lsp.buf.implementation, '跳转到实现')
  map("textDocument/references", 'n', 'gr', vim.lsp.buf.references, '显示引用')

  --  信息查看
  map("textDocument/hover", 'n', 'gh', vim.lsp.buf.hover, '悬浮文档')
  map("textDocument/diagnostic", 'n', 'gp', vim.diagnostic.open_float, '诊断信息')

  --  代码操作
  map("textDocument/rename", 'n', '<leader>rn', vim.lsp.buf.rename, '重命名符号')
  map("textDocument/codeAction", 'n', '<leader>ca', vim.lsp.buf.code_action, '代码操作')

  -- 格式化需要特殊处理
  if client.supports_method("textDocument/formatting") then
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({
        async = true,
        filter = function(format_client)
          -- 只允许特定客户端格式化
          return format_client.name ~= "tsserver"
        end
      })
    end, { buffer = bufnr, desc = 'LSP: 格式化代码' })
  end

  -- 诊断导航
  vim.keymap.set('n', 'gk', vim.diagnostic.goto_prev, { buffer = bufnr, desc = '上一个诊断' })
  vim.keymap.set('n', 'gj', vim.diagnostic.goto_next, { buffer = bufnr, desc = '下一个诊断' })

  --  高级用法
  -- 类型定义（需要服务器支持）
  --map("textDocument/typeDefinition", 'n', '<space>D', vim.lsp.buf.type_definition, '类型定义')
end

-- 加载修改后的lspconfig配置
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



-- =============================== LSP 增强配置 ===============================

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
      border = "rounded" -- 统一边框样式
    },
  },

  -- ▼ 进度条配置 ▼
  progress = {
    display = {
      done_icon = "✓", -- 完成图标
      progress_style = { -- 动画样式
        pattern = "dots",
        period = 1
      }
    }
  },

})
