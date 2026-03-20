---
title: "Como penso infraestrutura pessoal"
date: 2026-03-26
draft: true
tags: ["self-hosting", "privacy"]
categories: ["profissional"]
description: "O processo de decisao por tras de cada componente da minha infra: VPS, nginx, Tor, zero analytics. Cada escolha reflete um trade-off consciente."
toc: false
---

Existe uma diferenca entre montar infraestrutura e comprar servicos. Quem compra servico terceiriza a decisao. Quem monta infra precisa justificar cada componente. Este post e sobre o segundo caso.

Nao e um tutorial de homelab. Nao vou explicar como instalar nginx ou configurar Docker. O que quero documentar e o *por que* de cada peca — o raciocinio que transforma uma VPS generica numa stack que reflete principios concretos.

Se voce quer ver como outros engenheiros pensam sobre infraestrutura pessoal, recomendo os posts de [Akash Rajpurohit sobre self-hosting](https://akashrajpurohit.com/blog/my-self-hosting-journey-in-2024/), o [homelab tour do Ben Prisby](https://benprisby.com/blog/homelab-tour-2025/) e o [diagrama do Lucas Duete](https://lucasduete.dev/posts/my-homelab-diagram-2025/). Cada um fez escolhas diferentes das minhas, e e exatamente isso que torna o exercicio interessante.

## VPS propria, nao cloud provider

A primeira decisao e onde rodar. Opcoes nao faltam: AWS, DigitalOcean, Fly.io, Vercel, Netlify. Sao bons servicos. Mas todos adicionam uma camada de abstracao que existe para resolver problemas que eu nao tenho.

Meu site e estatico. Precisa de um servidor HTTP e de SSH para deploy. Nada mais. Uma VPS na Contabo me da um servidor com IP fixo, acesso root e custo previsivel. Sem surpresas de billing por request, sem vendor lock-in em funcoes serverless, sem dashboard de 400 opcoes das quais uso duas.

Tem outro aspecto que raramente aparece nas comparacoes: previsibilidade financeira. Uma VPS custa o mesmo todo mes, independente de quantos requests recebeu. Cloud providers cobram por bandwidth, por request, por funcao invocada. Para quem otimiza por simplicidade e nao por escala elastica, preco fixo e uma feature.

O trade-off: responsabilidade total. Atualizacao do SO, firewall, monitoramento — tudo por minha conta. Para um site pessoal com trafego modesto, isso e aceitavel. Para um produto com SLA, provavelmente nao seria.

A questao nunca e "cloud e ruim". E: qual problema estou resolvendo, e a complexidade adicionada se justifica?

## nginx, nao Caddy

Caddy e um servidor HTTP moderno. Tem HTTPS automatico, config simples, bom desempenho. Se eu estivesse comecando hoje sem bagagem, talvez escolhesse Caddy.

Mas eu ja sei nginx. Sei configurar headers de seguranca, cache por tipo de arquivo, gzip, try_files. A config do meu site tem 70 linhas e faz exatamente o que preciso:

- Content-Security-Policy restritivo — `default-src 'none'`, so libera o estritamente necessario
- Permissions-Policy que bloqueia camera, microfone, geolocalizacao, payment API, bluetooth
- Cache imutavel para assets fingerprinted, cache longo para fontes e imagens
- Suporte a Pagefind (WASM) com headers corretos
- Bloqueio de dotfiles

Trocar nginx por Caddy me daria HTTPS automatico. Mas eu sirvo via Cloudflare Tunnel, entao TLS ja esta resolvido. O ganho seria marginal, e eu perderia familiaridade com a ferramenta.

Familiaridade e um criterio de engenharia subestimado. Escolher a ferramenta que voce domina, quando ela resolve o problema, e quase sempre mais produtivo do que adotar a ferramenta da moda que voce ainda vai precisar aprender a debugar as 3 da manha.

## Docker Compose como orquestrador

Toda a stack roda em containers via Docker Compose. Site, n8n, Conduit, GotoSocial, Tor — cada servico e um container com seu proprio volume e rede.

A alternativa seria Kubernetes, Nomad, ou ate systemd puro. Kubernetes e absurdo para uma VPS pessoal. Nomad e interessante, mas adiciona complexidade operacional sem ganho proporcional. Systemd funciona, mas nao me da isolamento, reprodutibilidade e a facilidade de recriar o ambiente inteiro com um `docker compose up -d`.

Com Compose, um `docker compose pull && docker compose up -d` atualiza tudo. O `docker-compose.yml` e versionado. Se a VPS pegar fogo, reconstruo a stack em horas, nao em dias.

Essa reprodutibilidade e o argumento mais forte a favor de containers para infra pessoal. Nao e sobre orquestracao sofisticada — e sobre conseguir descrever a infra inteira num arquivo de texto que cabe num repositorio Git.

## Tor Hidden Service

O site esta acessivel pela clearnet e por dois enderecos `.onion`. Nao porque eu ache que todo mundo deveria acessar via Tor. Mas porque disponibilidade por multiplos caminhos e resiliencia.

Um endereco `.onion` nao depende de DNS. Nao passa por CDN. Nao pode ser bloqueado por IP. Se amanha meu dominio for suspenso ou meu provedor de DNS sair do ar, o `.onion` continua funcionando.

O custo operacional e baixo: um container Tor com um `torrc` configurado. O ganho e um canal de acesso que nao depende de nenhuma terceira parte. Para um site que defende soberania digital, parecia incoerente nao oferecer isso.

O header `Onion-Location` no nginx avisa ao Tor Browser que existe uma versao `.onion` disponivel. O usuario que ja esta no Tor e redirecionado automaticamente. Quem acessa pela clearnet nem percebe que o header existe.

## Zero analytics

Nao tenho Google Analytics, Plausible, Umami, Fathom, nem nenhum script de tracking. Nao e por preguica de instalar — e uma decisao consciente.

Analytics responde a pergunta "quantas pessoas acessaram a pagina X". Essa pergunta e util para quem precisa justificar investimento em conteudo, otimizar conversao ou vender publicidade. Nao e o meu caso. Escrevo porque quero documentar o que penso e o que faco. O feedback que me interessa vem por e-mail, Matrix ou Nostr — de pessoas reais, nao de numeros num dashboard.

O trade-off: nao sei quantas pessoas leem o que publico. Aceito isso. Prefiro nao saber a instalar um script que carrega JavaScript de terceiros, cria conexoes para dominios externos e precisa de uma politica de cookies.

Mesmo analytics "privacy-friendly" como Plausible ou Umami adicionam um script externo e uma dependencia operacional (mais um servico para manter, ou mais uma assinatura). Para um site pessoal, o custo de complexidade nao se paga.

## Zero CDN, fontes self-hosted, SRI

O site nao usa CDN. Os assets — CSS, fontes, JavaScript do Pagefind — sao servidos diretamente do nginx. As fontes sao self-hosted, nao carregadas do Google Fonts.

Cada recurso externo e um ponto de rastreamento potencial. Google Fonts registra IP, User-Agent e Referer de cada visitante. Uma CDN generica faz o mesmo. Eliminar esses pontos e trivial quando o site e estatico e leve — nao ha penalidade de performance perceptivel.

Os assets fingerprinted pelo Hugo recebem cache imutavel de um ano. Na pratica, depois do primeiro acesso, o navegador nao faz mais requests para CSS e fontes. Isso compensa nao ter CDN.

Subresource Integrity (SRI) garante que os assets servidos correspondem ao hash esperado. Se alguem comprometer o servidor e alterar um arquivo CSS, o navegador rejeita o recurso. E uma camada de verificacao que custa zero em performance e adiciona defesa contra adulteracao.

## Deploy: CI no GitHub Actions, deploy manual

O pipeline e simples. Push no `main` dispara o CI: Hugo builda o site, Pagefind gera o indice de busca, o artefato e salvo. Deploy e um workflow separado, disparado manualmente. Quando ativo, faz rsync via SSH para a VPS.

A separacao e intencional. CI roda em cada push — quero saber se o build quebrou. Mas deploy e uma decisao que eu tomo, nao algo que acontece automaticamente. Nao quero que um merge acidental publique conteudo inacabado.

O trade-off: preciso lembrar de disparar o deploy. Na pratica, isso significa um comando a mais. Compensa pela tranquilidade de saber que nada vai pro ar sem eu decidir.

O rsync faz deploy incremental — so transfere arquivos que mudaram. Um deploy tipico leva segundos, nao minutos. E como o artefato do CI ja esta buildado, o deploy nao depende de instalar Hugo ou Node na VPS. O servidor so precisa servir arquivos estaticos.

## Comunicacao descentralizada

Alem do site, a VPS roda Conduit (homeserver Matrix) e GotoSocial (servidor Fediverse). Sao protocolos federados — qualquer pessoa com um cliente compativel pode interagir, sem depender de uma plataforma central.

Matrix me da mensagens criptografadas end-to-end no meu proprio servidor. GotoSocial me da presenca no Fediverse sem depender de mastodon.social ou qualquer outra instancia que pode mudar as regras amanha.

Manter esses servicos custa pouco em recursos (Conduit e escrito em Rust e consome quase nada de RAM) e muito em intencionalidade. E mais facil criar uma conta no Twitter. Mas "facil" e "alinhado com o que eu acredito" raramente sao a mesma coisa.

O n8n completa a stack como motor de automacao. Roda self-hosted no mesmo Compose, conecta servicos entre si sem depender de Zapier ou Make. Se um workflow quebra, eu debugo localmente. Se o n8n mudar a licenca amanha, tenho o codigo e os dados.

## O principio por tras

Cada decisao descrita aqui segue um raciocinio parecido:

1. **Qual problema estou resolvendo?** Se nao ha problema claro, nao preciso da ferramenta.
2. **Qual o custo operacional?** Complexidade so se justifica se o beneficio e proporcional.
3. **Quantas terceiras partes eu adiciono?** Cada dependencia externa e um ponto de confianca que pode ser revogado.
4. **Eu consigo debugar isso sozinho?** Se nao consigo, estou delegando controle, nao ganhando eficiencia.

Nao e uma formula. Nao serve para todo mundo. Quem precisa de escala global, alta disponibilidade e equipe de plantao vai precisar de outra arquitetura. Mas para infraestrutura pessoal — o site, os canais de comunicacao, as automacoes — esses quatro criterios cobrem 90% das decisoes.

Infraestrutura pessoal nao precisa ser sofisticada. Precisa ser deliberada. A diferenca entre um servidor e um servico e que o servidor exige que voce tome decisoes. E tomar decisoes sobre a propria infraestrutura e o oposto de conveniencia passiva — e soberania praticada.
