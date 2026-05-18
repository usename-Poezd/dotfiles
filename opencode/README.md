# OpenCode configs

Three isolated OpenCode presets are tracked here:

- `config/opencode/` -> `~/.config/opencode/` — default OpenCode + caveman
- `config-omo/` -> `~/.config-omo/` — full Oh My OpenAgent
- `config-omos/` -> `~/.config-omos/` — oh-my-opencode-slim

`auth.json` is intentionally not tracked. Use one shared auth file and symlink it into all presets:

```bash
mkdir -p ~/.config/opencode-auth
# Put/create auth.json here manually. Do not commit it.

ln -sf ~/.config/opencode-auth/auth.json ~/.config/opencode/auth.json
ln -sf ~/.config/opencode-auth/auth.json ~/.config-omo/opencode/auth.json
ln -sf ~/.config/opencode-auth/auth.json ~/.config-omos/opencode/auth.json
```

ITooLabs proxy `baseURL` values are intentionally omitted from tracked configs.
