# Zettelkasten

Sistema de notas para alimentar os posts do blog. Gerenciado pelo [zk](https://github.com/zk-org/zk).

## Estrutura

```
notes/
├── .zk/            Configuração e templates do zk
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
Sempre referencia a fonte original (`source:` no front matter). Uma nota por fonte.
As outras notas referenciam fontes linkando pra literature notes via `[[link]]`.

### Permanent (`permanent/`)
Ideia sua, escrita pra ser entendida sem contexto.
Conecta com outras notas via `[[links]]`. Atomic — uma ideia por nota.

## Comandos

```bash
# Criar notas
zk new fleeting --title "ideia tal"
zk new literature --title "artigo tal"
zk new permanent --title "tese tal"

# Aliases
zk f "ideia tal"
zk l "artigo tal"
zk p "tese tal"

# Buscar e navegar
zk list                       # lista todas
zk list --tag privacy         # filtra por tag
zk edit --interactive         # busca com fzf
zk edit --match "self-hosting" # busca por texto
```

## Convenções

- Filename gerado automaticamente: `YYYYMMDDHHMMSS-slug.md`
- Links entre notas: `[[slug]]`
- Tags inline: `#privacy`, `#sovereignty`, `#self-hosting`

## Workflow

```
Captura (fleeting) → Processa (literature) → Conecta (permanent) → Escreve (content/posts/)
```

1. Leu/ouviu/pensou algo? → `zk f "ideia"`
2. Está estudando uma fonte? → `zk l "nome da fonte"`
3. Formou uma opinião/argumento próprio? → `zk p "tese"`
4. Juntou permanent notes suficientes sobre um tema? → Outline → Draft → Post

## Neovim

- LSP do zk: autocomplete de `[[links]]`, dead link warnings, navegação
- `zk edit --interactive` abre fzf no terminal
