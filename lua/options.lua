vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Même config en local et en SSH :
-- - local Wayland/X11 : Neovim utilise le provider système, par exemple wl-copy/wl-paste.
-- - SSH : Neovim utilise OSC52 pour copier depuis la machine distante vers le presse-papier local.
local is_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil

if is_ssh then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")

  if ok then
    vim.g.clipboard = {
      name = "OSC52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      paste = {
        ["+"] = osc52.paste("+"),
        ["*"] = osc52.paste("*"),
      },
    }

    vim.opt.clipboard = "unnamedplus"
  else
    -- Fallback prudent si le provider OSC52 n'existe pas.
    vim.opt.clipboard = ""
  end
else
  -- Local : laisse Neovim utiliser wl-copy/wl-paste, xclip, xsel, etc.
  vim.opt.clipboard = "unnamedplus"
end
