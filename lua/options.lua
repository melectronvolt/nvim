vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitright = true
vim.opt.splitbelow = true

local is_ssh = vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil
local has_gui_clipboard = vim.env.WAYLAND_DISPLAY ~= nil or vim.env.DISPLAY ~= nil

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
    vim.opt.clipboard = ""
  end
elseif has_gui_clipboard then
  vim.opt.clipboard = "unnamedplus"
else
  -- Serveur en TTY local, sans X/Wayland : pas de provider clipboard.
  vim.opt.clipboard = ""
end
