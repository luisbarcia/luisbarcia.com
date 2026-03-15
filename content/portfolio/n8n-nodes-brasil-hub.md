---
title: "n8n Nodes Brasil Hub"
date: 2026-03-11
description: "Community node para n8n que consulta e valida dados publicos brasileiros (CNPJ, CEP, CPF, Banks, DDD) com fallback multi-provider."
category: "open-source"
status: "active"
stack: ["TypeScript", "n8n", "Node.js"]
tags: ["n8n", "api", "brasil", "automacao", "open-source"]
links:
  Source: "https://github.com/luisbarcia/n8n-nodes-brasil-hub"
  npm: "https://www.npmjs.com/package/n8n-nodes-brasil-hub"
---

## Overview

Community node para n8n que unifica consultas e validacoes de dados publicos brasileiros — CNPJ, CEP, CPF, Banks e DDD — com sistema de fallback multi-provider. Cada recurso tem multiplos provedores configurados: se um falha ou atinge rate limit, o proximo assume automaticamente.

## Operacoes

| Recurso | Operacao | Descricao | Provedores |
|---------|----------|-----------|------------|
| **Bank** | Query | Busca dados de banco por codigo COMPE | BrasilAPI, BancosBrasileiros |
| **Bank** | List | Lista todos os bancos brasileiros (485+) | BrasilAPI, BancosBrasileiros |
| **CEP** | Query | Busca endereco por numero de CEP | BrasilAPI, ViaCEP, OpenCEP |
| **CEP** | Validate | Valida formato do CEP (local, sem API) | — |
| **CNPJ** | Query | Busca dados de empresa por CNPJ | BrasilAPI, CNPJ.ws, ReceitaWS |
| **CNPJ** | Validate | Valida CNPJ por checksum (local, sem API) | — |
| **CPF** | Validate | Valida CPF pelo algoritmo Modulo 11 (local, sem API) | — |
| **DDD** | Query | Busca estado e cidades por codigo de area | BrasilAPI |

## Diferenciais

- **Multi-provider fallback**: ate 3 provedores por recurso com failover automatico
- **Output normalizado**: mesma estrutura de resposta independente do provedor usado
- **Zero credenciais**: funciona apenas com APIs publicas, sem necessidade de tokens
- **Validacao offline**: CPF, CNPJ e CEP validados localmente por checksum
- **Compativel com AI Agents**: funciona como tool em workflows de agentes n8n
- **105 testes, 100% coverage**: statements, branches, functions e lines

## Roadmap

- Tabela FIPE, feriados nacionais
- Retry com exponential backoff
- Novos provedores e recursos
