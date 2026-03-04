# Content Infrastructure Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Configurar a infraestrutura Hugo para suportar o roadmap de conteudo: bilingual (pt-BR + en), duas categorias (pessoal/profissional), archetypes, e RSS por categoria.

**Architecture:** Hugo multilingual mode com translation by filename (`index.md` / `index.en.md`). Taxonomia `categories` adicionada ao lado de `tags`. Archetypes customizados para cada trilha. RSS configurado por secao e categoria.

**Tech Stack:** Hugo v0.152.0+, tema Soberano (Hugo Module), i18n YAML

---

### Task 1: Configurar Hugo multilingual (pt-BR + en)

**Files:**
- Modify: `hugo.toml`

**Step 1: Adicionar configuracao de idiomas ao hugo.toml**

Substituir a linha `languageCode = "pt-BR"` e adicionar bloco `[languages]`. O pt-BR eh o idioma padrao.

```toml
# Remover esta linha:
# languageCode = "pt-BR"

# Adicionar antes de [pagination]:
[languages]
  [languages.pt-br]
    languageCode = "pt-BR"
    languageName = "Portugues"
    weight = 1
    title = "Luis Barcia"
  [languages.en]
    languageCode = "en"
    languageName = "English"
    weight = 2
    title = "Luis Barcia"
```

**Step 2: Verificar que o build funciona**

Run: `hugo --gc --minify 2>&1 | head -20`
Expected: Build sem erros, duas linguas listadas

**Step 3: Commit**

```bash
git add hugo.toml
git commit -m "feat: configure Hugo multilingual (pt-BR + en)"
```

---

### Task 2: Mover menus para dentro dos blocos de idioma

**Files:**
- Modify: `hugo.toml`

**Step 1: Mover menus para dentro de cada idioma**

Os menus precisam ser definidos por idioma para suportar labels traduzidos.

```toml
# Dentro de [languages.pt-br]:
  [[languages.pt-br.menus.main]]
    name = "Posts"
    url = "/posts/"
    weight = 1
  [[languages.pt-br.menus.main]]
    name = "Portfolio"
    url = "/portfolio/"
    weight = 2
  [[languages.pt-br.menus.main]]
    name = "Sobre"
    url = "/about/"
    weight = 3
  [[languages.pt-br.menus.main]]
    name = "Busca"
    url = "/search/"
    weight = 4
  [[languages.pt-br.menus.footer]]
    name = "Busca"
    url = "/search/"
    weight = 1
  [[languages.pt-br.menus.footer]]
    name = "RSS"
    url = "/index.xml"
    weight = 2
  [[languages.pt-br.menus.footer]]
    name = "Source"
    url = "https://github.com/luisbarcia/luisbarcia.com"
    weight = 3
    [languages.pt-br.menus.footer.params]
      external = true

# Dentro de [languages.en]:
  [[languages.en.menus.main]]
    name = "Posts"
    url = "/posts/"
    weight = 1
  [[languages.en.menus.main]]
    name = "Portfolio"
    url = "/portfolio/"
    weight = 2
  [[languages.en.menus.main]]
    name = "About"
    url = "/about/"
    weight = 3
  [[languages.en.menus.main]]
    name = "Search"
    url = "/search/"
    weight = 4
  [[languages.en.menus.footer]]
    name = "Search"
    url = "/search/"
    weight = 1
  [[languages.en.menus.footer]]
    name = "RSS"
    url = "/index.xml"
    weight = 2
  [[languages.en.menus.footer]]
    name = "Source"
    url = "https://github.com/luisbarcia/luisbarcia.com"
    weight = 3
    [languages.en.menus.footer.params]
      external = true
```

Remover os menus globais (`[[menus.main]]` e `[[menus.footer]]`).

**Step 2: Verificar build**

Run: `hugo --gc --minify 2>&1 | head -20`
Expected: Build sem erros

**Step 3: Commit**

```bash
git add hugo.toml
git commit -m "feat: move menus to per-language config for i18n"
```

---

### Task 3: Adicionar taxonomia categories

**Files:**
- Modify: `hugo.toml`

**Step 1: Adicionar category ao bloco [taxonomies]**

```toml
[taxonomies]
  tag = "tags"
  category = "categories"
```

**Step 2: Verificar build**

Run: `hugo --gc --minify 2>&1 | head -20`
Expected: Build sem erros

**Step 3: Commit**

```bash
git add hugo.toml
git commit -m "feat: add categories taxonomy for content tracks"
```

---

### Task 4: Criar archetype para posts

**Files:**
- Create: `archetypes/posts.md`

**Step 1: Criar archetype**

```markdown
---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: []
categories: []
description: ""
toc: false
---
```

O campo `categories` aceita: `pessoal`, `profissional` (ou ambos).
O campo `tags` usa as tags dos 19 temas (privacy, cryptography, bitcoin, etc.).

**Step 2: Testar archetype**

Run: `hugo new posts/test-archetype/index.md && cat content/posts/test-archetype/index.md`
Expected: Front matter com campos tags, categories, description

**Step 3: Limpar post de teste**

Run: `rm -rf content/posts/test-archetype`

**Step 4: Commit**

```bash
git add archetypes/posts.md
git commit -m "feat: add posts archetype with categories and tags"
```

---

### Task 5: Criar traducao en do conteudo existente (hello-world)

