# zk Tutor
===============

Bem-vindo ao tutorial interativo do zk + Neovim.
Cada lição tem instruções e um exercício para fazer aqui dentro.
Leia, execute, observe o resultado.

IMPORTANTE: este arquivo deve ser aberto de dentro da pasta notes/:
  cd ~/Documents/Workspaces/luisbarcia/luisbarcia.com/notes
  nvim TUTOR.md



==========================================================================
  Lição 1: VERIFICAR QUE O LSP ESTÁ ATIVO
==========================================================================

O zk funciona via LSP. Quando você abre um .md dentro de notes/,
o servidor do zk conecta automaticamente.

  EXERCÍCIO:
  1. Digite o comando   :LspInfo   e pressione Enter
  2. Você deve ver "zk" na lista de clientes ativos
  3. Pressione  q  para fechar a janela

Se não aparecer "zk", você não está dentro da pasta notes/.
Feche o Neovim, entre na pasta e abra de novo.



==========================================================================
  Lição 2: LISTAR NOTAS
==========================================================================

O comando  Space z n  abre o Telescope com todas as notas do notebook.
Dentro do Telescope:
  - Digite para filtrar pelo título
  - Ctrl+j / Ctrl+k  para navegar
  - Enter  para abrir a nota
  - Esc  para cancelar

  EXERCÍCIO:
  1. Pressione  Space z n
  2. O Telescope abre com a lista de notas
  3. Digite "privacidade" para filtrar
  4. Navegue com  Ctrl+j  e  Ctrl+k
  5. Pressione  Esc  para fechar sem abrir nada
  6. Volte a este arquivo com  Space f b  (lista de buffers)



==========================================================================
  Lição 3: BUSCAR POR TAG
==========================================================================

Cada nota tem tags no frontmatter (ex: tags: [privacy, sovereignty]).
O comando  Space z t  lista todas as tags existentes no notebook.

  EXERCÍCIO:
  1. Pressione  Space z t
  2. Selecione a tag "cryptography"
  3. Veja quais notas aparecem
  4. Pressione  Esc  para voltar
  5. Volte a este arquivo com  Space f b



==========================================================================
  Lição 4: BUSCAR POR CONTEÚDO
==========================================================================

O comando  Space z s  busca dentro do texto das notas (full-text search).

  EXERCÍCIO:
  1. Pressione  Space z s
  2. Digite "cypherpunk" quando aparecer o prompt
  3. Pressione  Enter
  4. Veja quais notas contêm essa palavra
  5. Pressione  Esc  para voltar
  6. Volte aqui com  Space f b



==========================================================================
  Lição 5: NAVEGAR LINKS COM gd
==========================================================================

Links entre notas usam a sintaxe [[slug]]. Quando o cursor está sobre
um link, o comando  gd  abre a nota referenciada.

Coloque o cursor em cima deste link e pressione  gd :

  [[schneier-nothing-to-hide]]

  EXERCÍCIO:
  1. Mova o cursor até a linha acima, em cima do link
  2. Pressione  gd
  3. A nota do Schneier deve abrir
  4. Para voltar, pressione  Ctrl+o  (volta no jump list)



==========================================================================
  Lição 6: PREVIEW COM K
==========================================================================

Ao invés de abrir a nota, você pode ver um preview flutuante com  K .
O cursor deve estar sobre o [[link]].

  EXERCÍCIO:
  1. Mova o cursor até o link abaixo
  2. Pressione  K

  [[hughes-cypherpunk-manifesto]]

  3. Uma janela flutuante aparece com o conteúdo
  4. Pressione  Esc  ou mova o cursor para fechar



==========================================================================
  Lição 7: BACKLINKS
==========================================================================

Backlinks são notas que referenciam a nota atual.
O comando  Space z b  mostra quem linka para o arquivo aberto.

  EXERCÍCIO:
  1. Primeiro, abra uma nota que tem backlinks:
     Pressione  Space z n  e abra "schneier-nothing-to-hide"
  2. Com a nota aberta, pressione  Space z b
  3. Veja quais notas referenciam o Schneier
  4. Pressione  Esc  para fechar
  5. Volte aqui:  Ctrl+o  ou  Space f b



==========================================================================
  Lição 8: LINKS DE UMA NOTA
==========================================================================

O inverso de backlinks: quais notas a nota atual referencia.
O comando  Space z l  mostra os links que saem da nota aberta.

  EXERCÍCIO:
  1. Abra a nota "privacidade-nao-e-ter-algo-a-esconder":
     Space z n  → digite "privacidade" → Enter
  2. Pressione  Space z l
  3. Veja as literature notes referenciadas (Schneier, Solove, Hughes)
  4. Volte aqui:  Ctrl+o  ou  Space f b



==========================================================================
  Lição 9: CRIAR UMA FLEETING NOTE
==========================================================================

