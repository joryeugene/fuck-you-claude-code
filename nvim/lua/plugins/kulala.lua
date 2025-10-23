-- kulala.lua - REST client for HTTP files
-- Fixed: 10MB max response size (was 32KB default)

return {
  "mistweaverco/kulala.nvim",
  ft = "http",
  config = function()
    require("kulala").setup({
      -- Default request timeout (in seconds)
      default_timeout = 30,

      -- Additional cURL options
      additional_curl_options = {},

      -- UI configuration
      ui = {
        -- Maximum response size to display (in bytes)
        -- Default is 32KB (32768), increased to 10MB for large API responses
        max_response_size = 10485760, -- 10MB

        -- Display mode for response body
        default_view = "body",

        -- Enable winbar for HTTP buffers
        winbar = true,

        -- Show icons in the UI
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
            error = "❌",
          },
          lualine = "🐼",
        },

        -- Scratchpad default contents
        scratchpad_default_contents = {
          "@MY_TOKEN_NAME=my_token_value",
          "",
          "# @name scratchpad",
          "POST https://httpbin.org/post HTTP/1.1",
          "accept: application/json",
          "content-type: application/json",
          "",
          "{",
          '  "foo": "bar"',
          "}",
        },
      },

      -- Formatters for different content types
      contenttypes = {
        ["application/json"] = {
          ft = "json",
          formatter = { "jq", "." },
        },
        ["application/xml"] = {
          ft = "xml",
          formatter = { "xmllint", "--format", "-" },
        },
        ["text/html"] = {
          ft = "html",
          formatter = { "xmllint", "--format", "--html", "-" },
        },
      },

      -- Debug mode
      debug = false,
    })

    -- Keymaps for HTTP files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "http",
      callback = function()
        local opts = { buffer = true, silent = true }
        -- Execute request
        vim.keymap.set("n", "<leader>pr", "<cmd>lua require('kulala').run()<cr>", vim.tbl_extend("force", opts, { desc = "Run request" }))
        -- Execute all requests
        vim.keymap.set("n", "<leader>pa", "<cmd>lua require('kulala').run_all()<cr>", vim.tbl_extend("force", opts, { desc = "Run all requests" }))
        -- Jump to next/previous request
        vim.keymap.set("n", "]r", "<cmd>lua require('kulala').jump_next()<cr>", vim.tbl_extend("force", opts, { desc = "Jump to next request" }))
        vim.keymap.set("n", "[r", "<cmd>lua require('kulala').jump_prev()<cr>", vim.tbl_extend("force", opts, { desc = "Jump to previous request" }))
        -- Inspect current request
        vim.keymap.set("n", "<leader>pi", "<cmd>lua require('kulala').inspect()<cr>", vim.tbl_extend("force", opts, { desc = "Inspect request" }))
        -- Toggle headers/body view
        vim.keymap.set("n", "<leader>pt", "<cmd>lua require('kulala').toggle_view()<cr>", vim.tbl_extend("force", opts, { desc = "Toggle view" }))
        -- Copy as cURL command
        vim.keymap.set("n", "<leader>pc", "<cmd>lua require('kulala').copy()<cr>", vim.tbl_extend("force", opts, { desc = "Copy as cURL" }))
        -- Open scratchpad
        vim.keymap.set("n", "<leader>ps", "<cmd>lua require('kulala').scratchpad()<cr>", vim.tbl_extend("force", opts, { desc = "Open scratchpad" }))
      end,
    })
  end,
}
