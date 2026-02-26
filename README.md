# luisbarcia.com

Personal site — blog + portfolio. Built with [Hugo](https://gohugo.io/) and the [Soberano](https://github.com/luisbarcia/soberano) theme.

**Clearnet:** https://luisbarcia.com
**Tor:** http://luisbarh3et65nr7kwbft2r24i3dpq5be6goqkfaqutoui2sspqn5sid.onion

## Stack

- **Hugo** v0.156.0 (extended edition)
- **Theme:** Soberano — dark, monospace, privacy-first
- **CSS:** Pure CSS (zero dependencies)
- **Deploy:** nginx self-hosted + Tor Hidden Service
- **CI/CD:** GitHub Actions (build on push, deploy on demand)

## Development

```bash
# Dev server
hugo server -D

# Production build
hugo --gc --minify

# Build with checksums + PGP signing
./scripts/build.sh --sign

# Deploy to VPS
./scripts/deploy.sh
```

## Scripts

| Script | What it does |
|--------|-------------|
| `scripts/build.sh` | Hugo build + SHA-256 checksums + optional PGP signing (`--sign`) |
| `scripts/deploy.sh` | rsync to VPS (`--dry-run` to preview) |
| `scripts/renew-canary.sh` | Quarterly warrant canary renewal with Bitcoin block proof |
| `scripts/setup-pgp.sh` | One-time PGP setup — exports public key + signed mirrors.txt |

## CI/CD

- **CI** (`ci.yml`): Runs on every push to `main` — builds and validates the site
- **Deploy** (`deploy.yml`): Manual trigger (`workflow_dispatch`) — builds and rsync to VPS

## Project Structure

```
luisbarcia.com/
├── hugo.toml              # Site configuration
├── default.conf           # nginx config (clearnet + Tor)
├── content/
│   ├── posts/             # Blog (page bundles)
│   ├── portfolio/         # Projects
│   ├── about.md           # About page
│   ├── canary.md          # PGP-signed warrant canary
│   ├── pgp.md             # Public key
│   ├── mirrors.md         # Alternative access points
│   ├── integrity.md       # SHA-256 content checksums
│   ├── support.md         # Crypto donations
│   ├── search.md          # Client-side search (Pagefind)
│   └── archive.md         # Posts by year
├── scripts/               # Build, deploy, canary renewal
├── themes/soberano/       # Theme (local copy)
└── .github/workflows/     # CI + deploy
```

## License

Content is copyright Luis Barcia. Theme ([Soberano](https://github.com/luisbarcia/soberano)) is MIT licensed.
