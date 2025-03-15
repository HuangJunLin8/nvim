local dap = require("dap")

-- 使用前得确保
-- 1. 有conda的环境，终端要加载对应python环境
-- 2. 环境内debugpy 已经安装

-- Python 调试适配器
dap.adapters.python = {
    type = "executable",
    command = "python",
    args = {
        "-m",
        "debugpy.adapter",
    },
}

-- Python 调试配置
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Debug File",
        program = "${file}", -- 调试当前文件
        pythonPath = function()
            return vim.fn.exepath("python") -- 自动检测 Python 路径
        end,
        console = "integratedTerminal",
        justMyCode = false, -- 调试第三方库代码
        args = function()
            local input = vim.fn.input("输入参数 (空格分隔): ")
            return vim.split(input, " ", { plain = true })
        end,
    },
    -- {
    --  -- 第二个选项（附加到进程中）
    --     type = "python",
    --     request = "attach",
    --     name = "Attach Process",
    --     processId = "${command:pickProcess}",
    --     host = "127.0.0.1",
    --     port = 5678,
    -- },
}
