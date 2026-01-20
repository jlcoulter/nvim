-- Bootstrap lazy.nvim
vim = vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.clipboard = "unnamedplus"

vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("bashls")
vim.lsp.enable("jsonls")

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
      "folke/tokyonight.nvim",
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("tokyonight")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files)
        vim.keymap.set("n", "<leader>fg", builtin.live_grep)
        vim.keymap.set("n", "<leader>fb", builtin.buffers)
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      opts = {
        ensure_installed = { "lua", "vim", "python", "json" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      },

      {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
      },
      {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("lualine").setup({
            options = { theme = "tokyonight" },
          })
        end,
      },

      {
        "williamboman/mason.nvim",
        config = function()
          require("mason").setup()
        end,
      },

      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
          require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pyright", "bashls", "jsonls" },
          })
        end,
      },
      {
        'stevearc/conform.nvim',
        opts = {},
      },

      {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
          -- 'super-tab' for mappings similar to vscode (tab to accept)
          -- 'enter' for enter to accept
          -- 'none' for no mappings
          --
          -- All presets have the following mappings:
          -- C-space: Open menu or open docs if already open
          -- C-n/C-p or Up/Down: Select next/previous item
          -- C-e: Hide menu
          -- C-k: Toggle signature help (if signature.enabled = true)
          --
          -- See :h blink-cmp-config-keymap for defining your own keymap
          keymap = { preset = 'super-tab' },

          appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
          },

          -- (Default) Only show the documentation popup when manually triggered
          completion = { documentation = { auto_show = false } },

          -- Default list of enabled providers defined so that you can extend it
          -- elsewhere in your config, without redefining it, due to `opts_extend`
          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
          },

          -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
          -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
          -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
          --
          -- See the fuzzy documentation for more information
          fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
      },
      {
        "mfussenegger/nvim-lint",
        opts = {
          -- Event to trigger linters
          events = { "BufWritePost", "BufReadPost", "InsertLeave" },
          linters_by_ft = {
            fish = { "fish" },
            json = { "jsonlint" },
            lua = { "luacheck" },
            -- Use the "*" filetype to run linters on all filetypes.
            -- ['*'] = { 'global linter' },
            -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
            -- ['_'] = { 'fallback linter' },
            -- ["*"] = { "typos" },
          },
          -- LazyVim extension to easily override linter options
          -- or add custom linters.
          ---@type table<string,table>
          linters = {
            -- -- Example of using selene only when a selene.toml file is present
            -- selene = {
            --   -- `condition` is another LazyVim extension that allows you to
            --   -- dynamically enable/disable linters based on the context.
            --   condition = function(ctx)
            --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
            --   end,
            -- },
          },
        },
        config = function(_, opts)
          local M = {}

          local lint = require("lint")
          for name, linter in pairs(opts.linters) do
            if type(linter) == "table" and type(lint.linters[name]) == "table" then
              lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
              if type(linter.prepend_args) == "table" then
                lint.linters[name].args = lint.linters[name].args or {}
                vim.list_extend(lint.linters[name].args, linter.prepend_args)
              end
            else
              lint.linters[name] = linter
            end
          end
          lint.linters_by_ft = opts.linters_by_ft

          function M.debounce(ms, fn)
            local timer = vim.uv.new_timer()
            return function(...)
              local argv = { ... }
              timer:start(ms, 0, function()
                timer:stop()
                vim.schedule_wrap(fn)(unpack(argv))
              end)
            end
          end

          function M.lint()
            -- Use nvim-lint's logic first:
            -- * checks if linters exist for the full filetype first
            -- * otherwise will split filetype by "." and add all those linters
            -- * this differs from conform.nvim which only uses the first filetype that has a formatter
            local names = lint._resolve_linter_by_ft(vim.bo.filetype)

            -- Create a copy of the names table to avoid modifying the original.
            names = vim.list_extend({}, names)

            -- Add fallback linters.
            if #names == 0 then
              vim.list_extend(names, lint.linters_by_ft["_"] or {})
            end

            -- Add global linters.
            vim.list_extend(names, lint.linters_by_ft["*"] or {})

            -- Filter out linters that don't exist or don't match the condition.
            local ctx = { filename = vim.api.nvim_buf_get_name(0) }
            ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
            names = vim.tbl_filter(function(name)
              local linter = lint.linters[name]
              if not linter then
                LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
              end
              return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
            end, names)

            -- Run linters.
            if #names > 0 then
              lint.try_lint(names)
            end
          end

          vim.api.nvim_create_autocmd(opts.events, {
            group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
            callback = M.debounce(100, M.lint),
          })
        end,
      },
      {
        "stevearc/conform.nvim",
        -- Event to lazy-load the plugin. "BufWritePre" formats on save.
        event = { "BufWritePre" },
        -- A command to check active formatters (optional, but useful for debugging)
        cmd = { "ConformInfo" },
        -- Optional keymap to manually format the buffer
        keys = {
          {
            "<leader>f",
            function()
              require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "", -- Applies to normal and visual modes
            desc = "Format buffer",
          },
        },
        opts = {
          -- Define your formatters by file type
          formatters_by_ft = {
            lua = { "stylua" },
            json = { "prettierd", "prettier" },
            -- You can add more filetypes and their preferred formatters here
          },
          -- Set default options for all formatters
          default_format_opts = {
            lsp_format = "fallback",
            async = false,
            timeout_ms = 500,
          },
          -- Format on save
          format_on_save = function(bufnr)
            -- Disable auto-format for specific filetypes if needed
            if vim.b[bufnr].conform_disable then
              return
            end
            return { timeout_ms = 500 }
          end,
        },
      },
      {
        "mfussenegger/nvim-dap",
        recommended = true,
        desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

        dependencies = {
          "rcarriga/nvim-dap-ui",
          -- virtual text for the debugger
          {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
          },
        },
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
        -- mason-nvim-dap is loaded when nvim-dap loads
        config = function() end,
      },



    }
  }
})
