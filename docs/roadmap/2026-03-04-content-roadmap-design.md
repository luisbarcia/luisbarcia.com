# Content Roadmap — luisbarcia.com

> Design aprovado em 2026-03-04

## Visao Geral

Site pessoal com duas trilhas de conteudo que sao **lentes**, nao muros. A mesma pessoa escreve nas duas — um dev libertarianista ultra paranoico que tambem lidera, automatiza e constroi em open source.

- **Trilha Pessoal:** "por que" — filosofia, ideologia, posicao, visao de mundo
- **Trilha Profissional:** "como" — pratica, ferramentas, tecnica, execucao

Os temas fluem entre as trilhas conforme o angulo. Um tema como AI pode ser pessoal ("LLMs locais como soberania") ou profissional ("Integrando LLMs open source com n8n").

## Cadencia

- **2 posts/semana** — 1 pessoal + 1 profissional
- **Bilingue** (pt-BR + en)
- **Build log curto** como substituto quando a semana apertar
- Sem ordem fixa entre temas — pool horizontal, publica o que inspira

## Estrategia de Gradacao

Conteudo que vai do moderado ao radical, sem afastar recrutadores, sem se censurar.

| Faixa | Tom | Exemplo | Quem le |
|-------|-----|---------|---------|
| **Acessivel** | Pragmatico, educativo | "5 ferramentas de privacidade que todo dev deveria usar" | Recrutadores, devs curiosos |
| **Opinionated** | Firme, com posicao clara | "Por que seu chat corporativo e um risco que voce ignora" | Devs engajados, comunidade tech |
| **Radical** | Sem filtro, filosofico | "O estado nao protege sua privacidade — ele e a ameaca" | Comunidade cypherpunk, libertarianistas |

A home page e o portfolio mostram a versao profissional. Posts acessiveis funcionam como porta de entrada. Quem se interessa vai mais fundo naturalmente.

## 19 Temas — O Universo da Persona

### 1. Soberania Individual
- Propriedade de si mesmo — seus dados, suas chaves, seu corpo, suas decisoes
- Self-custody como principio (nao so Bitcoin — tudo)
- Por que delegar e abdicar: de cloud a governo
- "Se voce nao controla, voce nao possui"
- **TI:** self-hosting, local-first software, PGP, chaves privadas, backups offline

### 2. Privacidade como Direito Natural
- Privacidade nao e ter algo a esconder — e ter algo a proteger
- Vigilancia de massa e incompativel com liberdade
- Metadata mata mais que conteudo
- O panoptico digital — como voce e vigiado sem saber
- Threat modeling pessoal — de quem voce se protege?
- **TI:** Signal, SimpleX, Matrix, Tor, VPN, DNS over HTTPS, compartimentalizacao digital

### 3. Estado como Ameaca
- Governo nao protege — ele e o risco
- Regulacao como controle disfarcado de protecao
- Impostos como extorsao sistematizada
- CBDCs — o dinheiro programavel que te programa
- Identificacao digital obrigatoria — o que pode dar errado (tudo)
- Compliance como submissao voluntaria
- KYC/AML — vigilancia financeira normalizada
- **TI:** censorship-resistant tech, redes descentralizadas, Nostr vs plataformas reguladas

### 4. Dinheiro Soberano
- Bitcoin como opt-out do sistema financeiro
- Self-custody de Bitcoin — not your keys, not your coins
- Lightning Network na pratica
- Economia austriaca — Mises, Hayek, Rothbard (o basico que ninguem ensina)
- Por que inflacao e roubo silencioso
- Agorismo e contra-economia — trocas voluntarias fora do estado
- Moeda fiduciaria como ferramenta de controle
- **TI:** wallets, nodes, Lightning dev, privacidade em transacoes, Monero vs Bitcoin

### 5. Criptografia como Arma Politica
- Cypherpunk Manifesto — criptografia como ato de resistencia
- As crypto wars — quando o governo tentou proibir criptografia
- E2E como padrao moral, nao feature
- Zero-knowledge proofs — provar sem revelar
- Por que backdoors "so para o bem" nao existem
- **TI:** GPG/PGP, curvas elipticas, protocolos, libraries, implementacao pratica

### 6. Codigo Aberto como Transparencia
- Se voce nao pode auditar, voce nao pode confiar
- Open source vs "source available" — a diferenca importa
- Closed source como caixa preta de poder
- Seguranca por obscuridade e mentira
- Software livre como movimento de soberania
- **TI:** contribuir pra OSS, manter projetos, licensing, auditar dependencias

### 7. Descentralizacao
- Single points of failure sao single points of control
- Protocolos > plataformas (sempre)
- Federacao vs descentralizacao total
- Por que a web virou 5 empresas e como reverter
- DNS como ponto de censura — alternativas
- **TI:** Nostr, ActivityPub, IPFS, mesh networks, arquitetura P2P, Tor hidden services

### 8. Anti-Vigilancia Corporativa
- Big Tech como braco do estado (e vice-versa)
- Data brokers — quem vende seus dados e pra quem
- O modelo de negocio da vigilancia — como "gratis" e pago
- Google, Meta, Apple — diferentes sabores do mesmo controle
- Terms of Service como contratos de adesao abusivos
- **TI:** degoogle, alternativas self-hosted, GrapheneOS, Firefox hardening, uBlock, DNS sinkhole

