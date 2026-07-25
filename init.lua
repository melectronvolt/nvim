-- ─────────────────────────────────────────────
-- Presse-papiers local / SSH / sudo
-- ─────────────────────────────────────────────

local is_ssh =
  vim.env.SSH_CONNECTION ~= nil
  or vim.env.SSH_CLIENT ~= nil
  or vim.env.SSH_TTY ~= nil

local has_gui =
  vim.env.WAYLAND_DISPLAY ~= nil
  or vim.env.DISPLAY ~= nil

local term = vim.env.TERM or ""
local term_program = (vim.env.TERM_PROGRAM or ""):lower()

local is_ghostty =
  term == "xterm-ghostty"
  or term_program == "ghostty"

-- En SSH : OSC 52.
-- Après sudo/su : les variables SSH peuvent disparaître,
-- mais TERM=xterm-ghostty reste généralement présent.
local use_osc52 =
  is_ssh
  or (is_ghostty and not has_gui)

if use_osc52 then
  vim.g.clipboard = "osc52"
  vim.opt.clipboard = "unnamedplus"
elseif has_gui then
  -- Session graphique locale : wl-copy / xclip / équivalent.
  vim.opt.clipboard = "unnamedplus"
else
  -- Console locale sans environnement graphique.
  vim.opt.clipboard = ""
end

vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
