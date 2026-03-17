---
title: "UUBA Recebe"
date: 2026-03-17
description: "Plataforma de cobranca para PMEs brasileiras. Bot de IA cobra pelo WhatsApp com protocolo comportamental de 7 etapas e escala para atendente humano."
category: "professional"
status: "active"
stack: ["Python", "FastAPI", "PostgreSQL", "Claude AI", "n8n", "Evolution API", "Chatwoot", "Docker"]
tags: ["cobranca", "ia-conversacional", "whatsapp", "fastapi", "automacao", "fintech"]
links:
  Site: "https://uuba.tech"
  Produto: "https://luisbarcia.github.io/uuba-tech/produtos/"
---

## Overview

Construi o UUBA Recebe como CTO da UUBA Tech. O problema e simples: PMEs brasileiras perdem receita porque cobrar eh chato e ninguem faz direito. Planilha, ligacao manual, zero follow-up. Entao fiz um bot de IA que cobra pelo WhatsApp usando tecnicas de economia comportamental, e escala para um atendente humano quando precisa.

## Protocolo de cobranca

O bot segue 7 etapas ao longo de 15+ dias, cada uma subindo o tom:

1. D-3: Lembrete preventivo antes do vencimento
2. D+1: Tom neutro, link direto de pagamento
3. D+3: Intencoes de implementacao, pergunta "qual dia voce costuma resolver pagamentos?"
4. D+5: Prova social, "clientes do seu setor estao em dia este mes"
5. D+7: Aversao a perda, beneficios especiais em risco
6. D+10: Historico de pagamento em jogo
7. D+15: Consequencias contratuais

Em qualquer etapa, o bot pede confirmacao por escrito ("confirme com ok") para ativar o vies de consistencia. Se precisar de desconto acima de 10%, escala para humano.

## Arquitetura

Cliente recebe mensagem no WhatsApp via Evolution API (self-hosted). Isso dispara webhook para n8n, que roda o bot com Claude Sonnet 4. O bot tem 4 tools para consultar e atualizar dados na API. Quando nao consegue resolver, a conversa migra para o Chatwoot e um atendente humano assume.

```
WhatsApp → Evolution API → n8n → Claude Sonnet → UUBA API (FastAPI)
                                                → Chatwoot (escalacao humana)
```

## Stack

| Camada | Tecnologia |
|--------|-----------|
| Backend | Python, FastAPI, PostgreSQL 16 (pgvector), SQLAlchemy 2.0 async |
| Bot IA | Claude Sonnet 4 (Anthropic) via n8n, memoria por cliente, 4 tools |
| Messaging | Evolution API v2.3.7 (self-hosted) |
| Atendimento | Chatwoot (open-source, integrado ao WhatsApp) |
| Automacao | n8n (self-hosted) |
| Infra | 2x VPS (Contabo + Hostinger), Docker Compose, Nginx, Let's Encrypt |
| CI/CD | GitHub Actions (lint + testes + Docker build) |
| Seguranca | API Key auth com timing-safe comparison, state machine de faturas, prompt hardened contra injection |

## Numeros

- 14 endpoints REST
- 174 testes automatizados (unit, integration, security, data integrity)
- 15 containers Docker em producao
- 5 dominios com SSL automatico
- Protocolo comportamental de 7 etapas
- Bot opera 8h-20h dias uteis, 9h-14h sabados
