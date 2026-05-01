local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Web & UI
    javascript = { "prettier" },
    typescript = { "prettier" },
    vue = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },

    -- Formats de configuration & Docs
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier", "markdownlint" },
    toml = { "taplo" },
    -- XML est géré nativement par le LSP Lemminx (lsp_fallback s'en chargera)

    -- Python & Django
    python = { "black" },      -- Black s'occupe de la mise en page (Mypy et Ruff tournent en fond)
    htmldjango = { "djlint" }, -- Le meilleur formateur pour les templates HTML avec des balises {% %}

    -- Langages lourds & Scripts
    c = { "clang-format" },
    cpp = { "clang-format" },
    sh = { "shfmt" },
    tex = { "latexindent" },

    -- Pour Go, Rust et Assembly, le lsp_fallback gère tout parfaitement.
  },

  -- 2. ON INJECTE TES PARAMÈTRES PERSONNELS ICI
  formatters = {
    latexindent = {
      -- Conform ajoutera le nom du fichier automatiquement à la fin
      prepend_args = { "--cruft=/tmp" },
    },
  },

  -- 3. (Optionnel) Formatage automatique à la sauvegarde
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },

}

return options
