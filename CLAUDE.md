# CLAUDE.md

## Project Overview

Site pessoal **luisbarcia.com** — blog + portfolio. Hugo + tema [Soberano](https://github.com/luisbarcia/soberano). Dark-only, cypherpunk, privacy-first.

- **Hugo:** v0.152.0+ (standard edition)
- **Tema:** Soberano (Hugo Module, dev local em `../soberano/`)
- **CSS/JS:** Pure CSS + vanilla JS minimal (via tema, zero deps)
- **Deploy:** nginx self-hosted + Tor Hidden Service

## Project Structure

```
├── hugo.toml        # Config principal
├── content/         # Posts, portfolio, páginas (Markdown)
├── static/          # Imagens, favicons
├── default.conf     # nginx config (produção + Tor)
└── go.mod           # Hugo Module (importa tema Soberano)
```

## Commands

```bash
hugo server -D                          # Dev server (com drafts)
hugo --gc --minify                      # Build produção
hugo new posts/SLUG.md                  # Novo post
hugo new portfolio/SLUG.md              # Novo projeto
hugo list drafts                        # Listar rascunhos
hugo mod get -u                         # Atualizar tema
hugo --templateMetrics --templateMetricsHints  # Profiling
```

## Deployment

Config nginx em `default.conf`:
- Domínios: `luisbarcia.com`, `www.luisbarcia.com`, `.onion`
- Security headers: CSP, X-Frame-Options, Referrer-Policy, Permissions-Policy
- Cache: CSS/JS/fonts 7d, imagens 30d (immutable)
- Onion-Location, Pagefind WASM, gzip

## Tema Soberano — Quick Reference

- **Posts** (`content/posts/`): tags, TOC opt-in, reading time
- **Portfolio** (`content/portfolio/`): stack, links, status
- **Páginas especiais**: canary, pgp, mirrors, integrity, support, search (via `layout:` no front matter)
- **Shortcodes**: `axiom`, `manifesto`, `card`, `callout`
- **Privacy presets** em `[params.privacy]`: `standard`, `hardened`, `paranoid` (21 flags granulares)
- **Sovereignty** em `[params.sovereignty]`, `[params.nostr]`, `[params.crypto]`
- **Extension hooks** (sem modificar o tema):
  - `partials/head/custom.html` — extra no `<head>`
  - `partials/hooks/body-start.html` — após `<body>`
  - `partials/hooks/body-end.html` — antes `</body>`

## CI/CD

- Após cada push, verificar o status do CI: `source .envrc && gh run list --limit 1`
- Se falhar, investigar com `gh run view <id> --log-failed`
- **Sempre acompanhar o CI após push** — não considerar o trabalho concluído até o CI passar
- **Deploy é manual e decisão do usuário** — nunca disparar `gh workflow run deploy.yml` sem pedido explícito

## Git

- **Identity**: `luisbarcia <barcia.me@proton.me>` (GitHub: `luisbarcia`)
- Para `gh` commands: carregar token via `source .envrc &&` (ver `CLAUDE.local.md`)

## Gotchas

- Soberano é um Hugo Module — nunca copiar arquivos do tema para este repo
- Dev local com tema: `hugo.toml` já tem `replacements = "... -> ../soberano"`
- Pagefind WASM requer config específica no nginx (ver `default.conf`)
