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

Plataforma de cobranca automatizada para a UUBA Tech. PMEs brasileiras perdem receita por falta de processo de cobranca estruturado — dependem de planilhas, ligacoes manuais e nao fazem follow-up sistematico. O UUBA Recebe resolve isso com um bot de IA que conversa pelo WhatsApp usando tecnicas de economia comportamental e escala para atendente humano quando necessario.

## Protocolo de cobranca

O bot segue um protocolo de 7 etapas baseado em economia comportamental. Comeca com lembrete antes do vencimento e sobe o tom gradualmente ate consequencias contratuais. Cada etapa aplica uma tecnica diferente para maximizar a recuperacao sem intervenção humana. Quando nao resolve, escala para atendente.

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
