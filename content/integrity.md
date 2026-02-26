---
title: "Manifesto de Integridade"
layout: integrity
description: "Checksums SHA-256 para todo o conteudo publicado."
---

Checksums SHA-256 para todo o conteudo publicado. Hashes sao computados a partir do Markdown fonte (`RawContent`) no momento do build. Paginas com hashes fornecidos manualmente sao marcadas como **assinadas**.

Para verificar um hash, clone o repositorio e execute:

```bash
# Remover front matter e computar hash
awk '/^---$/{n++; next} n>=2' content/posts/seu-post.md | sha256sum
```
