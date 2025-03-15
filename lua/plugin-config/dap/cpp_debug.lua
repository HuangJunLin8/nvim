local dap = require("dap")


-- 配置 codelldb 适配器: 调试rust、c++
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


    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
            end
        end,
        on_stderr = function(_, data)
            if data then
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

            -- vim.notify(program, vim.log.levels.INFO)

            -- 更新调试配置
            ---@class dap.Configuration
            ---@field program string|function
            dap.configurations.cpp = dap.configurations.cpp or {}
            dap.configurations.cpp[1].program = program

            -- 启动调试会话
            dap.continue()
        else
            vim.notify("调试失败 :( ", vim.log.levels.ERROR)
        end
    end)
end

vim.keymap.set("n", "<F5>", auto_debug)
-- vim.keymap.set("n", "<F5>", dap.continue)