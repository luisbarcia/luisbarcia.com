# zk Tutor
===============

Tutorial interativo do Zettelkasten com zk + Neovim.
Começa do zero. Ao final, você terá:
  - Um notebook Zettelkasten configurado
  - zk + Neovim integrados via LSP
  - Um rascunho de post pronto em content/posts/

O tema do post que vamos construir:
  "Verificar antes de confiar"
  — checksums, assinaturas digitais, e por que "confia em mim" não é argumento.

Cada lição constrói uma peça. Nenhum exercício é descartável.
Tudo que você criar aqui vira material real.



==========================================================================
  PARTE 1: SETUP
==========================================================================


==========================================================================
  Lição 1.1: INSTALAR O ZK
==========================================================================

zk é um CLI para gerenciar notas em plain text (Zettelkasten).
Indexa arquivos .md, resolve [[links]], e expõe um LSP server.

  EXERCÍCIO (no terminal):
  1. Instale:
     brew install zk

  2. Verifique:
     zk --version

Se já está instalado, siga em frente.



==========================================================================
  Lição 1.2: CRIAR O DIRETÓRIO DE NOTAS
==========================================================================

O notebook fica em notes/ na raiz do projeto.
Três subdiretórios, um por tipo de nota:

  notes/
  ├── fleeting/       ideias rápidas, capturas brutas
  ├── literature/     anotações de fontes (artigos, livros, vídeos)
  └── permanent/      ideias próprias, argumentos, teses

  EXERCÍCIO (no terminal, na raiz do projeto):
  1. Crie a estrutura:
     mkdir -p notes/fleeting notes/literature notes/permanent

  2. Adicione .gitkeep para o git trackear pastas vazias:
     touch notes/fleeting/.gitkeep
     touch notes/literature/.gitkeep
     touch notes/permanent/.gitkeep



==========================================================================
  Lição 1.3: INICIALIZAR O NOTEBOOK
==========================================================================

O zk precisa de um diretório .zk/ com configuração e templates.

  EXERCÍCIO (no terminal):
  1. Entre na pasta:
     cd notes

  2. Inicialize:
     zk init

  3. Veja o que foi criado:
     ls -la .zk/
     ls .zk/templates/

  4. Adicione ao .gitignore do projeto:
     echo "notes/.zk/notebook.db" >> ../.gitignore



==========================================================================
  Lição 1.4: CONFIGURAR O ZK
==========================================================================

Abra .zk/config.toml e substitua todo o conteúdo por:

  EXERCÍCIO:
  1. nvim .zk/config.toml
  2. Cole a configuração abaixo:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

[note]
language = "pt"
filename = "{{format-date now '%Y%m%d%H%M%S'}}-{{slug title}}"
extension = "md"
template = "default.md"

[extra]

[group."fleeting"]
paths = ["fleeting"]
[group."fleeting".note]
template = "fleeting.md"

[group."literature"]
paths = ["literature"]
[group."literature".note]
template = "literature.md"

[group."permanent"]
paths = ["permanent"]
[group."permanent".note]
template = "permanent.md"

[format.markdown]
link-format = "wiki"
hashtags = true
colon-tags = false
multiword-tags = false

[tool]
editor = "nvim"
fzf-preview = "bat -p --color always {-1}"

[lsp]
[lsp.diagnostics]
dead-link = "error"
wiki-title = "hint"

[lsp.completion]
note-label = "{{title-or-path}}"
note-filter-text = "{{title}} {{path}}"
note-detail = "{{filename-stem}}"

[filter]
recents = "--sort created- --created-after 'last two weeks'"

[alias]
ls = "zk list $argv"
f = "zk new fleeting --title \"$argv\""
l = "zk new literature --title \"$argv\""
p = "zk new permanent --title \"$argv\""
recent = "zk edit --sort created- --created-after 'last two weeks' --interactive"

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  3. Salve e saia:  :wq

