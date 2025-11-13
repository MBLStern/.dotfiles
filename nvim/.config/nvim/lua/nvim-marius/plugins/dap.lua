return {
    'mfussenegger/nvim-dap',
    dependencies = { "rcarriga/nvim-dap-ui",
        "leoluz/nvim-dap-go",
        "nvim-neotest/nvim-nio" },
    config = function()
        local home = os.getenv('HOME')
        local dap = require('dap')

        -- dapui setup
        local dapui = require('dapui')

        require('dapui').setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        -- debug adabter configurations

        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" }
        }

        dap.adapters.coreclr = {
            type = 'executable',
            command = home .. '/.local/share/nvim/mason/bin/netcoredbg',
            args = { '--interpreter=vscode' }
        }

        -- language configurations
        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "gdb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
        }

        dap.configurations.c = dap.configurations.cpp

        dap.configurations.cs = {
            {
                type = "coreclr",
                name = "launch - netcoredbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                end,
            },
        }

        dap.configurations.rust = dap.configurations.cpp

        require('dap-go').setup()
        -- Keymaps

        vim.keymap.set('n', '<F5>', function() dap.continue() end)
        vim.keymap.set('n', '<F10>', function() dap.step_over() end)
        vim.keymap.set('n', '<F11>', function() dap.step_into() end)
        vim.keymap.set('n', '<F12>', function() dap.step_out() end)
        vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
        vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)
        vim.keymap.set('n', '<Leader>lp',
            function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
        vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end)
        vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
        vim.keymap.set('n', '<Leader>de', function()
            dap.disconnect({ terminateDebuggee = true });
            dap.terminate();
            dapui.close()
        end)
        vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
            require('dap.ui.widgets').hover()
        end)
        vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
            require('dap.ui.widgets').preview()
        end)
        vim.keymap.set('n', '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end)
        vim.keymap.set('n', '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end)
    end
}
