# zk Tutor
===============

Tutorial interativo do Zettelkasten com zk + Neovim.
Baseado no método original de Niklas Luhmann — não em interpretações
populares.

Ao final, você terá:
  - Um notebook Zettelkasten fiel ao método original
  - zk + Neovim integrados via LSP
  - Um rascunho de texto pronto, montado a partir das notas

O tema do texto que vamos construir:
  "Verificar antes de confiar"
  — checksums, assinaturas digitais, e por que "confia em mim" não é
  argumento.

Cada lição constrói uma peça. Nenhum exercício é descartável.
Tudo que você criar aqui vira material real.

COMO USAR ESTE TUTORIAL:
  Abra este arquivo no Neovim:  nvim TUTOR.md
  Faça tudo de dentro do Neovim — nunca saia.

  Comandos de terminal usam  :!  (ex:  :!zk list )
  Abrir arquivos usa  :e  (ex:  :e .zk/config.toml )
  Voltar aqui usa  Space f b  → TUTOR.md  (ou  :b TUTOR )



==========================================================================
  PARTE 1: O QUE É ZETTELKASTEN DE VERDADE
==========================================================================

Antes de configurar qualquer ferramenta, você precisa entender o que
está construindo — e o que NÃO está.


==========================================================================
  Lição 1.1: A HISTÓRIA
==========================================================================