O que cada seção faz:
  [note]      filename com timestamp + slug, idioma pt
  [group.*]   cada diretório usa seu template
  [format]    links [[wiki]], hashtags ativadas
  [tool]      editor nvim, preview com bat
  [lsp]       dead links = erro, autocomplete configurado
  [alias]     atalhos: zk f, zk l, zk p



==========================================================================
  Lição 1.5: CRIAR OS TEMPLATES
==========================================================================

Templates definem o conteúdo inicial de cada tipo de nota.
Ficam em .zk/templates/ e usam sintaxe Handlebars.

  EXERCÍCIO:
  Crie cada arquivo com o conteúdo indicado.

  1. .zk/templates/default.md

     ---
     title: "{{title}}"
     date: {{format-date now}}
     tags: []
     ---

     {{content}}

  2. .zk/templates/fleeting.md — mesmo conteúdo do default.

  3. .zk/templates/literature.md

     ---
     title: "{{title}}"
     date: {{format-date now}}
     source:
     author:
     tags: []
     ---

     ## Pontos-chave

     -

     ## Citações

     >

     ## Notas

     {{content}}

  4. .zk/templates/permanent.md

     ---
     title: "{{title}}"
     date: {{format-date now}}
     tags: []
     links: []
     ---

     {{content}}

O campo title: é obrigatório — sem ele o zk não indexa títulos.



==========================================================================
  Lição 1.6: TESTAR A INSTALAÇÃO