Fleeting notes são capturas rápidas de ideias.
O comando  Space z f  pede um título e cria a nota em fleeting/.

  EXERCÍCIO:
  1. Pressione  Space z f
  2. Digite "Teste do tutor" e pressione  Enter
  3. Uma nota nova abre com o template preenchido
  4. Você está no modo normal. Pressione  i  para entrar no insert mode
  5. Escreva qualquer coisa abaixo do frontmatter
  6. Pressione  Esc  para voltar ao modo normal
  7. Salve com  :w
  8. Volte aqui:  Space f b  → selecione TUTOR.md

Depois do tutorial, delete a nota de teste:
  :!rm fleeting/*teste-do-tutor*



==========================================================================
  Lição 10: INSERIR UM LINK
==========================================================================

O comando  Space z i  abre o Telescope e insere um [[link]] no cursor.

  EXERCÍCIO:
  1. Coloque o cursor no final desta linha →
  2. Pressione  Space z i
  3. O Telescope abre. Selecione qualquer nota
  4. Um [[link]] é inserido na posição do cursor
  5. Desfaça com  u  para não modificar este arquivo



==========================================================================
  Lição 11: AUTOCOMPLETE DE LINKS
==========================================================================

Ao digitar em insert mode, escreva [[ e o LSP sugere notas automaticamente.

  EXERCÍCIO:
  1. Vá para o final desta linha e pressione  A  (append ao final)
  2. Digite  [[
  3. Uma lista de sugestões aparece
  4. Use  Ctrl+n  e  Ctrl+p  para navegar
  5. Pressione  Enter  para aceitar ou  Esc  para cancelar
  6. Volte ao normal mode com  Esc
  7. Desfaça com  u



==========================================================================
  Lição 12: CRIAR NOTA A PARTIR DE SELEÇÃO
==========================================================================

Selecione texto e use  Space z n  no modo visual para criar uma nota
usando a seleção como título.

  EXERCÍCIO:
  1. Coloque o cursor no início da palavra "Soberania" abaixo
  2. Pressione  viw  para selecionar a palavra (visual inner word)
  3. Pressione  Space z n
  4. Uma nota nova é criada com o título "Soberania"
  5. Feche sem salvar:  :q!
  6. Delete o arquivo criado:  :!rm fleeting/*soberania* 2>/dev/null; rm permanent/*soberania* 2>/dev/null

  Soberania



==========================================================================
  Lição 13: NOTAS ÓRFÃS
==========================================================================

Notas órfãs são notas que nenhuma outra nota referencia.
Identificá-las ajuda a manter o notebook conectado.

  EXERCÍCIO:
  1. Pressione  Space z o
  2. Veja quais notas não têm backlinks
  3. Essas notas precisam ser conectadas ou descartadas
  4. Pressione  Esc  para fechar



==========================================================================
  Lição 14: REINDEXAR
==========================================================================

Se você criou notas pelo terminal e o Neovim não as encontra,
force a reindexação com  Space z x .

  EXERCÍCIO:
  1. Pressione  Space z x
  2. O notebook é reindexado
  3. Notas novas agora aparecem no Telescope



==========================================================================
  Lição 15: WORKFLOW COMPLETO
==========================================================================

Agora junte tudo. Este é o ciclo real de uso:

  1. Leu um artigo interessante?
     Space z r  → "Autor — Título do artigo"
     Preencha source: e author: no frontmatter
     Anote pontos-chave e citações

  2. Teve uma ideia a partir do que leu?
     Space z f  → "Nome da ideia"
     Escreva a ideia em 2-3 frases
     Referencie a fonte:  Space z i  → selecione a literature note

  3. Formou uma opinião/argumento próprio?
     Space z p  → "Tese"
     Escreva na sua voz, sem depender de contexto
     Conecte com outras notas:  Space z i

  4. Juntou permanent notes suficientes sobre um tema?
     É hora de escrever um post em content/posts/

  EXERCÍCIO FINAL:
  1. Crie uma literature note:  Space z r  → "Teste — Artigo fictício"
  2. Escreva algo nos Pontos-chave. Salve:  :w
  3. Crie uma fleeting note:  Space z f  → "Ideia do teste"
  4. No corpo, referencie a literature note:  Space z i
  5. Salve:  :w
  6. Verifique os backlinks da literature note:
     Space z n  → abra "Teste — Artigo fictício"
     Space z b  → a fleeting note deve aparecer
  7. Limpe os arquivos de teste:
     :!rm fleeting/*ideia-do-teste* literature/*teste-artigo*



==========================================================================
  REFERÊNCIA RÁPIDA
==========================================================================

  Space z n  ···  listar notas          Space z f  ···  nova fleeting
  Space z s  ···  buscar conteúdo       Space z r  ···  nova literature
  Space z t  ···  navegar tags          Space z p  ···  nova permanent
  Space z b  ···  backlinks             Space z i  ···  inserir link
  Space z l  ···  links                 Space z x  ···  reindexar
  Space z o  ···  notas órfãs

  gd  ··········  abrir nota do link    Ctrl+o  ····  voltar
  K   ··········  preview flutuante     Space f b ··  listar buffers
  [[  ··········  autocomplete links    :w  ········  salvar

==========================================================================

Fim do tutorial. Delete as notas de teste se ainda não deletou.
Agora é usar. O sistema só funciona se você alimentar ele todo dia.