Niklas Luhmann (1927–1998) foi um sociólogo alemão que publicou mais
de 70 livros e 400 artigos. Sua produtividade vinha de um sistema de
notas em fichas de papel que ele chamava de Zettelkasten ("caixa de
fichas").

Luhmann descrevia o sistema como seu "parceiro de comunicação" — uma
máquina que, pela forma como era organizada, gerava conexões
inesperadas e sugeria ideias que ele não teria sozinho. Ele chamava
o resultado de "combinação de desordem e ordem, de clustering e
combinações imprevisíveis".

O sistema NÃO era:
  - Uma taxonomia de tipos de nota (fleeting / literature / permanent)
  - Um pipeline linear (captura → pesquisa → síntese)
  - Um sistema de tags

Esses conceitos foram popularizados por Sönke Ahrens em "How to Take
Smart Notes" (2017). O livro é útil como introdução, mas sistematizou
e simplificou o método de formas que distorcem o original. A Parte 7
deste tutorial compara os dois para que você faça escolhas informadas.



==========================================================================
  Lição 1.2: AS DUAS CAIXAS
==========================================================================

Luhmann mantinha DUAS caixas separadas:

  1. Zettelkasten principal — ideias, argumentos, pensamentos, todos
     escritos nas próprias palavras. Esta é "a caixa".

  2. Caixa de referências bibliográficas — fichas curtas com dados
     da fonte (autor, título, ano) e ponteiros para os zettels
     relevantes.

A caixa principal NÃO continha citações nem resumos. Tudo era
reformulado nas palavras de Luhmann. A caixa de referências era
apenas um índice de fontes — mínimo e funcional.

Neste tutorial, vamos usar:

  notes/
  ├── zettel/     a caixa principal (ideias)
  └── biblio/     referências bibliográficas



==========================================================================
  Lição 1.3: FOLGEZETTEL — O CORAÇÃO DO MÉTODO
==========================================================================

Folgezettel ("nota de continuação") é o mecanismo central que
diferencia o Zettelkasten de qualquer outro sistema de notas.

Funciona assim: cada ficha recebe um número fixo. Quando uma nova
ideia CONTINUA ou RAMIFICA de uma existente, ela recebe um número
derivado:

  1       Checksums provam integridade
  1a      SHA-256 substituiu MD5 como padrão
  1b      Checksum não prova autoria — só que não mudou
  1b1     Para provar autoria, precisa de assinatura

  2       Assinaturas digitais provam autenticidade
  2a      Criptografia assimétrica: privada assina, pública verifica

  3       "Don't trust, verify" — o princípio

O ato de DECIDIR onde posicionar uma nota é cognitivo. Você é forçado
a revisitar notas anteriores, entender a relação, e escolher se a
nova ideia:

  - Continua a nota atual    (1 → 1a)
  - Contrasta com ela        (1a, 1b)
  - Abre um novo tópico      (1, 2, 3)

Isso NÃO é a mesma coisa que "linkar notas". Links digitais ([[wiki]])
são úteis, mas não forçam a decisão de posicionamento. No Zettelkasten
digital, simulamos Folgezettel com links explícitos de continuidade.



==========================================================================
  Lição 1.4: O REGISTER (ÍNDICE)
==========================================================================

Luhmann mantinha um Register (Schlagwortregister) — um índice de
palavras-chave com ponteiros para notas.

IMPORTANTE: o Register NÃO é um sistema de tags.

  Tags:     cada nota recebe múltiplas tags → busca por categoria
  Register: cada palavra-chave aponta para 1–3 notas → ponto de entrada

O Register é uma porta de entrada. Você busca "verificação", encontra
1–2 notas iniciais, e a partir delas navega pelas ramificações
(Folgezettel). O Register é mínimo por design — poucos ponteiros
por termo, às vezes apenas um.

Neste tutorial, o Register será um arquivo _register.md na raiz
de notes/.



==========================================================================
  Lição 1.5: HUB NOTES
==========================================================================

Hub notes são zettels que listam as ramificações de um tópico.
Funcionam como mapas locais: "para continuar este assunto, veja
estas notas".

Diferença entre Hub note e Register:

  Register  → índice GLOBAL, pontos de entrada por palavra-chave
  Hub note  → mapa LOCAL de um tópico específico

Um hub note pode ser referenciado pelo Register. É a ponte entre
o índice geral e uma cadeia de pensamento específica.

Com esse contexto, vamos configurar as ferramentas.



==========================================================================
  PARTE 2: SETUP
==========================================================================


==========================================================================
  Lição 2.1: INSTALAR O ZK
==========================================================================

zk é um CLI para gerenciar notas em plain text.
Indexa arquivos .md, resolve [[links]], e expõe um LSP server.

  EXERCÍCIO:
  1. Instale (se ainda não tem):
     :!brew install zk

  2. Verifique:
     :!zk --version

Se já está instalado, siga em frente.



==========================================================================
  Lição 2.2: CRIAR O DIRETÓRIO DE NOTAS
==========================================================================

Duas pastas — uma por caixa. Mais o arquivo de Register.

  notes/
  ├── zettel/        a caixa principal (ideias, argumentos)
  ├── biblio/        referências bibliográficas
  └── _register.md   índice de pontos de entrada

  EXERCÍCIO:
  1. Crie a estrutura:
     :!mkdir -p notes/zettel notes/biblio

  2. Adicione .gitkeep para o git trackear pastas vazias:
     :!touch notes/zettel/.gitkeep notes/biblio/.gitkeep

  3. Crie o Register vazio:
     :e notes/_register.md

     Cole o conteúdo abaixo, salve com  :w  e volte aqui ( Space f b ):

     ---
     title: "Register"
     ---

     Índice de pontos de entrada para o Zettelkasten.
     Cada palavra-chave aponta para 1–3 notas iniciais.

     ## Palavras-chave

     (será preenchido ao longo do tutorial)



==========================================================================
  Lição 2.3: INICIALIZAR O NOTEBOOK
==========================================================================

O zk precisa de um diretório .zk/ com configuração e templates.

  EXERCÍCIO:
  1. Inicialize o notebook:
     :!cd notes && zk init --no-input

     (--no-input pula as perguntas interativas. Não importa —
     vamos substituir o config.toml inteiro na próxima lição.)

  2. Veja o que foi criado:
     :!ls -la notes/.zk/
     :!ls notes/.zk/templates/

  3. Mude o diretório de trabalho do Neovim para notes/:
     :cd notes

     A partir de agora, todos os comandos :! rodam dentro de notes/.
     Os comandos zk vão encontrar o .zk/ automaticamente.

  4. Adicione ao .gitignore do projeto:
     :!echo "notes/.zk/notebook.db" >> ../.gitignore



==========================================================================
  Lição 2.4: CONFIGURAR O ZK
==========================================================================

Abra .zk/config.toml e substitua todo o conteúdo por:

  EXERCÍCIO:
  1. Abra o config:
     :e .zk/config.toml
  2. Apague tudo ( ggdG ) e cole a configuração abaixo:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

[note]
language = "pt"
filename = "{{format-date now '%Y%m%d%H%M%S'}}-{{slug title}}"
extension = "md"
template = "zettel.md"

[extra]

[group."zettel"]
paths = ["zettel"]
[group."zettel".note]
template = "zettel.md"

[group."biblio"]
paths = ["biblio"]
[group."biblio".note]
template = "biblio.md"

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
orphans = "--orphan"
tagless = "--tagless"

[alias]
ls = "zk list $argv"
z = "zk new zettel --title \"$argv\""
b = "zk new biblio --title \"$argv\""
recent = "zk edit --sort created- --created-after 'last two weeks' --interactive"
orphans = "zk list --orphan --format oneline"
tagless = "zk list --tagless --format oneline"
broken = "zk list --missing-backlink --format oneline"
tags = "zk tag list --format full"
graph = "zk graph --format json --quiet"

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  3. Salve:  :w
  4. Volte ao TUTOR:  Space f b  → TUTOR.md

O que cada seção faz:
  [note]      filename com timestamp + slug, idioma pt
  [group.*]   zettel e biblio usam templates diferentes
  [format]    links [[wiki]], hashtags ativadas
  [tool]      editor nvim, preview com bat
  [lsp]       dead links = erro, autocomplete configurado
  [alias]     atalhos: zk z, zk b, zk orphans, zk tags, zk graph



==========================================================================
  Lição 2.5: CRIAR OS TEMPLATES
==========================================================================

Templates definem o conteúdo inicial de cada nota.
Ficam em .zk/templates/ e usam sintaxe Handlebars.

  EXERCÍCIO:
  Crie cada arquivo, cole o conteúdo, salve e volte aqui.

  1. :e .zk/templates/zettel.md
     Apague o conteúdo existente ( ggdG ) e cole:

     ---
     title: "{{title}}"
     date: {{format-date now}}
     tags: []
     ---

     {{content}}

     Salve:  :w  → Volte:  Space f b  → TUTOR.md

  2. :e .zk/templates/biblio.md
     Cole:

     ---
     title: "{{title}}"
     date: {{format-date now}}
     source:
     author:
     ---

     {{content}}

     Salve:  :w  → Volte:  Space f b  → TUTOR.md

O template do zettel é mínimo por design. A complexidade está nas
conexões entre notas, não no formato individual.

O template de biblio tem source e author — é a ficha bibliográfica.



==========================================================================
  Lição 2.6: TESTAR A INSTALAÇÃO
==========================================================================

  EXERCÍCIO:
  1. Crie uma nota de teste:
     :!zk new zettel --title "teste de instalação" --print-path

     (--print-path imprime o caminho em vez de abrir o editor,
     já que estamos dentro do Neovim)

  2. Abra a nota criada:
     :e zettel/
     → Tab para completar o nome do arquivo → Enter

  3. Verifique:
     - Filename: YYYYMMDDHHMMSS-teste-de-instalacao.md
     - Frontmatter com title, date, tags preenchidos

  4. Volte ao TUTOR:  Space f b  → TUTOR.md

  5. Verifique o índice:
     :!zk list --format "{{title}} — {{path}}"

  6. Delete a nota de teste:
     :!rm zettel/*teste-de-instalacao*

Setup concluído. Siga para a Parte 3.



==========================================================================
  PARTE 3: NEOVIM
==========================================================================


==========================================================================
  Lição 3.1: PLUGIN ZK-NVIM
==========================================================================

O zk-nvim conecta o Neovim ao LSP do zk. Quando você abre um .md
dentro de notes/, o LSP ativa automaticamente: autocomplete de
[[links]], go-to-definition, backlinks, hover, diagnósticos.

Pré-requisito: lazy.nvim instalado.
NÃO instale o zk via Mason — o CLI já inclui o LSP.

  EXERCÍCIO:
  1. Abra seu init.lua:
     :e ~/.config/nvim/init.lua

  2. Adicione dentro do require("lazy").setup({ ... }):

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
    keymap("n", "<leader>zz", function()
      vim.ui.input({ prompt = "Zettel: " }, function(t)
        if t then zk.new({ dir = "zettel", title = t }) end
      end)
    end)
    keymap("n", "<leader>zr", function()
      vim.ui.input({ prompt = "Referência: " }, function(t)
        if t then zk.new({ dir = "biblio", title = t }) end
      end)
    end)

    -- Links
    keymap("n", "<leader>zi", "<cmd>ZkInsertLink<cr>")
    keymap("v", "<leader>zi", ":'<,'>ZkInsertLinkAtSelection<cr>")
    keymap("v", "<leader>zn", ":'<,'>ZkNewFromTitleSelection<cr>")
  end,
}

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  3. Adicione FORA dos plugins (para gd e K funcionarem):

     vim.api.nvim_create_autocmd("LspAttach", {
       callback = function(args)
         local opts = { buffer = args.buf }
         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
         vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
       end,
     })

  4. Salve:  :w
  5. Sincronize os plugins:  :Lazy sync
  6. Recarregue o Neovim. Escolha uma das opções:
     - :source $MYVIMRC  (pode funcionar, depende da config)
     - :qa  e reabra:  nvim TUTOR.md
  7. Volte ao TUTOR:  Space f b  → TUTOR.md



==========================================================================
  Lição 3.2: VERIFICAR O LSP
==========================================================================

  EXERCÍCIO:
  1. Se ainda não fez, mude o diretório de trabalho:
     :cd notes

  2. Abra o Register:
     :e _register.md

  3. Digite  :LspInfo  e pressione Enter
  4. "zk" deve aparecer na lista de clientes
  5. Pressione  q  para fechar

  Se não aparecer, verifique:  :pwd  deve mostrar .../notes/

  6. Volte ao TUTOR:  Space f b  → TUTOR.md



==========================================================================
  PARTE 4: O MÉTODO — CONSTRUIR UM ARGUMENTO
==========================================================================

A partir daqui, vamos construir notas reais usando o método de
Luhmann.

Tema: "Verificar antes de confiar"

Diferente de um pipeline linear (captura → pesquisa → síntese), o
Zettelkasten funciona por ramificação: cada nota pode gerar ramos
que você não planejou. O sistema "fala de volta".



==========================================================================
  Lição 4.1: O PRIMEIRO ZETTEL
==========================================================================

Toda cadeia de pensamento começa com uma nota. Não "fleeting", não
"permanent" — apenas um zettel: uma ideia atômica, nas suas palavras.

Atômica = uma ideia por nota. Não um parágrafo, não um ensaio.
Uma ideia que se sustenta sem contexto externo.

  EXERCÍCIO:
  1. Pressione  Space z z
  2. Título: "Checksums provam integridade"
  3. O Neovim abre a nota. Pressione  i
  4. Escreva:

     Um checksum é um hash do conteúdo de um arquivo. Se um único
     bit muda, o hash muda. Verificar o checksum de um download
     confirma que o arquivo não foi alterado entre o servidor e
     a sua máquina.

  5. Adicione uma tag no frontmatter:
     tags: [verificação]

  6. Salve:  :w

Essa é a nota 1 da sua cadeia. Curta, clara, uma ideia.



==========================================================================
  Lição 4.2: FOLGEZETTEL — CONTINUAR O PENSAMENTO
==========================================================================

Agora vamos ramificar. A próxima nota CONTINUA o pensamento da
primeira — é uma Folgezettel.

No sistema físico de Luhmann, a posição da ficha comunicava a
relação. No digital, fazemos isso com um link explícito no início
da nota.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Pressione  Space z z
  3. Título: "SHA-256 substituiu MD5"
  4. Escreva (pressione  i ):

     Continua de

  5. Agora insira o link: pressione  Esc , depois  Space z i
     → no Telescope, selecione "Checksums provam integridade"
     → o link [[...]] é inserido automaticamente

  6. Pressione  o  (nova linha) e continue:

     MD5 é vulnerável a colisões — dois arquivos diferentes podem
     gerar o mesmo hash. SHA-256 é o padrão atual: resistente a
     colisões e computacionalmente viável de verificar.

  7. tags: [verificação]
  8. Salve:  :w

A primeira linha ("Continua de [[...]]") é a Folgezettel digital.
Ela estabelece a posição desta nota na cadeia de pensamento.



==========================================================================
  Lição 4.3: RAMIFICAR EM OUTRA DIREÇÃO
==========================================================================

A nota 1 ("Checksums provam integridade") pode ter outra ramificação
— uma que CONTRASTA em vez de continuar.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Pressione  Space z z
  3. Título: "Checksum não prova autoria"
  4. Escreva:

     Ramifica de

  5. Insira o link:  Space z i  → "Checksums provam integridade"

  6. Continue (pressione  o ):

     Um checksum garante que o arquivo não mudou, mas NÃO garante
     QUEM o criou. Se o servidor for comprometido, o atacante pode
     substituir tanto o arquivo quanto o checksum. Para provar
     autoria, é necessário um mecanismo diferente: assinaturas
     digitais.

  7. tags: [verificação]
  8. Salve:  :w

Agora você tem uma ramificação real:

  "Checksums provam integridade"
   ├── "SHA-256 substituiu MD5"          (continua)
   └── "Checksum não prova autoria"      (contrasta)



==========================================================================
  Lição 4.4: CONTINUAR UMA RAMIFICAÇÃO
==========================================================================

A nota "Checksum não prova autoria" abre uma questão: então o que
prova autoria? Vamos continuar ESSE ramo.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Pressione  Space z z
  3. Título: "Assinaturas digitais provam autenticidade"
  4. Escreva:

     Continua de

  5. Insira o link:  Space z i  → "Checksum não prova autoria"

  6. Continue:

     Uma assinatura digital usa criptografia assimétrica: a chave
     privada assina, a chave pública verifica. Isso prova duas
     coisas: o arquivo não foi alterado (integridade) E quem
     assinou é quem diz ser (autenticidade).

  7. tags: [verificação, criptografia]
  8. Salve:  :w

O grafo até aqui:

  "Checksums provam integridade"
   ├── "SHA-256 substituiu MD5"
   └── "Checksum não prova autoria"
        └── "Assinaturas digitais provam autenticidade"



==========================================================================
  Lição 4.5: UMA NOVA CADEIA
==========================================================================

Nem toda nota ramifica de outra. Às vezes surge uma ideia que abre
um tópico separado — sem Folgezettel, apenas uma nova raiz.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Pressione  Space z z
  3. Título: "Verificar elimina a necessidade de confiar"
  4. Escreva:

     "Don't trust, verify" é um princípio da cultura cypherpunk
     que se aplica além de criptografia: software, comunicação,
     identidade. Se você pode verificar por conta própria, não
     precisa confiar em nenhum intermediário. Verificação é
     soberania técnica.

  5. tags: [verificação, soberania]
  6. Salve:  :w

Essa nota NÃO ramifica de nenhuma anterior — é uma raiz nova.
Vai se conectar às outras através da hub note.



==========================================================================
  Lição 4.6: REFERÊNCIAS BIBLIOGRÁFICAS
==========================================================================

Agora vamos registrar as fontes na segunda caixa (biblio/).
Fichas curtas: quem, onde, e ponteiros para os zettels relevantes.

  EXERCÍCIO:
  1. Volte aqui:  Space f b  → TUTOR.md

  2. Pressione  Space z r
  3. Título: "Arch Wiki — Checksum"
  4. Preencha o frontmatter:

     source: https://wiki.archlinux.org/title/Checksum
     author: Arch Wiki

  5. No corpo, escreva:

     Referência sobre algoritmos de checksum, uso de sha256sum
     e verificação de downloads.

     Zettels relacionados:

  6. Insira links com  Space z i  (2 vezes, um por linha):
     → "Checksums provam integridade"
     → "SHA-256 substituiu MD5"

  7. Salve:  :w

  8. Repita para mais duas fontes:

     --- fonte 2 ---
     Volte aqui:  Space f b  → TUTOR.md
     Space z r  → "GnuPG Manual — Digital Signatures"

     source: https://www.gnupg.org/gph/en/manual/x135.html
     author: GnuPG Project

     Corpo:

     Referência sobre assinaturas digitais com GPG.

     Zettels relacionados:

     Insira links:
     → "Assinaturas digitais provam autenticidade"
     → "Checksum não prova autoria"

     Salve:  :w

     --- fonte 3 ---
     Volte aqui:  Space f b  → TUTOR.md
     Space z r  → "Nakamoto Institute — Cypherpunk Library"

     source: https://nakamotoinstitute.org/library/
     author: Nakamoto Institute

     Corpo:

     Origem do princípio "Don't trust, verify".

     Zettels relacionados:

     Insira link:
     → "Verificar elimina a necessidade de confiar"

     Salve:  :w

Antes de seguir, vamos checar o vocabulário que construímos até aqui.

  9. :!zk tag list --format full

     Você deve ver: verificação (5 notas), criptografia (1), soberania (1),
     hub (0 — ainda não criamos a hub note).

     Se alguma tag está faltando, abra a nota e corrija o frontmatter.
     Se aparecer uma tag inesperada, é typo — corrija agora.



==========================================================================
  Lição 4.7: VERIFICAR LINKS E BACKLINKS
==========================================================================

  EXERCÍCIO:
  1. Abra o primeiro zettel:
     Space z n  → "Checksums provam" → Enter

  2. Pressione  Space z b  (backlinks)
     → "SHA-256 substituiu MD5" e "Checksum não prova autoria"
     devem aparecer (ambos ramificam desta nota)

  3. Abra "Checksum não prova autoria":
     Space z n  → "não prova" → Enter

  4. Pressione  Space z l  (links que saem)
     → "Checksums provam integridade" deve aparecer

  5. Pressione  Space z b  (backlinks)
     → "Assinaturas digitais provam autenticidade" deve aparecer

  6. Teste hover:  cursor sobre um [[link]]  →  K
  7. Teste go-to:  cursor sobre um [[link]]  →  gd
  8. Volte:  Ctrl+o

Agora a mesma coisa via  :!  — filtros de links do zk:

  9. Quem linka para "Checksums provam integridade"?
     :!zk list --link-to zettel/*checksums* --format oneline
     → mesmas 2 notas que apareceram nos backlinks (passo 2)

  10. Quais notas saem de "Checksum não prova autoria"?
      :!zk list --linked-by zettel/*nao-prova* --format oneline
      → "Checksums provam integridade" (mesma do passo 4)

  11. Siga os backlinks recursivamente a partir da raiz:
      :!zk list --link-to zettel/*checksums* --recursive --format oneline
      → toda a cadeia deve aparecer, em profundidade
      (--link-to = quem aponta para esta nota; --recursive = segue adiante)

O grafo completo:

  "Checksums provam integridade"
   ├── "SHA-256 substituiu MD5"
   └── "Checksum não prova autoria"
        └── "Assinaturas digitais provam autenticidade"

  "Verificar elimina a necessidade de confiar"  (raiz separada)



==========================================================================
  PARTE 5: ORGANIZAÇÃO — HUB NOTE E REGISTER
==========================================================================


==========================================================================
  Lição 5.1: CRIAR UMA HUB NOTE
==========================================================================

Uma hub note é um zettel que mapeia as ramificações de um tópico.
Funciona como uma visão de cima (bird's eye view) do terreno.

Antes de escrever, veja a estrutura real do notebook.

  EXERCÍCIO:
  1. Gere o grafo completo:
     :!zk graph --format json --quiet

     Nós = notas, arestas = links. Note as duas raízes separadas
     e a cadeia de Folgezettel. A hub note vai formalizar isso.

  2. Filtre por tag:
     :!zk graph --format json --tag verificação --quiet

     Se alguma nota do argumento não apareceu, falta a tag.

Agora escreva o mapa.

  3. Pressione  Space z z
  4. Título: "Hub — Verificação de software"
  5. Escreva o corpo. Use  Space z i  para inserir cada link:

     Verificação de software envolve três camadas:

     Integridade — o arquivo não foi alterado:
     - [[...checksums-provam-integridade]]
       - [[...sha-256-substituiu-md5]]
       - [[...checksum-nao-prova-autoria]]

     Autenticidade — quem criou é quem diz ser:
     - [[...assinaturas-digitais-provam-autenticidade]]

     Princípio:
     - [[...verificar-elimina-a-necessidade-de-confiar]]

     Referências:
     - [[...arch-wiki-checksum]]
     - [[...gnupg-manual-digital-signatures]]
     - [[...nakamoto-institute-cypherpunk-library]]

  (Os nomes reais dos links serão preenchidos pelo  Space z i )

  6. tags: [verificação, hub]
  7. Salve:  :w

A hub note mostra a estrutura Folgezettel de forma explícita:
indentação = ramificação. Ela NÃO é a nota principal — é um mapa.



==========================================================================
  Lição 5.2: ATUALIZAR O REGISTER
==========================================================================

O Register é o índice global. Poucas entradas, poucas notas por
entrada. O objetivo é ter portas de entrada, não uma lista exaustiva.

  EXERCÍCIO:
  1. Abra o Register:
     Space z n  → "Register" → Enter

  2. Substitua "(será preenchido ao longo do tutorial)" por três
     entradas. Use  Space z i  para inserir cada link:

     **verificação** →  (insira link para "Hub — Verificação de software")

     **criptografia** →  (insira link para "Assinaturas digitais provam autenticidade")

     **soberania** →  (insira link para "Verificar elimina a necessidade de confiar")

  3. Salve:  :w

Três palavras-chave, cada uma apontando para UMA nota de entrada.
A partir dessa nota, você navega pelas ramificações.

Isso é o Register de Luhmann: mínimo, funcional, não-exaustivo.



==========================================================================
  Lição 5.3: VERIFICAR O SISTEMA COMPLETO
==========================================================================

  EXERCÍCIO:
  1. Verifique notas órfãs:
     Space z o
     → idealmente nenhuma nota está órfã

  2. Abra a hub note:
     Space z n  → "Hub — Verificação" → Enter

  3. Pressione  Space z l
     → todas as notas devem aparecer (a hub aponta para todas)

  4. Abra o Register:
     Space z n  → "Register" → Enter
     → os 3 pontos de entrada devem funcionar (gd sobre cada link)

  5. Reindexe:
     Space z x

  6. Volte aqui:  Space f b  → TUTOR.md

Três filtros de auditoria que o plugin não expõe — só via  :!

  7. Notas órfãs (ninguém linka para elas):
     :!zk list --orphan --format oneline
     → o Register vai aparecer aqui — é esperado, ele é ponto de entrada,
       ninguém linka para ele. Qualquer OUTRA nota órfã indica um link faltando.

  8. Notas sem tags (esqueceu de taguear):
     :!zk list --tagless --format oneline
     → se aparecer, abra a nota e adicione tags no frontmatter

  9. Backlinks faltando (A linka B, mas B não linka de volta para A):
     :!zk list --missing-backlink --format oneline
     → no Zettelkasten isso é normal (Folgezettel são unidirecionais),
       mas vale revisar se alguma conexão bidirecional faz sentido

Corrija o que aparecer. Os aliases da Lição 2.4 encurtam:
  :!zk orphans     :!zk tagless     :!zk broken

Seu Zettelkasten agora tem:

  zettel/    5 notas-ideia + 1 hub note
  biblio/    3 referências bibliográficas
  Register   3 pontos de entrada



==========================================================================
  PARTE 6: DO ZETTELKASTEN AO TEXTO
==========================================================================

O Zettelkasten não é um rascunho. É matéria-prima estruturada.
A hub note mostra o argumento; os zettels fornecem os blocos.
Agora vamos montar um texto a partir deles.


==========================================================================
  Lição 6.1: REUNIR O MATERIAL
==========================================================================

A hub note é o roteiro. Mas antes de escrever, use a busca do zk
para localizar trechos e conexões que podem ter passado batido.

  EXERCÍCIO:
  1. Releia a hub note — é o esqueleto do texto:
     Space z n  → "Hub — Verificação" → Enter

  2. Volte ao TUTOR:  Space f b  → TUTOR.md

  3. Busque todos os zettels sobre o tema (excluindo referências):
     :!zk list --tag verificação --exclude biblio/ --format medium

  4. Existe alguma nota que MENCIONA "checksum" sem link explícito?
     :!zk list --mention zettel/*checksums*
     (--mention busca o TÍTULO da nota no corpo de outras, mesmo sem [[link]])

  5. Busca full-text para localizar um trecho específico:
     :!zk list --match "criptografia assimétrica" --format oneline

  6. Busca com regex (para variações de grafia):
     :!zk list --match "SHA-?256" --match-strategy re

  7. Notas possivelmente relacionadas que você não linkou:
     :!zk list --related zettel/*assinaturas* --format oneline



==========================================================================
  Lição 6.2: ESCREVER O RASCUNHO
==========================================================================

Use a hub note como roteiro e os zettels como blocos de construção.
Cada zettel vira um trecho do texto — expandido, editado, com voz
de publicação. O rascunho fica dentro do próprio notebook.

  EXERCÍCIO:
  1. Crie o rascunho:
     :e drafts/verificar-antes-de-confiar.md

     (O Neovim cria o arquivo ao salvar. A pasta drafts/ separa
     rascunhos das notas atômicas — não é indexada pelo zk.)

  2. Escreva seguindo a estrutura da hub note:

     # Verificar antes de confiar

     Parágrafo de abertura — o problema.
     (baseado em "Verificar elimina a necessidade de confiar")

     ## Checksum: o arquivo não mudou
     (baseado em "Checksums provam integridade" + "SHA-256 substituiu MD5")

     ## O checksum não é suficiente
     (baseado em "Checksum não prova autoria")

     ## Assinatura: quem criou é quem diz ser
     (baseado em "Assinaturas digitais provam autenticidade")

     ## Don't trust, verify
     (baseado em "Verificar elimina a necessidade de confiar")

     Parágrafo de fechamento — a tese.

  3. Crie a pasta e salve:
     :!mkdir -p drafts
     :w

  4. Para o zk não indexar os rascunhos, adicione ao config.toml:
     :e .zk/config.toml
     → Na seção [note], adicione:
       exclude = ["drafts/*"]
     → Salve:  :w  → Volte:  Space f b  → TUTOR.md

O rascunho é a destilação. O Zettelkasten é o laboratório.
O argumento já existia nas conexões entre as notas — o texto
apenas lineariza o que o sistema já tinha organizado.

Daqui, o rascunho pode virar qualquer coisa: um post de blog,
um artigo, um capítulo, um email. O formato de publicação é
problema do seu framework — o Zettelkasten já fez o trabalho
pesado.



==========================================================================
  Lição 6.3: RESULTADO FINAL
==========================================================================

Verifique o que foi construído:

  EXERCÍCIO:
  1. Veja as notas:
     :!zk list --format "{{title}} — {{path}}"

  2. Veja o rascunho:
     :e drafts/verificar-antes-de-confiar.md
     → Confira o conteúdo, volte:  Space f b  → TUTOR.md

Você completou o ciclo:
  notas atômicas → ramificações (Folgezettel) → hub → texto

  zettel/    5 notas-ideia + 1 hub note
  biblio/    3 referências bibliográficas
  Register   3 pontos de entrada
  drafts/    1 rascunho pronto para publicar



==========================================================================
  PARTE 7: MÉTODO ORIGINAL vs. INTERPRETAÇÕES MODERNAS
==========================================================================

Agora que você praticou o método original, vale entender as
variações e por que existem.

  LUHMANN (original)         AHRENS (2017)
  ─────────────────          ───────────────
  Uma caixa de ideias        Fleeting notes
  Uma caixa de refs          Literature notes
  (sem tipo de nota)         Permanent notes
  Folgezettel (posição)      Links [[wiki]]
  Register (pontos entrada)  Tags
  Hub notes                  MOC / Structure notes

                             ESTE TUTORIAL
                             ──────────────
                             zettel/
                             biblio/
                             (sem tipo de nota)
                             Links + "Continua de" / "Ramifica de"
                             _register.md
                             Hub notes

Nenhuma abordagem está "errada". Mas saber O QUE FOI MUDADO permite
que você faça escolhas informadas em vez de seguir um guia cegamente.

O debate Folgezettel vs. links-only continua ativo na comunidade.
A posição deste tutorial: use ambos. O link digital é prático; a
decisão de posicionamento ("Continua de" / "Ramifica de") é
cognitivamente valiosa.

Onde Ahrens distorce Luhmann:

  1. A classificação fleeting/literature/permanent não existia.
     Luhmann escrevia zettels. Não categorizava por "estágio".

  2. O pipeline linear (captura → pesquisa → síntese) é uma
     invenção editorial. Luhmann não seguia uma sequência fixa.

  3. "Literature notes" em Ahrens são citações no gerenciador
     de referências — não notas de leitura dentro do Zettelkasten.

  4. O livro vende mais do que explica. Bob Doto escreveu
     "A System for Writing" como complemento prático justamente
     por causa das confusões que persistiam nos leitores de Ahrens.

Onde Ahrens acerta:

  1. Tornou o método acessível. Antes do livro, Zettelkasten era
     uma lenda acadêmica.

  2. A ênfase em "escrever nas suas palavras" é fiel ao original.

  3. Mostrou que o método se aplica além da academia.

Para aprofundar:

  zettelkasten.de
    O site mais fiel ao método original. O fórum tem debates
    detalhados sobre Folgezettel, register, e organização.

  Schmidt, Johannes (2016). "Niklas Luhmann's Card Index"
    Estudo acadêmico do sistema original, baseado no acervo
    físico (agora digitalizado pela Universidade de Bielefeld).

  Bob Doto, "A System for Writing" (2024)
    Complementa Ahrens com prática concreta e menos venda.

  niklas-luhmann-archiv.de
    O arquivo digital do Zettelkasten original de Luhmann.
    90.000 fichas digitalizadas e navegáveis.



==========================================================================
  REFERÊNCIA RÁPIDA
==========================================================================

  NEOVIM

  Space z n  ···  listar notas          Space z z  ···  novo zettel
  Space z s  ···  buscar conteúdo       Space z r  ···  nova referência
  Space z t  ···  navegar tags          Space z i  ···  inserir link
  Space z b  ···  backlinks             Space z x  ···  reindexar
  Space z l  ···  links
  Space z o  ···  notas órfãs

  gd  ··········  abrir nota do link    Ctrl+o  ····  voltar
  K   ··········  preview flutuante     Space f b ··  listar buffers
  [[  ··········  autocomplete links    :w  ········  salvar

  TERMINAL — CRIAR

  zk z "título"       novo zettel (alias)
  zk b "título"       nova referência (alias)
  zk new -n zettel    dry-run — mostra o resultado sem criar o arquivo

  TERMINAL — BUSCAR E NAVEGAR

  zk list                        listar todas
  zk list --tag X                filtrar por tag
  zk list --match "termo"        busca full-text
  zk list --match "X" -M re     busca com regex
  zk list --match "X" -M exact  busca exata
  zk list --link-to PATH        quem linka para PATH (= backlinks)
  zk list --linked-by PATH      notas linkadas a partir de PATH
  zk list --link-to P -r        seguir backlinks recursivamente
  zk list --related PATH        notas possivelmente relacionadas
  zk list --mention PATH        mencionam o título (sem [[link]])
  zk list --exclude biblio/     excluir diretório
  zk list --created-after "last week"  notas recentes
  zk edit -i                     busca interativa (abre no nvim)
  zk edit --tag X                editar notas com tag X

  TERMINAL — AUDITAR

  zk orphans                  notas sem backlinks (alias)
  zk tagless                  notas sem tags (alias)
  zk broken                   backlinks faltando (alias)
  zk tags                     listar tags com contagem (alias)
  zk graph                    grafo JSON completo (alias)

  Sem alias:
  zk list --orphan            zk list --tagless
  zk list --missing-backlink  zk tag list --format full
  zk graph --format json --tag X
  zk graph --format json --link-to P -r

  CONVENÇÕES FOLGEZETTEL (digital)

  "Continua de [[nota]]"    esta nota dá seguimento ao pensamento
  "Ramifica de [[nota]]"    esta nota contrasta ou abre variação
  (sem referência)          esta nota é uma raiz — novo tópico

  ESTRUTURA

  notes/
  ├── zettel/        a caixa principal (ideias atômicas + hubs)
  ├── biblio/        referências bibliográficas
  ├── _register.md   índice de pontos de entrada
  └── .zk/           configuração do zk (gerado)

==========================================================================

Fim do tutorial. As notas e o post que você criou são reais.
Revise, expanda, publique quando estiver pronto.
