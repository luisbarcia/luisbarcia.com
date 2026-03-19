---
title: "n8n Nodes Brasil Hub"
date: 2026-03-19
description: "Community node para n8n que consulta e valida dados publicos brasileiros (CNPJ, CEP, CPF, Banks, DDD, FIPE, Holiday, IBGE, NCM) com fallback multi-provider."
category: "open-source"
status: "active"
stack: ["TypeScript", "n8n", "Node.js"]
tags: ["n8n", "api", "brasil", "automacao", "open-source"]
links:
  Source: "https://github.com/luisbarcia/n8n-nodes-brasil-hub"
  npm: "https://www.npmjs.com/package/n8n-nodes-brasil-hub"
---

## Overview

Community node para n8n que unifica consultas e validacoes de dados publicos brasileiros — CNPJ, CEP, CPF, Banks, DDD, FIPE, Holiday, IBGE e NCM — com sistema de fallback multi-provider. Cada recurso tem multiplos provedores configurados: se um falha ou atinge rate limit, o proximo assume automaticamente. Sao 9 recursos, 17 operacoes e 22 provedores em um unico node.

## Operacoes

| Recurso | Operacao | Descricao | Provedores |
|---------|----------|-----------|------------|
| **Bank** | Query | Busca dados de banco por codigo COMPE | BrasilAPI, BancosBrasileiros |
| **Bank** | List | Lista todos os bancos brasileiros (485+) | BrasilAPI, BancosBrasileiros |
| **CEP** | Query | Busca endereco por numero de CEP | BrasilAPI, ViaCEP, OpenCEP, ApiCEP |
| **CEP** | Validate | Valida formato do CEP (local, sem API) | — |
| **CNPJ** | Query | Busca dados de empresa por CNPJ | BrasilAPI, CNPJ.ws, ReceitaWS, MinhaReceita, OpenCNPJ.org, OpenCNPJ.com, CNPJA |
| **CNPJ** | Validate | Valida CNPJ por checksum (local, sem API) | — |
| **CPF** | Validate | Valida CPF pelo algoritmo Modulo 11 (local, sem API) | — |
| **DDD** | Query | Busca estado e cidades por codigo de area | BrasilAPI, municipios-brasileiros |
| **Holiday** | Query | Lista feriados nacionais por ano (1900-2199) | BrasilAPI, Nager.Date |
| **FIPE** | Brands | Lista marcas de veiculos por tipo | parallelum |
| **FIPE** | Models | Lista modelos de uma marca | parallelum |
| **FIPE** | Years | Lista anos disponiveis de um modelo | parallelum |
| **FIPE** | Price | Busca preco da tabela FIPE | parallelum |
| **IBGE** | States | Lista todos os 27 estados com info de regiao | BrasilAPI, IBGE API oficial |
| **IBGE** | Cities | Lista municipios de um estado por UF | BrasilAPI, IBGE API oficial |
| **NCM** | Query | Busca detalhes de classificacao fiscal por codigo NCM | BrasilAPI |
| **NCM** | Search | Busca codigos NCM por descricao (keyword) | BrasilAPI |

## Diferenciais

- **Multi-provider fallback**: ate 7 provedores por recurso com failover automatico
- **Output normalizado**: mesma estrutura de resposta independente do provedor usado
- **Zero credenciais**: funciona apenas com APIs publicas, sem necessidade de tokens
- **Validacao offline**: CPF, CNPJ e CEP validados localmente por checksum
- **Compativel com AI Agents**: funciona como tool em workflows de agentes n8n
- **1.180 testes, 99%+ coverage**: adversarial attack tests (type confusion, null/undefined, unicode injection, path traversal, SSRF)
- **Zero runtime dependencies**: apenas `n8n-workflow` como peerDependency
- **Configurable provider order**: escolha qual provedor tentar primeiro por recurso
- **Rate limit awareness**: detecta HTTP 429, pula para proximo provedor automaticamente
- **Configurable timeout**: 1s-60s por request, default 10s
- **CNPJ AI Summary**: output mode com 8 campos flat em ingles, otimizado para AI Agents
- **npm provenance + build attestation**: supply chain verificavel
- **Error type safety**: guards `instanceof` em vez de casts inseguros, `Number.isFinite()` contra NaN/Infinity

## Roadmap

- PIX Directory, CNES, Historical FIPE, Correios Tracking
