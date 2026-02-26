# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Site pessoal **luisbarcia.com** — blog + portfolio usando o tema Hugo [Soberano](https://github.com/luisbarcia/soberano). Dark-only, cypherpunk-inspired, privacy-first.

**Stack:** Hugo (v0.152.0+, standard edition) + tema Soberano (Hugo Module)
**CSS:** Pure CSS (zero dependencies, via tema)
**JS:** Vanilla JS minimal (via tema)
**Deploy:** nginx self-hosted + Tor Hidden Service

## Project Structure

```
luisbarcia.com/
├── default.conf         # nginx config (produção + Tor)
├── hugo.toml            # Configuração Hugo do site
├── content/             # Conteúdo Markdown (posts, portfolio, páginas)
├── static/              # Assets estáticos (imagens, favicons)
├── go.mod               # Go Module (importa tema Soberano)
└── CLAUDE.md
```

O tema Soberano vive em `../soberano/` e é importado como Hugo Module:
```
github.com/luisbarcia/soberano
```

## Development Commands

```bash
# Servidor de desenvolvimento
hugo server -D

# Build produção
hugo --gc --minify

# Template profiling
hugo --templateMetrics --templateMetricsHints

# Atualizar módulo do tema
hugo mod get -u

# Criar novo post
hugo new posts/meu-post.md

# Criar novo projeto no portfolio
hugo new portfolio/meu-projeto.md

# Listar drafts/expired/future
hugo list drafts
```

Para desenvolvimento local com o tema Soberano em `../soberano/`, usar module replacement no `hugo.toml`:
```toml
[module]
  replacements = "github.com/luisbarcia/soberano -> ../soberano"
  [[module.imports]]
    path = "github.com/luisbarcia/soberano"
```

## Deployment

O site roda em nginx self-hosted com Tor Hidden Service.

**Nginx config:** `default.conf`
- Domínios: `luisbarcia.com`, `www.luisbarcia.com`, `.onion`
- Onion-Location header para auto-redirect no Tor Browser
- Security headers: CSP, X-Content-Type-Options, X-Frame-Options, Referrer-Policy, Permissions-Policy
- Cache: CSS/JS/fonts 7d, imagens 30d (immutable)
- Pagefind WASM support
- Gzip compression

## Tema Soberano — Referência Rápida

### Conteúdo
- **Posts** (`content/posts/`): Blog com tags, TOC opt-in, reading time
- **Portfolio** (`content/portfolio/`): Projetos com stack, links, status
- **Páginas especiais**: canary, pgp, mirrors, integrity, support, search (via `layout:` no front matter)

### Privacy System
Presets em `[params.privacy]`: `standard` (default), `hardened`, `paranoid`
21 flags granulares para override individual. Central resolver: `partials/helpers/resolve-privacy.html`.

### Sovereignty Features
Ativados via `[params.sovereignty]`, `[params.nostr]`, `[params.crypto]`:
warrant canary, onion-location, NIP-05 Nostr, PGP key page, content hashes, mirrors (Tor/I2P/IPFS).

### Shortcodes
`axiom`, `manifesto`, `card`, `callout`

### Extension Hooks (sem modificar o tema)
- `partials/head/custom.html` — conteúdo extra no `<head>`
- `partials/hooks/body-start.html` — após `<body>`
- `partials/hooks/body-end.html` — antes `</body>`

## Git

- **Conventional Commits**: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`
- **GitHub identity**: `luisbarcia` (NOT `luismattos`)
- **Git user**: `luisbarcia <barcia.me@proton.me>`
- **GH_TOKEN**: em `/Users/luismattos/Documents/Workspaces/luisbarcia/.envrc`
- Para `gh` commands: prefixar com `source /Users/luismattos/Documents/Workspaces/luisbarcia/.envrc &&`
