-- DAP 配置代码将在下一步添加
local dap = require("dap")
local dapui = require("dapui")

-- 配置 codelldb 适配器
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
    },
}

-- C++ 调试配置
dap.configurations.cpp = {
    {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,

        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        environment = {},
        externalConsole = false,
    },
}

-- 自定义 UI 布局（可选）
dapui.setup({
    layouts = {
        -- 左侧垂直面板
        {
            elements = {
                { id = "scopes", size = 0.6 }, -- 变量作用域
                { id = "watches", size = 0.3 }, -- 监视表达式
                { id = "breakpoints", size = 0.1 }, -- 断点列表
                -- { id = "stacks", size = 0.25 },  -- 调用栈
            },
            size = 35, -- 面板宽度
            position = "left", -- 面板位置
        },

        -- 底部水平面板
        {
            elements = {
                { id = "repl", size = 0.4 }, -- 调试控制台
                { id = "console", size = 0.6 }, -- 程序输出
            },
            size = 8, -- 面板高度
            position = "bottom", -- 面板位置
        },
    },
})

-- 自动打开 UI
dap.listeners.before.launch.event_terminated = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- 虚拟文本: 实时显示变量值
require("nvim-dap-virtual-text").setup({
    -- 基础显示配置
    enabled = true, -- 默认开启虚拟文本
    commented = false, -- 不在注释中显示变量值
    highlight_changed_variables = true, -- 高亮修改过的变量
    only_first_definition = false, -- 不只显示变量首次定义位置

    -- 视觉美化配置
    virt_text_pos = "eol", -- 显示位置 (eol|inline)
    virt_text_win_col = nil, -- 强制指定列数显示 (nil=自动)

    -- 符号与文字
    -- prefix = "➤ ", -- 变量前缀符号
    -- separator = " ", -- 变量名与值的分隔符

    -- 高亮组定制
    virt_text_hl = "Comment", -- 基础高亮组
    changed_variable_hl = "WarningMsg", -- 变量修改后的高亮组
    error_variable_hl = "ErrorMsg", -- 错误值的高亮组

    -- 显示逻辑控制
    show_stop_reason = true, -- 显示停止原因 (断点/异常等)
    all_frames = false, -- 显示所有栈帧中的变量
    delay = 100, -- 更新延迟 (毫秒)

    -- 高级格式化回调 (自定义显示内容)
    display_callback = function(variable, buf, stackframe, node)
        local value = variable.value
        -- 美化浮点数显示
        if type(value) == "number" and math.floor(value) ~= value then
            value = string.format("%.2f", value)
        end
        return "🐞 " .. variable.name .. " = " .. value
    end,
})

-- 智能检测构建系统
local function detect_build_system()
    local cwd = vim.fn.getcwd()

    -- 优先级: Makefile > CMake > 单文件编译
    if vim.fn.filereadable(cwd .. "/Makefile") == 1 then
        return "make"
    elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        return "cmake"
    else
        return "single_file"
    end
end

-- 获取可执行文件路径
local function get_executable_path(build_type)
    local default_name = vim.fn.expand("%:t:r") -- 当前文件名（不带扩展名）
    local cwd = vim.fn.getcwd()

    if build_type == "cmake" then
        return cwd .. "/build/" .. default_name
    elseif build_type == "make" then
        return cwd .. "/" .. default_name
    else
        return cwd .. "/" .. default_name
    end
end

-- 异步构建任务
local function async_build(callback)
    local build_type = detect_build_system()

    local cmd = ({
        make = { "make", "-j4" },
        cmake = { "cmake", "--build", "build", "--config", "Debug" },
        single_file = {
            "g++",
            "-g",
            vim.fn.expand("%"),
            "-o",
            get_executable_path(build_type),
        },
    })[build_type]

    -- vim.notify(table.concat(cmd), vim.log.levels.INFO)   -- 调试信息

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                -- vim.notify("here1", vim.log.levels.INFO)
                vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
            end
        end,
        on_stderr = function(_, data)
            if data then
                -- vim.notify("here2", vim.log.levels.INFO)
                vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
            end
        end,
        on_exit = function(_, code)
            if code == 0 then
                vim.notify("构建成功 🚀", vim.log.levels.INFO)
                callback(true)
            else
                vim.notify("构建失败 ❌", vim.log.levels.ERROR)
                callback(false)
            end
        end,
    })
end

-- 自动调试启动器
local function auto_debug()
    async_build(function(success)
        if success then
            local build_type = detect_build_system()
            local program = get_executable_path(build_type)

            vim.notify(program, vim.log.levels.INFO)

            -- 更新调试配置
            ---@class dap.Configuration
            ---@field program string|function
            dap.configurations.cpp = dap.configurations.cpp or {}
            dap.configurations.cpp[1].program = program

            -- 启动调试会话
            dap.continue()
            -- require("dapui").open()
        else
            vim.notify("调试失败 :( ", vim.log.levels.ERROR)
        end
    end)
end

-- 设置调试快捷键
-- vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F5>", auto_debug)
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)

-- 界面快捷键
vim.keymap.set("n", "<leader>du", dapui.toggle) -- 打开调试界面
vim.keymap.set("n", "<leader>de", dapui.eval) -- 查看变量的取值
