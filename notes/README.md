# Zettelkasten

Sistema de notas para alimentar os posts do blog.

## Estrutura

```
notes/
├── fleeting/       Capturas rápidas — ideias, insights, provocações
├── literature/     Anotações de fontes — livros, artigos, vídeos, podcasts
└── permanent/      Notas próprias — argumentos, conexões, teses
```

## Tipos de nota

### Fleeting (`fleeting/`)
Ideia bruta. Captura rápida sem filtro. Uma frase, um parágrafo, um link.
Descartável — ou vira literature/permanent note, ou morre.

### Literature (`literature/`)
O que você extraiu de uma fonte específica, nas suas palavras.
Sempre referencia a fonte original. Uma nota por fonte.

### Permanent (`permanent/`)
Ideia sua, escrita pra ser entendida sem contexto.
Conecta com outras notas via `[[links]]`. Atomic — uma ideia por nota.

## Convenções

- Arquivo: `YYYY-MM-DD-slug.md` (ex: `2026-03-05-confianca-sem-terceiros.md`)
- Front matter mínimo no topo de cada nota
- Links entre notas: `[[slug]]` (sem data, sem path)
- Tags inline: `#privacy`, `#sovereignty`, `#self-hosting`

## Workflow

```
Captura (fleeting) → Processa (literature) → Conecta (permanent) → Escreve (content/posts/)
```

1. Leu/ouviu/pensou algo? → `fleeting/`
2. Está estudando uma fonte? → `literature/`
3. Formou uma opinião/argumento próprio? → `permanent/`
4. Juntou permanent notes suficientes sobre um tema? → Outline → Draft → Post

## No Neovim

- `:grep` ou telescope pra buscar entre notas
- `gf` em cima de `[[link]]` pra navegar
- Sem plugins obrigatórios — plain text funciona