**Files:**
- Create: `content/posts/hello-world/index.en.md`

**Step 1: Criar versao em ingles do hello-world**

```markdown
---
title: "Hello World"
date: 2026-02-26
tags: ["meta"]
categories: ["profissional"]
description: "First post. Who I am, what I do, and why this site exists."
pinned: true
toc: false
---

This site is my personal and professional space. Here you'll find my portfolio, projects, and writing about automation, AI workflows, software engineering, and my thoughts on technology and digital autonomy.

## Who I am

Software engineer. I work with process automation, API system integration, and AI workflows. Currently leading the tech front for B2B products at [Uuba](https://uuba.com.br).

## Why this site?

Because I don't publish on other people's platforms. My content, my domain, my rules. No analytics, no tracking, no paywall.

{{< axiom label="Axiom" >}}
Don't trust. Verify.
{{< /axiom >}}

## What's coming

Posts about AI automation, API integration, Python, Node.js, and whatever else makes sense to share. No schedule, no obligation — when something useful comes up, I publish it.
```

**Step 2: Adicionar category ao post original pt-BR**

Editar `content/posts/hello-world/index.md` e adicionar `categories: ["profissional"]` ao front matter.

**Step 3: Verificar que ambos idiomas aparecem**

Run: `hugo --gc --minify 2>&1 | head -20`
Expected: Build sem erros, paginas em pt-br e en

**Step 4: Commit**

```bash
git add content/posts/hello-world/
git commit -m "feat: add English translation for hello-world post"
```

---

### Task 6: Criar traducoes en para paginas especiais

**Files:**
- Create: `content/about.en.md`
- Create: `content/_index.en.md`
- Create: `content/posts/_index.en.md`
- Create: `content/portfolio/_index.en.md`
- Create: `content/search.en.md`
- Create: `content/archive.en.md`

**Step 1: Criar _index.en.md (homepage)**

Ler `content/_index.md` e criar versao en com mesmo front matter traduzido.

**Step 2: Criar about.en.md**

Ler `content/about.md` e criar versao en.

**Step 3: Criar section indexes en**

Criar `content/posts/_index.en.md`, `content/portfolio/_index.en.md` com titles traduzidos.

**Step 4: Criar search.en.md e archive.en.md**

Versoes en das paginas de busca e arquivo.

**Step 5: Verificar build**

Run: `hugo --gc --minify 2>&1 | head -20`
Expected: Build sem erros

**Step 6: Commit**

```bash
git add content/about.en.md content/_index.en.md content/posts/_index.en.md content/portfolio/_index.en.md content/search.en.md content/archive.en.md
git commit -m "feat: add English translations for core pages"
```

---

### Task 7: Configurar RSS por categoria

**Files:**
- Modify: `hugo.toml`

**Step 1: Garantir output RSS em taxonomias**

```toml
[outputs]
  home = ["HTML", "RSS", "JSON"]
  section = ["HTML", "RSS"]
  taxonomy = ["HTML", "RSS"]
  term = ["HTML", "RSS"]
```

Isso gera RSS em `/categories/pessoal/index.xml` e `/categories/profissional/index.xml` automaticamente.

**Step 2: Verificar build**

Run: `hugo --gc --minify 2>&1 | head -20`
Expected: Build sem erros

**Step 3: Verificar que RSS por categoria existe**

Run: `hugo --gc --minify && ls public/categories/`
Expected: Diretorios para categorias quando houver posts com categorias

**Step 4: Commit**

```bash
git add hugo.toml
git commit -m "feat: enable RSS output for taxonomy and term pages"
```

---

### Task 8: Atualizar descricao da secao posts

**Files:**
- Modify: `content/posts/_index.md`

**Step 1: Atualizar descricao para refletir o novo escopo**

```markdown
---
title: "Posts"
description: "Sobre automacao, privacidade, soberania digital, lideranca, codigo aberto e o que mais fizer sentido — por um dev libertarianista paranoico."
---
```

**Step 2: Commit**

```bash
git add content/posts/_index.md
git commit -m "docs: update posts section description to match content roadmap"
```

---

### Task 9: Dev server smoke test

**Step 1: Rodar dev server e verificar**

Run: `hugo server -D`
Expected: Site roda sem erros, ambos idiomas acessiveis

**Step 2: Verificar URLs**

- `http://localhost:1313/` — homepage pt-BR
- `http://localhost:1313/en/` — homepage en
- `http://localhost:1313/posts/` — posts pt-BR
- `http://localhost:1313/en/posts/` — posts en
- `http://localhost:1313/posts/hello-world/` — post pt-BR
- `http://localhost:1313/en/posts/hello-world/` — post en

**Step 3: Verificar RSS**

- `http://localhost:1313/index.xml` — RSS global pt-BR
- `http://localhost:1313/en/index.xml` — RSS global en

---

## Resumo de Mudancas

| O que | Antes | Depois |
|-------|-------|--------|
| Idiomas | pt-BR only | pt-BR + en (multilingual) |
| Taxonomias | tags only | tags + categories |
| Categories | nao existia | pessoal, profissional |
| Menus | globais | per-language |
| Archetypes | tema default | customizado com categories/tags |
| RSS | home + section | home + section + taxonomy + term |
| Conteudo en | nao existia | hello-world + paginas core |
