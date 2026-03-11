---
title: "n8n Nodes Brasil Hub"
date: 2026-03-11
description: "Community node para n8n que consulta dados publicos brasileiros (CNPJ, CEP) com fallback multi-provider."
category: "open-source"
status: "active"
stack: ["TypeScript", "n8n", "Node.js"]
tags: ["n8n", "api", "brasil", "automacao", "open-source"]
links:
  Source: "https://github.com/luisbarcia/n8n-nodes-brasil-hub"
  npm: "https://www.npmjs.com/package/n8n-nodes-brasil-hub"
---

## Overview

Community node para n8n que unifica consultas a dados publicos brasileiros — CNPJ, CEP e mais — com sistema de fallback multi-provider. Cada recurso tem multiplos provedores configurados: se um falha ou atinge rate limit, o proximo assume automaticamente.

## Funcionalidades

- **CNPJ**: consulta e validacao com fallback entre provedores publicos
- **CEP**: busca de endereco com fallback automatico
- **Multi-provider fallback**: resiliencia entre provedores sem configuracao manual
- **Output normalizado**: mesma estrutura de resposta independente do provedor usado
- **Zero credenciais**: funciona apenas com APIs publicas, sem necessidade de tokens
- **Compativel com AI Agents**: funciona como tool em workflows de agentes n8n

## Roadmap

- CPF, DDD, bancos, tabela FIPE, feriados nacionais
- Retry com exponential backoff
- Mensagens de erro aprimoradas com contexto do provedor
