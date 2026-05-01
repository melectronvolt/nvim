local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- 1. Liste des serveurs "standards"
local servers = {
  -- Python (Pyright pour le typage/autocomplétion, Ruff pour le linting ultra-rapide)
  "pyright", "ruff", 
  -- Langages compilés / Bas niveau
  "clangd", "rust_analyzer", "gopls", "omnisharp", "neocmakelsp", "asm_lsp",
  -- Web (JS/TS, Vue)
  "ts_ls", "volar",
  -- Formats & Balises (HTML, CSS, JSON, YAML, TOML, XML, Markdown)
  "html", "cssls", "jsonls", "yamlls", "taplo", "lemminx", "marksman",
  -- DevOps & Système
  "bashls", "dockerls", "sqlls",
}

-- Boucle pour configurer et activer tous les serveurs standards
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
  vim.lsp.enable(lsp)
end

-- 2. Configuration spécifique pour LaTeX (Compilation LuaLaTeX)
vim.lsp.config("texlab", {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
        forwardSearchAfter = false,
      },
    },
  },
})
vim.lsp.enable("texlab")
