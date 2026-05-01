return {
  -- Configuration du formatage (Conform)
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- Déclenche le formatage à chaque sauvegarde
    config = function()
      local options = require("configs.conform")

      -- 2. ON L'INJECTE VRAIMENT DANS LE PLUGIN (C'est ce qui manquait !)
      require("conform").setup(options)
      vim.keymap.set("n", "<leader>fm", function()
        require("conform").format({ lsp_fallback = true })
      end, { desc = "Formater avec Conform" })
      --require "configs.conform"
    end,
  },

  -- 1. Coloration Syntaxique (Treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Base & Terminal
        "vim", "lua", "vimdoc", "bash", "regex", "markdown", "markdown_inline",
        -- Web Dev (Front & Back)
        "html", "css", "javascript", "typescript", "tsx", "vue", "htmldjango",
        -- Langages de programmation lourds
        "c", "cpp", "python", "rust", "go", "c_sharp", "nasm",
        -- Fichiers de configuration & Outils
        "json", "yaml", "toml", "xml", "latex", "dockerfile", "sql", "gitcommit", "gitignore", "cmake",
      },
    },
  },

  -- 2. Téléchargement des LSPs, Formateurs et Linters (Mason)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Base NvChad
        "lua-language-server", "stylua",
        -- Web & UI
        "html-lsp", "css-lsp", "volar", "prettier", "eslint_d",
        -- Python & Django (L'arsenal ultime)
        "pyright", "black", "mypy", "ruff", "djlint",
        -- C / C++ / C# / Rust / Go / Asm
        "clangd", "clang-format", "omnisharp", "rust-analyzer", "gopls", "asm-lsp",
        -- Web & Data Formats (JSON, YAML, TOML, XML)
        "json-lsp", "yaml-language-server", "taplo", "lemminx",
        -- Docs & Scripts
        "marksman", "markdownlint", "texlab", "latexindent", "bash-language-server", "shfmt",
        -- DevOps & Build
        "dockerfile-language-server", "sqlls", "neocmakelsp",
      },
    },
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Git: Neogit" },
    },
    opts = {},
  },

  {
    "lervag/vimtex",
    lazy = false, -- Indispensable pour que LaTeX charge correctement
    init = function()
      -- 1. Utiliser Zathura pour afficher le PDF
if vim.env.WAYLAND_DISPLAY ~= nil or vim.env.DISPLAY ~= nil then
  vim.g.vimtex_view_method = 'zathura_simple'
else
  vim.g.vimtex_view_method = ''
end
      -- 2. Configurer la compilation avec LuaLaTeX
      vim.g.vimtex_compiler_latexmk = {
        executable = 'latexmk',
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
          '-f',
        },
      }
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = '-lualatex'
      }
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            -- Les raccourcis AZERTY-friendly !
            accept = "<C-l>",  -- Ctrl + l (L comme "Let's go", facile d'accès)
            next = "<A-j>",    -- Alt + j (Suivant, car 'j' descend dans Vim)
            prev = "<A-k>",    -- Alt + k (Précédent, car 'k' monte dans Vim)
            dismiss = "<C-e>", -- Ctrl + e (E comme "Exit" ou "Échapper")
          },
        },
        panel = { enabled = false },
      })
    end,
  },
}
