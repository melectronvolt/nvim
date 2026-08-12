local options = {
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },

    -- Web & UI
    javascript = { "prettier" },
    typescript = { "prettier" },
    vue = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },

    -- Formats de configuration & documentation
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    toml = { "taplo" },

    -- Python & Django
    python = { "black" },
    htmldjango = { "djlint" },

    -- C / C++
    c = { "clang-format" },
    cpp = { "clang-format" },

    -- Shell
    sh = { "shfmt" },

    -- LaTeX
    tex = { "latexindent" },

    -- Go / Rust
    go = { "gofmt" },
    rust = { "rustfmt" },
  },

  -- Paramètres par défaut utilisés par conform.format()
  default_format_opts = {
    lsp_format = "fallback",
  },

  -- Configuration spécifique de certains formatters
  formatters = {
    latexindent = {
      prepend_args = { "--cruft=/tmp" },
    },
  },

  -- Formatage automatique à chaque sauvegarde
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },

  -- Afficher les erreurs de formatage
  notify_on_error = true,

  -- Très utile pendant la mise au point :
  -- avertit si aucun formatter n'est disponible
  notify_no_formatters = true,
}

return options