==========================================================================

  EXERCÍCIO (no terminal, dentro de notes/):
  1. Crie uma nota de teste:
     zk new fleeting --title "teste de instalação"

  2. O nvim abre. Verifique:
     - Filename: YYYYMMDDHHMMSS-teste-de-instalacao.md
     - Frontmatter com title, date, tags preenchidos
     - Arquivo em fleeting/

  3. Salve e feche:  :wq

  4. Verifique o índice:
     zk list --format "{{title}} — {{path}}"

  5. Delete a nota de teste:
     rm fleeting/*teste-de-instalacao*

Setup concluído. Siga para a Parte 2.



==========================================================================
  PARTE 2: NEOVIM
==========================================================================


==========================================================================
  Lição 2.1: PLUGIN ZK-NVIM
==========================================================================

O zk-nvim conecta o Neovim ao LSP do zk. Quando você abre um .md
dentro de notes/, o LSP ativa automaticamente: autocomplete de [[links]],
go-to-definition, backlinks, hover, diagnósticos.

Pré-requisito: lazy.nvim instalado.
NÃO instale o zk via Mason — o CLI já inclui o LSP.

  EXERCÍCIO:
  1. Adicione ao init.lua (~/.config/nvim/init.lua), dentro do
     require("lazy").setup({ ... }):

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      picker = "telescope",
      lsp = {
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
        },
        auto_attach = {
          enabled = true,
        },
      },
    })

    local zk = require("zk")
    local commands = require("zk.commands")
    local keymap = vim.keymap.set

    -- Navegar
    keymap("n", "<leader>zn", "<cmd>ZkNotes { sort = { 'modified' } }<cr>")
    keymap("n", "<leader>zs", function()
      vim.ui.input({ prompt = "Search: " }, function(q)
        if q then commands.get("ZkNotes")({ match = { q } }) end
      end)
    end)
    keymap("n", "<leader>zt", "<cmd>ZkTags<cr>")
    keymap("n", "<leader>zb", "<cmd>ZkBacklinks<cr>")
    keymap("n", "<leader>zl", "<cmd>ZkLinks<cr>")
    keymap("n", "<leader>zo", "<cmd>ZkNotes { orphan = true }<cr>")
    keymap("n", "<leader>zx", "<cmd>ZkIndex<cr>")

    -- Criar
    keymap("n", "<leader>zf", function()
      vim.ui.input({ prompt = "Fleeting: " }, function(t)
        if t then zk.new({ dir = "fleeting", title = t }) end
      end)
    end)
    keymap("n", "<leader>zr", function()
      vim.ui.input({ prompt = "Literature: " }, function(t)
        if t then zk.new({ dir = "literature", title = t }) end
      end)
    end)
    keymap("n", "<leader>zp", function()
      vim.ui.input({ prompt = "Permanent: " }, function(t)
        if t then zk.new({ dir = "permanent", title = t }) end
      end)
    end)

    -- Links
    keymap("n", "<leader>zi", "<cmd>ZkInsertLink<cr>")
    keymap("v", "<leader>zi", ":'<,'>ZkInsertLinkAtSelection<cr>")
    keymap("v", "<leader>zn", ":'<,'>ZkNewFromTitleSelection<cr>")
  end,
}

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  2. Adicione FORA dos plugins (para gd e K funcionarem):

     vim.api.nvim_create_autocmd("LspAttach", {
       callback = function(args)
         local opts = { buffer = args.buf }
         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
       end,
     })

  3. Abra o Neovim e sincronize:  :Lazy sync
  4. Feche e reabra.



==========================================================================
  Lição 2.2: VERIFICAR O LSP
==========================================================================

  EXERCÍCIO:
  1. Abra este arquivo de dentro de notes/:
     cd notes && nvim TUTOR.md

  2. Digite  :LspInfo  e pressione Enter
  3. "zk" deve aparecer na lista de clientes
  4. Pressione  q  para fechar

Se não aparecer, você não está dentro de notes/.



==========================================================================
  PARTE 3: CAPTURA — A IDEIA INICIAL
==========================================================================

A partir daqui, vamos construir um post real.
Tema: "Verificar antes de confiar"

Cada exercício cria uma peça. No final, tudo vira um rascunho
de post em content/posts/.


==========================================================================
  Lição 3.1: PRIMEIRA FLEETING NOTE
==========================================================================

Toda escrita começa com uma ideia bruta. Sem filtro, sem estrutura.
Só a faísca.

  EXERCÍCIO:
  1. Pressione  Space z f
  2. Título: "Verificar antes de confiar"
  3. O Neovim abre a nota. Pressione  i  (insert mode)
  4. Escreva o texto abaixo (ou algo nas suas palavras):

     Todo software que você baixa pode ter sido adulterado.
     Todo binário pode conter código que você não autorizou.
     A diferença entre confiar e verificar é a diferença entre
     fé e matemática. Checksums, assinaturas PGP, hashes —
     são ferramentas de quem não aceita "confia em mim" como
     argumento técnico.

  5. Pressione  Esc  para voltar ao modo normal
  6. Salve:  :w

Parabéns. Sua primeira captura. Bruta, incompleta, imperfeita.
Exatamente como deve ser.



==========================================================================
  Lição 3.2: NAVEGAR NOTAS
==========================================================================

Agora que existe uma nota no notebook, vamos aprender a encontrá-la.

  EXERCÍCIO:
  1. Volte a este arquivo:  Space f b  → TUTOR.md

  2. Liste todas as notas:
     Pressione  Space z n
     Sua fleeting note deve aparecer na lista.
     Pressione  Esc  para fechar.

  3. Busque por conteúdo:
     Pressione  Space z s
     Digite "checksum" → Enter
     A nota deve aparecer.
     Pressione  Esc  → volte aqui com  Space f b

  4. Busque por tag:
     Pressione  Space z t
     Nenhuma tag ainda — a nota está com tags: [].
     Pressione  Esc



==========================================================================
  PARTE 4: PESQUISA — ESTUDAR AS FONTES
==========================================================================

A fleeting note é o ponto de partida. Agora vamos pesquisar fontes
e anotar o que aprendemos. Cada fonte vira uma literature note.


==========================================================================
  Lição 4.1: PRIMEIRA LITERATURE NOTE
==========================================================================

Fonte 1: como verificar checksums SHA-256.

  EXERCÍCIO:
  1. Pressione  Space z r
  2. Título: "How to verify checksums"
  3. O Neovim abre a nota com o template literature.
  4. Preencha o frontmatter (pressione  i  para editar):

     source: https://wiki.archlinux.org/title/Checksum
     author: Arch Wiki
     tags: [verification, opsec]

  5. Em "Pontos-chave", escreva:

     - Checksum é um hash do arquivo: se um bit muda, o hash muda
     - SHA-256 é o padrão atual; MD5 é obsoleto e inseguro
     - Verificar checksum confirma integridade, não autenticidade
     - Para autenticidade, precisa de assinatura (GPG/PGP)

  6. Em "Citações", escreva:

     > A checksum does not guarantee that the file has not been
     > tampered with, it merely guarantees that it matches the
     > original file.

  7. Salve:  :w



==========================================================================
  Lição 4.2: SEGUNDA LITERATURE NOTE
==========================================================================

Fonte 2: assinaturas digitais e por que importam.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md
  2. Pressione  Space z r
  3. Título: "GPG signatures explained"
  4. Preencha o frontmatter:

     source: https://www.gnupg.org/gph/en/manual/x135.html
     author: GnuPG Project
     tags: [verification, cryptography]

  5. Em "Pontos-chave":

     - Assinatura digital prova autoria e integridade
     - Usa criptografia assimétrica: chave privada assina, pública verifica
     - Diferente de checksum: checksum prova que não mudou,
       assinatura prova QUEM criou
     - Modelo de confiança: web of trust vs. CAs centralizadas

  6. Em "Citações":

     > A digital signature certifies and timestamps a document.
     > If the document is subsequently modified in any way,
     > a verification of the signature will fail.

  7. Salve:  :w



==========================================================================
  Lição 4.3: TERCEIRA LITERATURE NOTE
==========================================================================

Fonte 3: o conceito "Don't trust, verify" na cultura cypherpunk.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md
  2. Pressione  Space z r
  3. Título: "Don't trust, verify — origin and meaning"
  4. Preencha o frontmatter:

     source: https://nakamotoinstitute.org/library/
     author: Nakamoto Institute
     tags: [verification, sovereignty]

  5. Em "Pontos-chave":

     - "Don't trust, verify" vem da cultura Bitcoin/cypherpunk
     - Aplica-se além de crypto: software, comunicação, identidade
     - Verificação é o oposto de autoridade: não precisa confiar
       em ninguém se pode checar por conta própria
     - Exige ferramentas: hashes, assinaturas, código aberto

  6. Em "Notas" (última seção):

     Esse princípio é a base de tudo que faço.
     Conecta com open source (código auditável) e self-hosting
     (infraestrutura verificável).

  7. Salve:  :w



==========================================================================
  Lição 4.4: INSERIR LINKS NA FLEETING NOTE
==========================================================================

Agora vamos conectar a ideia original com as fontes que estudamos.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Abra a fleeting note:
     Space z n  → digite "Verificar antes" → Enter

  3. Vá para o final do texto. Pressione  G  (vai para a última linha)
  4. Pressione  o  (abre linha abaixo e entra em insert mode)
  5. Escreva:

     Fontes:

  6. Pressione  Esc , depois  o  de novo
  7. Agora insira um link:  Space z i
  8. No Telescope, selecione "How to verify checksums"
     → um [[link]] é inserido automaticamente

  9. Pressione  o  e insira outro link:  Space z i
     → selecione "GPG signatures explained"

  10. Pressione  o  e insira o último:  Space z i
      → selecione "Don't trust, verify"

  11. Salve:  :w

A fleeting note agora referencia as 3 fontes.
O bloco final deve parecer algo como:

  Fontes:
  [[how-to-verify-checksums]]
  [[gpg-signatures-explained]]
  [[dont-trust-verify-origin-and-meaning]]



==========================================================================
  Lição 4.5: VERIFICAR LINKS E BACKLINKS
==========================================================================

  EXERCÍCIO:
  1. Com a fleeting note aberta, pressione  Space z l
     → as 3 literature notes devem aparecer (links que saem)

  2. Agora abra uma literature note:
     Space z n  → "How to verify checksums" → Enter

  3. Pressione  Space z b
     → a fleeting note "Verificar antes de confiar" deve aparecer
     (backlink: alguém referencia esta nota)

  4. Teste o hover preview:
     Volte à fleeting note:  Ctrl+o
     Coloque o cursor sobre um [[link]]
     Pressione  K
     → preview flutuante do conteúdo da nota

  5. Teste go-to-definition:
     Cursor sobre o [[link]]
     Pressione  gd
     → a nota abre
     Volte com  Ctrl+o

  6. Volte aqui:  Space f b  → TUTOR.md



==========================================================================
  Lição 4.6: ADICIONAR TAGS À FLEETING NOTE
==========================================================================

  EXERCÍCIO:
  1. Abra a fleeting note:
     Space z n  → "Verificar antes" → Enter

  2. No frontmatter, edite a linha de tags:
     tags: [verification, sovereignty, opsec]

  3. Salve:  :w

  4. Volte aqui:  Space f b  → TUTOR.md

  5. Teste a busca por tag:
     Space z t  → selecione "verification"
     → todas as notas deste tutorial devem aparecer



==========================================================================
  PARTE 5: SÍNTESE — SUA TESE
==========================================================================

Você capturou a ideia (fleeting) e estudou as fontes (literature).
Agora é hora de formular o argumento na sua voz.
A permanent note é atômica: uma ideia, escrita sem depender de contexto.


==========================================================================
  Lição 5.1: CRIAR A PERMANENT NOTE
==========================================================================

  EXERCÍCIO:
  1. Pressione  Space z p
  2. Título: "Verificação é soberania técnica"
  3. Preencha o frontmatter:

     tags: [verification, sovereignty]
     links: []

  4. Escreva o corpo (pressione  i ). Use suas palavras.
     Sugestão:

     Verificar é o ato mais básico de soberania técnica.

     Quando você baixa um binário e não confere o checksum, está
     confiando que ninguém adulterou o arquivo entre o servidor e
     a sua máquina. Quando você instala um pacote sem verificar a
     assinatura GPG, está confiando que o repositório não foi
     comprometido. Confiança sem verificação é fé — e fé não é
     metodologia de engenharia.

     Checksums provam integridade: o arquivo não mudou.
     Assinaturas provam autenticidade: quem assinou é quem diz ser.
     Código aberto prova auditabilidade: você pode ler o que vai rodar.

     As três camadas juntas eliminam a necessidade de confiar em
     qualquer intermediário. Isso não é paranoia. É engenharia.

  5. Agora insira links para as fontes no final:
     Pressione  Esc , depois  G  (última linha), depois  o
     Escreva:

     Fundamentação:

  6. Insira links:  Space z i  (3 vezes, um por linha)
     → selecione cada literature note

  7. Salve:  :w



==========================================================================
  Lição 5.2: VERIFICAR O GRAFO
==========================================================================

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Verifique os backlinks de uma literature note:
     Space z n  → "GPG signatures" → Enter
     Space z b
     → devem aparecer: a fleeting note E a permanent note
     (duas notas referenciam essa fonte)

  3. Verifique os links da permanent note:
     Space z n  → "Verificação é soberania" → Enter
     Space z l
     → as 3 literature notes devem aparecer

  4. Procure notas órfãs:
     Space z o
     → idealmente nenhuma nota do tutorial está órfã

  5. Reindexe para garantir:
     Space z x

  6. Volte aqui:  Space f b  → TUTOR.md



==========================================================================
  PARTE 6: ESCRITA — O POST
==========================================================================

Você tem: 1 fleeting note (ideia), 3 literature notes (fontes),
1 permanent note (tese). O material está pronto. Hora de escrever.


==========================================================================
  Lição 6.1: CRIAR O RASCUNHO DO POST
==========================================================================

Posts ficam em content/posts/. Vamos criar o rascunho.

  EXERCÍCIO (no terminal):
  1. Saia do Neovim:  :qa
  2. Volte à raiz do projeto:
     cd ..
  3. Crie o post:
     hugo new posts/verificar-antes-de-confiar/index.md
  4. Abra o post:
     nvim content/posts/verificar-antes-de-confiar/index.md



==========================================================================
  Lição 6.2: ESCREVER O POST
==========================================================================

O post é a destilação de tudo que você construiu no Zettelkasten.
A permanent note é o esqueleto. As literature notes são as fontes.

  EXERCÍCIO:
  1. Edite o frontmatter:

     ---
     title: "Verificar antes de confiar"
     date: 2026-03-06
     draft: true
     description: "Checksums, assinaturas e por que 'confia em mim' não é argumento técnico."
     tags: ["verificação", "soberania", "opsec"]
     ---

  2. Escreva o post. Use a permanent note como base e expanda.
     Sugestão de estrutura:

     Parágrafo de abertura — o problema.
     "Todo software que você baixa pode ter sido adulterado."

     ## Checksum: o arquivo não mudou
     Baseie-se na literature note "How to verify checksums".
     Explique SHA-256, mostre um exemplo prático.

     ## Assinatura: quem criou é quem diz ser
     Baseie-se em "GPG signatures explained".
     Explique a diferença entre integridade e autenticidade.

     ## Don't trust, verify
     Baseie-se em "Don't trust, verify — origin and meaning".
     Conecte com a filosofia do site.

     Parágrafo de fechamento — a tese.
     "Verificar é o ato mais básico de soberania técnica."

  3. Salve:  :w

O post está em draft: true. Quando estiver pronto para publicar,
mude para draft: false e defina a data.



==========================================================================
  Lição 6.3: RESULTADO FINAL
==========================================================================

Abra outro terminal e verifique o que foi construído:

  EXERCÍCIO:
  1. Veja as notas:
     cd notes && zk list --format "{{title}} — {{path}}"

  2. Veja o grafo de links:
     zk graph --format json | head -50

  3. Veja o post:
     cat ../content/posts/verificar-antes-de-confiar/index.md

  4. Rode o Hugo:
     cd .. && hugo server -D

  5. Abra no browser: http://localhost:1313
     O post deve aparecer (é draft, mas -D mostra drafts).

Você completou o ciclo:
  ideia → fontes → tese → post

  fleeting/   1 nota   "Verificar antes de confiar"
  literature/ 3 notas  checksums, GPG, don't trust verify
  permanent/  1 nota   "Verificação é soberania técnica"
  post        1 draft  content/posts/verificar-antes-de-confiar/



==========================================================================
  REFERÊNCIA RÁPIDA
==========================================================================

  NEOVIM

  Space z n  ···  listar notas          Space z f  ···  nova fleeting
  Space z s  ···  buscar conteúdo       Space z r  ···  nova literature
  Space z t  ···  navegar tags          Space z p  ···  nova permanent
  Space z b  ···  backlinks             Space z i  ···  inserir link
  Space z l  ···  links                 Space z x  ···  reindexar
  Space z o  ···  notas órfãs

  gd  ··········  abrir nota do link    Ctrl+o  ····  voltar
  K   ··········  preview flutuante     Space f b ··  listar buffers
  [[  ··········  autocomplete links    :w  ········  salvar

  TERMINAL

  zk f "título"   nova fleeting         zk list           listar todas
  zk l "título"   nova literature       zk list --tag X   filtrar por tag
  zk p "título"   nova permanent        zk edit -i        busca interativa

  WORKFLOW

  Captura (fleeting) → Pesquisa (literature) → Síntese (permanent) → Post

==========================================================================

Fim do tutorial. As notas e o post que você criou são reais.
Revise, expanda, publique quando estiver pronto.
