-- nvim-dap.lua - Debug Adapter Protocol (DAP) Configuration
-- Antifragile layered debugging setup for JS/TS/Python

return {
  -- Layer 1: Core DAP Engine
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Layer 2: Language Adapters
      "mxsdev/nvim-dap-vscode-js",
      "mfussenegger/nvim-dap-python",

      -- Layer 3: UI Enhancements
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- Required by dap-ui
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },

    -- Lazy load: Only load when debugging keybind is pressed
    keys = {
      { "<leader>b", desc = "Debug" },
      { "<F5>", desc = "Debug: Continue" },
      { "<F10>", desc = "Debug: Step Over" },
      { "<F11>", desc = "Debug: Step Into" },
      { "<F12>", desc = "Debug: Step Out" },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ============================================================================
      -- Layer 2: Language Adapters Configuration
      -- ============================================================================

      -- JS/TS Adapter (vscode-js-debug via Mason)
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = {
          "pwa-node",
          "pwa-chrome",
          "pwa-msedge",
          "node-terminal",
          "pwa-extensionHost",
        },
      })

      -- JS/TS Debug Configurations
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          -- Debug single node file
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Current File (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          -- Debug node process (attach)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to Node Process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          -- Debug Vitest tests
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Vitest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/vitest/vitest.mjs",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          -- Debug Jest tests
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/.bin/jest",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end

      -- Python Adapter (debugpy with UV support!)
      require("dap-python").setup("uv") -- ← UV integration!

      -- Python Debug Configurations
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch Current File (Python)",
        program = "${file}",
        console = "integratedTerminal",
      })

      -- ============================================================================
      -- Layer 3: UI Configuration
      -- ============================================================================

      -- DAP UI Setup
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        controls = {
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })

      -- Virtual Text Setup (show variable values inline)
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = "<module",
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- Telescope DAP Integration
      require("telescope").load_extension("dap")

      -- ============================================================================
      -- Auto-open/close DAP UI
      -- ============================================================================

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ============================================================================
      -- Keybindings: <leader>b* namespace + F-keys
      -- ============================================================================

      -- Core Debug Actions
      vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>bB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>bc", dap.continue, { desc = "Continue/Start Debugging" })
      vim.keymap.set("n", "<leader>bt", dap.terminate, { desc = "Terminate Session" })

      -- Stepping (F-keys for speed + Leader alternatives for discovery)
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })

      vim.keymap.set("n", "<leader>bso", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>bsi", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>bsu", dap.step_out, { desc = "Step Out" })

      -- UI & Information
      vim.keymap.set("n", "<leader>bu", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>br", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>be", dapui.eval, { desc = "Evaluate Expression" })
      vim.keymap.set("v", "<leader>be", dapui.eval, { desc = "Evaluate Selection" })
      vim.keymap.set("n", "<leader>bh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Hover Variable" })

      -- Advanced
      vim.keymap.set("n", "<leader>bC", dap.run_to_cursor, { desc = "Run to Cursor" })
      vim.keymap.set("n", "<leader>bf", ":Telescope dap commands<CR>", { desc = "DAP Commands" })
      vim.keymap.set("n", "<leader>bv", ":Telescope dap variables<CR>", { desc = "DAP Variables" })
      vim.keymap.set("n", "<leader>bl", ":Telescope dap list_breakpoints<CR>", { desc = "List Breakpoints" })

      -- ============================================================================
      -- DAP Signs (gutter icons for breakpoints)
      -- ============================================================================

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticHint", linehl = "CursorLine", numhl = "" })
    end,
  },
}