### 9. Comunicacao Segura
- OPSEC pessoal — nao e paranoia se estao realmente olhando
- Compartimentalizacao de identidades
- Threat models — ativista vs dev vs pessoa normal
- Whistleblowing e a protecao de quem fala a verdade
- Snowden, Assange, Manning — herois ou traidores (herois)
- **TI:** Signal, SimpleX, Matrix, Briar, Tor, Tails, air-gapped machines, PGP workflow

### 10. Inteligencia Artificial & Controle
- AI como ferramenta de vigilancia vs ferramenta de libertacao
- LLMs na cloud = seus dados treinando o modelo de outra empresa
- Modelos locais como soberania cognitiva
- Vies algoritmico como censura automatizada
- O risco de AI centralizada em maos de poucos
- **TI:** LLMs locais (Ollama, llama.cpp), n8n + AI, modelos open source, fine-tuning local

### 11. Infraestrutura Pessoal / Self-Hosting
- Dependencia zero de terceiros e o objetivo
- Sua infra, suas regras
- O trade-off real: conveniencia vs controle
- Cloud e so o computador de outra pessoa
- Quando NAO vale self-hosear (honestidade pragmatica)
- **TI:** nginx, Tor, Docker, Tailscale, Wireguard, backup strategy, homelab

### 12. Linux & Filosofia Unix
- O computador e seu — aja como dono
- Unix philosophy: fazer uma coisa bem feita
- Terminal como interface soberana
- Minimalismo digital — menos software, menos superficie de ataque
- **TI:** dotfiles, shell scripting, window managers, distros, hardening

### 13. Liberdade de Expressao
- Free speech absolutismo — incluindo o que voce discorda
- Plataformas como pracas publicas que baniram a fala
- Deplatforming como censura com extra steps
- Protocolos anticensura — publicar sem permissao
- **TI:** Nostr, blogs self-hosted, RSS, publicacao sem intermediarios, Hugo como CMS soberano

### 14. Educacao e Pensamento Critico
- Escola como fabrica de obediencia
- Aprender sozinho como ato de soberania intelectual
- Learning in public — transparencia no processo
- Livros que formam o pensamento (Mises, Rothbard, Hoppe, Taleb, Stallman)
- **TI:** a jornada de dev a tech lead, aprender em publico, compartilhar conhecimento sem gatekeeping

### 15. Resiliencia & Preparacao
- Sistemas frageis quebram — esteja pronto
- Antifragilidade (Taleb) aplicada a vida digital
- Backup e o minimo — disaster recovery pessoal
- Off-grid digital: o que funciona quando a internet cai?
- **TI:** backups, redundancia, mesh networks, radio, offline-first

### 16. Automacao como Libertacao
- Automatizar o tedioso pra ter tempo pro que importa
- Automacao pessoal vs automacao corporativa de controle
- "Automate the boring. Own the critical."
- **TI:** n8n, scripts, workflows, CI/CD pessoal, automacao de infra

### 17. Trabalho & Lideranca (pelo POV libertario)
- Liderar sem autoritarismo — autonomia das pessoas
- Hierarquia voluntaria vs hierarquia imposta
- Remote work como liberdade geografica
- Por que a cultura de empresa e engenharia social
- Tech lead como facilitador, nao chefe
- **TI:** gestao de equipes, 1:1s, feedback, decision-making, cultura de engenharia

### 18. OPSEC — Seguranca Operacional
- Threat modeling como habito — de quem voce se protege e por que
- Compartimentalizacao de identidades digitais
- Separacao de contextos: pessoal, profissional, ativismo, pseudonimos
- Higiene digital diaria — o que fazer e o que nunca fazer
- Superficie de ataque pessoal — como reduzi-la
- Dispositivos dedicados, perfis separados, hardware keys
- OPSEC fisico — o que adianta criptografar tudo se o laptop esta aberto no cafe
- Erros comuns que derrubam anonimato (metadata em fotos, DNS leaks, login cruzado)
- **TI:** Tails, Whonix, Qubes OS, hardware keys (YubiKey), air-gapped machines, VMs compartimentalizadas, gerenciadores de senhas, 2FA hardware-only

### 19. Anonimato
- Anonimato como direito, nao como suspeita
- Identidade real vs pseudonimos — por que voce nao deve nada a ninguem
- O direito de existir online sem ser identificado
- Anonimato vs privacidade — sao coisas diferentes, ambas importam
- KYC como destruicao sistematica do anonimato
- Pseudonimato funcional — reputacao sem identidade (Satoshi, Nostr npubs)
- Doxxing como violencia
- **TI:** Tor, I2P, Nostr com multiplas identidades, e-mail aliases, VPS anonima, pagamento anonimo, metadata stripping, compartimentalizacao de identidades

## Taxonomia Hugo

- **Categorias:** `pessoal`, `profissional`
- **Tags:** baseadas nos 19 temas (privacy, cryptography, bitcoin, self-hosting, n8n, leadership, open-source, anonymity, opsec, decentralization, ai, linux, automation, sovereignty, free-speech, resilience, education, surveillance, state)
- RSS por categoria para quem quiser assinar so uma trilha

## Conteudo Bilingue

- Escrever no idioma mais natural pro tema, traduzir depois
- Ensaios ideologicos provavelmente nascem em pt-BR
- Tutoriais tecnicos provavelmente nascem em en
- Cada post publicado nos dois idiomas

## Integracao com o Site Atual

- Portfolio continua separado (projetos, stack, links)
- Paginas especiais existentes (canary, pgp, mirrors, integrity) ja se conectam naturalmente com os temas
- About page pode referenciar os pilares de conteudo
- RSS por categoria (pessoal / profissional)
