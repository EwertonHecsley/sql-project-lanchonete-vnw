# 🍔 Lanchonete VNW — Projeto de Banco de Dados

<p align="center">
  <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL"/>
  <img src="https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=amazon-rds&logoColor=white" alt="SQL"/>
  <img src="https://img.shields.io/badge/Status-Concluído-brightgreen?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/Licença-MIT-yellow?style=for-the-badge" alt="Licença"/>
</p>

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Problema que Resolve](#-problema-que-resolve)
- [Solução Proposta](#-solução-proposta)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Estrutura do Banco de Dados](#-estrutura-do-banco-de-dados)
  - [Tabela: clientes](#tabela-clientes)
  - [Tabela: categorias](#tabela-categorias)
  - [Tabela: produtos](#tabela-produtos)
  - [Tabela: pedidos](#tabela-pedidos)
  - [Tabela: itens_pedido](#tabela-itens_pedido)
- [Relacionamentos](#-relacionamentos)
- [Regras de Negócio](#-regras-de-negócio)
- [Como Executar o Projeto](#-como-executar-o-projeto)
  - [Pré-requisitos](#pré-requisitos)
  - [Configuração do Banco de Dados](#configuração-do-banco-de-dados)
  - [Rodando as Migrations](#rodando-as-migrations)
  - [Rodando o Seed](#rodando-o-seed)
  - [Executando as Queries](#executando-as-queries)
- [Exemplos de Consultas SQL](#-exemplos-de-consultas-sql)
- [Melhorias Futuras](#-melhorias-futuras)
- [Autor](#-autor)

---

## 🌐 Visão Geral

O **Lanchonete VNW** é um projeto de modelagem e implementação de banco de dados relacional desenvolvido para gerenciar as operações de uma lanchonete de pequeno porte. O projeto cobre desde o cadastro de clientes e produtos até o controle completo de pedidos, itens e formas de pagamento, tudo com foco em **integridade referencial**, **organização dos dados** e **facilidade de consulta**.

Este projeto foi desenvolvido como parte de um estudo prático em **SQL e modelagem relacional**, utilizando **PostgreSQL** como sistema de gerenciamento de banco de dados.

---

## 🚨 Problema que Resolve

Antes da implementação deste sistema, a lanchonete realizava o controle de pedidos, clientes e produtos de forma **totalmente manual**, utilizando um caderno para anotar as informações. Esse processo gerava diversos problemas:

- ❌ **Perda de informações** — dados de clientes e pedidos podiam ser extraviados ou ilegíveis.
- ❌ **Falta de rastreabilidade** — era impossível saber o histórico completo de um cliente ou produto.
- ❌ **Dificuldade de análise** — sem dados estruturados, não havia como gerar relatórios de vendas, produtos mais vendidos ou clientes frequentes.
- ❌ **Erros nos pedidos** — a ausência de validação permitia inconsistências, como preços negativos ou quantidades zeradas.
- ❌ **Escalabilidade limitada** — à medida que o negócio cresceu, o caderno tornou-se inviável para suportar o volume de operações.

---

## ✅ Solução Proposta

A solução foi modelar um banco de dados relacional completo utilizando **PostgreSQL**, estruturado para atender às necessidades operacionais da lanchonete com:

- 📦 **Cadastro organizado** de clientes, categorias e produtos.
- 🛒 **Controle de pedidos** com suporte a diferentes tipos de entrega e formas de pagamento.
- 📋 **Itens de pedido** vinculados a produtos, com controle de quantidade, preço unitário e subtotal.
- 🔒 **Integridade dos dados** por meio de constraints (`NOT NULL`, `CHECK`, `UNIQUE`, `FOREIGN KEY`).
- 📊 **Consultas analíticas** para geração de relatórios, rankings e validações.

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia   | Descrição                                                      |
|--------------|----------------------------------------------------------------|
| **PostgreSQL** | Sistema de Gerenciamento de Banco de Dados Relacional (SGBD) |
| **SQL**        | Linguagem de consulta e manipulação de dados                 |
| **Docker** *(opcional)* | Containerização do banco de dados para ambiente isolado |

---

## 📁 Estrutura de Pastas

```
lanchonete-vnw/
│
├── database/
│   ├── migrations/
│   │   ├── 001_create_clientes.sql       # Criação da tabela de clientes
│   │   ├── 002_create_categorias.sql     # Criação da tabela de categorias
│   │   ├── 003_create_produtos.sql       # Criação da tabela de produtos
│   │   ├── 004_create_pedidos.sql        # Criação da tabela de pedidos
│   │   └── 005_create_itens_pedido.sql   # Criação da tabela de itens do pedido
│   │
│   ├── seeds/
│   │   └── seed.sql                      # Dados iniciais para popular o banco
│   │
│   └── queries/
│       └── queries.sql                   # Consultas SQL de análise e relatórios
│
└── README.md
```

> **Nota:** A ordem das migrations deve ser respeitada, pois existem dependências entre as tabelas (chaves estrangeiras).

---

## 🗃️ Estrutura do Banco de Dados

### Tabela: `clientes`

Armazena os dados cadastrais dos clientes da lanchonete.

```sql
CREATE TABLE clientes (
    id           SERIAL PRIMARY KEY,
    nome         VARCHAR(100)  NOT NULL,
    email        VARCHAR(100),
    telefone     VARCHAR(20)   NOT NULL,
    endereco     VARCHAR(200)  NOT NULL,
    data_criacao TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);
```

| Coluna        | Tipo           | Descrição                              |
|---------------|----------------|----------------------------------------|
| `id`          | SERIAL         | Identificador único do cliente         |
| `nome`        | VARCHAR(100)   | Nome completo do cliente               |
| `email`       | VARCHAR(100)   | E-mail do cliente (opcional)           |
| `telefone`    | VARCHAR(20)    | Telefone de contato (obrigatório)      |
| `endereco`    | VARCHAR(200)   | Endereço completo (obrigatório)        |
| `data_criacao`| TIMESTAMP      | Data e hora do cadastro                |

---

### Tabela: `categorias`

Organiza os produtos por categoria (ex.: Lanches, Bebidas, Sobremesas).

```sql
CREATE TABLE categorias (
    id           SERIAL PRIMARY KEY,
    nome         VARCHAR(50) NOT NULL UNIQUE,
    descricao    TEXT,
    data_criacao TIMESTAMP  DEFAULT CURRENT_TIMESTAMP
);
```

| Coluna        | Tipo        | Descrição                             |
|---------------|-------------|---------------------------------------|
| `id`          | SERIAL      | Identificador único da categoria      |
| `nome`        | VARCHAR(50) | Nome da categoria (único)             |
| `descricao`   | TEXT        | Descrição detalhada da categoria      |
| `data_criacao`| TIMESTAMP   | Data e hora do cadastro               |

---

### Tabela: `produtos`

Contém o catálogo de produtos disponíveis na lanchonete.

```sql
CREATE TABLE produtos (
    id           SERIAL PRIMARY KEY,
    nome         VARCHAR(100)   NOT NULL,
    descricao    TEXT,
    preco        DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    categoria_id INTEGER        NOT NULL,
    disponivel   BOOLEAN        DEFAULT TRUE,
    data_criacao TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);
```

| Coluna        | Tipo           | Descrição                                  |
|---------------|----------------|--------------------------------------------|
| `id`          | SERIAL         | Identificador único do produto             |
| `nome`        | VARCHAR(100)   | Nome do produto                            |
| `descricao`   | TEXT           | Descrição do produto                       |
| `preco`       | DECIMAL(10,2)  | Preço do produto (deve ser ≥ 0)            |
| `categoria_id`| INTEGER        | Referência à categoria do produto (FK)     |
| `disponivel`  | BOOLEAN        | Indica se o produto está disponível        |
| `data_criacao`| TIMESTAMP      | Data e hora do cadastro                    |

---

### Tabela: `pedidos`

Registra todos os pedidos realizados pelos clientes, com suporte a múltiplos status, tipos de entrega e formas de pagamento.

```sql
CREATE TABLE pedidos (
    id              SERIAL PRIMARY KEY,
    cliente_id      INTEGER       NOT NULL,
    data_pedido     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    status          VARCHAR(30)   NOT NULL CHECK (status IN ('recebido', 'em_preparo', 'pronto', 'entregue', 'cancelado')),
    tipo_entrega    VARCHAR(20)   NOT NULL CHECK (tipo_entrega IN ('retirada', 'entrega', 'consumo_local')),
    forma_pagamento VARCHAR(20)   NOT NULL CHECK (forma_pagamento IN ('dinheiro', 'cartao_debito', 'cartao_credito', 'pix')),
    observacoes     TEXT,
    total           NUMERIC(10,2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

| Coluna           | Tipo          | Descrição                                                                 |
|------------------|---------------|---------------------------------------------------------------------------|
| `id`             | SERIAL        | Identificador único do pedido                                             |
| `cliente_id`     | INTEGER       | Referência ao cliente que realizou o pedido (FK)                         |
| `data_pedido`    | TIMESTAMP     | Data e hora do pedido                                                     |
| `status`         | VARCHAR(30)   | Status do pedido: `recebido`, `em_preparo`, `pronto`, `entregue`, `cancelado` |
| `tipo_entrega`   | VARCHAR(20)   | Tipo: `retirada`, `entrega` ou `consumo_local`                           |
| `forma_pagamento`| VARCHAR(20)   | Forma de pagamento: `dinheiro`, `cartao_debito`, `cartao_credito`, `pix` |
| `observacoes`    | TEXT          | Observações adicionais do pedido                                          |
| `total`          | NUMERIC(10,2) | Valor total do pedido (deve ser ≥ 0)                                      |

---

### Tabela: `itens_pedido`

Detalha os produtos incluídos em cada pedido, com quantidade, preço unitário e subtotal.

```sql
CREATE TABLE itens_pedido (
    id             SERIAL PRIMARY KEY,
    pedido_id      INTEGER        NOT NULL,
    produto_id     INTEGER        NOT NULL,
    quantidade     INTEGER        NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10, 2) NOT NULL CHECK (preco_unitario >= 0),
    subtotal       NUMERIC(10, 2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (pedido_id)  REFERENCES pedidos(id)  ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);
```

| Coluna           | Tipo          | Descrição                                            |
|------------------|---------------|------------------------------------------------------|
| `id`             | SERIAL        | Identificador único do item                          |
| `pedido_id`      | INTEGER       | Referência ao pedido (FK, CASCADE ao deletar)        |
| `produto_id`     | INTEGER       | Referência ao produto (FK)                           |
| `quantidade`     | INTEGER       | Quantidade do produto no item (deve ser > 0)         |
| `preco_unitario` | NUMERIC(10,2) | Preço do produto no momento do pedido                |
| `subtotal`       | NUMERIC(10,2) | Valor total do item (quantidade × preço_unitario)    |

---

## 🔗 Relacionamentos

O diagrama abaixo representa os relacionamentos entre as entidades do banco de dados:

```
clientes ──────────────< pedidos >──────────────< itens_pedido >────────── produtos
                                                                                │
categorias ─────────────────────────────────────────────────────────────────< produtos
```

| Relacionamento                     | Cardinalidade | Descrição                                                        |
|------------------------------------|---------------|------------------------------------------------------------------|
| `clientes` → `pedidos`             | 1 : N         | Um cliente pode ter vários pedidos                              |
| `categorias` → `produtos`          | 1 : N         | Uma categoria pode conter vários produtos                       |
| `pedidos` → `itens_pedido`         | 1 : N         | Um pedido pode ter vários itens                                 |
| `produtos` → `itens_pedido`        | 1 : N         | Um produto pode aparecer em vários itens de pedido              |

---

## 📐 Regras de Negócio

As regras de negócio estão implementadas diretamente no banco de dados por meio de constraints:

1. **Preço do produto** deve ser maior ou igual a zero (`CHECK (preco >= 0)`).
2. **Status do pedido** deve ser um dos valores: `recebido`, `em_preparo`, `pronto`, `entregue` ou `cancelado`.
3. **Tipo de entrega** deve ser: `retirada`, `entrega` ou `consumo_local`.
4. **Forma de pagamento** deve ser: `dinheiro`, `cartao_debito`, `cartao_credito` ou `pix`.
5. **Quantidade** de itens em um pedido deve ser maior que zero (`CHECK (quantidade > 0)`).
6. **Subtotal** e **total** devem ser maiores ou iguais a zero.
7. **Nome da categoria** deve ser único (`UNIQUE`).
8. Ao **excluir um pedido**, todos os itens associados são removidos automaticamente (`ON DELETE CASCADE`).
9. Os campos `nome`, `telefone` e `endereco` do cliente são **obrigatórios** (`NOT NULL`).
10. O campo `preco` do produto e o `total` do pedido são **obrigatórios** e não permitem valores negativos.

---

## 🚀 Como Executar o Projeto

### Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

- [PostgreSQL](https://www.postgresql.org/download/) (versão 13 ou superior) **OU**
- [Docker](https://www.docker.com/) e [Docker Compose](https://docs.docker.com/compose/) (para ambiente containerizado)
- Um cliente SQL de sua preferência: [psql](https://www.postgresql.org/docs/current/app-psql.html), [DBeaver](https://dbeaver.io/), [pgAdmin](https://www.pgadmin.org/) etc.

---

### Configuração do Banco de Dados

#### Opção 1 — PostgreSQL local

Acesse o terminal e conecte-se ao PostgreSQL:

```bash
psql -U postgres
```

Em seguida, crie o banco de dados:

```sql
CREATE DATABASE lanchonete_vnw;
\c lanchonete_vnw
```

#### Opção 2 — Docker Compose

Se preferir utilizar Docker, crie um arquivo `docker-compose.yml` na raiz do projeto:

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    container_name: lanchonete_postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: lanchonete_vnw
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

Suba o container:

```bash
docker-compose up -d
```

Conecte-se ao banco:

```bash
psql -h localhost -U postgres -d lanchonete_vnw
```

---

### Rodando as Migrations

As migrations devem ser executadas **na ordem numérica**, pois há dependências entre as tabelas.

```bash
psql -h localhost -U postgres -d lanchonete_vnw -f database/migrations/001_create_clientes.sql
psql -h localhost -U postgres -d lanchonete_vnw -f database/migrations/002_create_categorias.sql
psql -h localhost -U postgres -d lanchonete_vnw -f database/migrations/003_create_produtos.sql
psql -h localhost -U postgres -d lanchonete_vnw -f database/migrations/004_create_pedidos.sql
psql -h localhost -U postgres -d lanchonete_vnw -f database/migrations/005_create_itens_pedido.sql
```

> ⚠️ **Atenção:** Não altere a ordem de execução. A tabela `produtos` depende de `categorias`, e `pedidos` depende de `clientes`.

---

### Rodando o Seed

Após rodar todas as migrations, popule o banco com os dados iniciais:

```bash
psql -h localhost -U postgres -d lanchonete_vnw -f database/seeds/seed.sql
```

O arquivo `seed.sql` insere:

- ✅ Categorias de produtos (Lanches, Bebidas, Sobremesas, etc.)
- ✅ Produtos variados com preços e categorias
- ✅ 3 clientes cadastrados
- ✅ Pedidos com diferentes tipos de entrega (`retirada`, `entrega`, `consumo_local`)
- ✅ Itens de pedido com quantidade, preço unitário e subtotal

---

### Executando as Queries

Para executar as consultas de análise e relatórios:

```bash
psql -h localhost -U postgres -d lanchonete_vnw -f database/queries/queries.sql
```

Ou abra o arquivo `queries.sql` no seu cliente SQL preferido e execute as consultas manualmente, selecionando as que desejar analisar.

---

## 💡 Exemplos de Consultas SQL

Abaixo estão alguns exemplos das consultas disponíveis no arquivo `queries.sql`:

### Listagem simples de clientes

```sql
SELECT id, nome, email, telefone
FROM clientes
ORDER BY nome;
```

### Produtos disponíveis com categoria

```sql
SELECT p.nome AS produto, p.preco, c.nome AS categoria
FROM produtos p
JOIN categorias c ON c.id = p.categoria_id
WHERE p.disponivel = TRUE
ORDER BY c.nome, p.nome;
```

### Pedidos de um cliente específico com status

```sql
SELECT pe.id, pe.data_pedido, pe.status, pe.tipo_entrega, pe.forma_pagamento, pe.total
FROM pedidos pe
JOIN clientes cl ON cl.id = pe.cliente_id
WHERE cl.nome = 'Nome do Cliente'
ORDER BY pe.data_pedido DESC;
```

### Total gasto por cliente

```sql
SELECT cl.nome, COUNT(pe.id) AS total_pedidos, SUM(pe.total) AS valor_total
FROM clientes cl
JOIN pedidos pe ON pe.cliente_id = cl.id
GROUP BY cl.nome
ORDER BY valor_total DESC;
```

### Produtos mais vendidos (ranking)

```sql
SELECT pr.nome AS produto, SUM(ip.quantidade) AS total_vendido
FROM itens_pedido ip
JOIN produtos pr ON pr.id = ip.produto_id
GROUP BY pr.nome
ORDER BY total_vendido DESC
LIMIT 10;
```

### Receita por categoria

```sql
SELECT c.nome AS categoria, SUM(ip.subtotal) AS receita_total
FROM itens_pedido ip
JOIN produtos p ON p.id = ip.produto_id
JOIN categorias c ON c.id = p.categoria_id
GROUP BY c.nome
ORDER BY receita_total DESC;
```

### Pedidos por forma de pagamento

```sql
SELECT forma_pagamento, COUNT(*) AS quantidade, SUM(total) AS total_arrecadado
FROM pedidos
GROUP BY forma_pagamento
ORDER BY total_arrecadado DESC;
```

### Validação de consistência (subtotal vs quantidade × preço)

```sql
SELECT id, pedido_id, produto_id, quantidade, preco_unitario, subtotal,
       (quantidade * preco_unitario) AS subtotal_esperado,
       subtotal - (quantidade * preco_unitario) AS diferenca
FROM itens_pedido
WHERE subtotal <> (quantidade * preco_unitario);
```

### Pedidos por período (consulta temporal)

```sql
SELECT DATE(data_pedido) AS data, COUNT(*) AS total_pedidos, SUM(total) AS faturamento
FROM pedidos
WHERE data_pedido BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY DATE(data_pedido)
ORDER BY data;
```

### Ranking de clientes mais frequentes

```sql
SELECT cl.nome, COUNT(pe.id) AS total_pedidos
FROM clientes cl
JOIN pedidos pe ON pe.cliente_id = cl.id
GROUP BY cl.nome
ORDER BY total_pedidos DESC;
```

---

## 🔮 Melhorias Futuras

O projeto foi desenvolvido com uma base sólida, e há diversas possibilidades de expansão:

- [ ] **Triggers automáticos** — calcular o `total` do pedido automaticamente com base nos `itens_pedido`.
- [ ] **Histórico de alterações** — criar tabela de auditoria para registrar mudanças de status nos pedidos.
- [ ] **Módulo de funcionários** — tabela para registrar os atendentes responsáveis por cada pedido.
- [ ] **Controle de estoque** — gerenciar a quantidade disponível de cada produto.
- [ ] **Relatórios avançados** — views e funções SQL para simplificar consultas frequentes.
- [ ] **Integração com API** — conectar o banco a uma API REST (Node.js, FastAPI, etc.) para servir um front-end.
- [ ] **Cupons e descontos** — módulo para aplicar promoções e descontos nos pedidos.
- [ ] **Avaliações de pedidos** — permitir que clientes avaliem os pedidos realizados.
- [ ] **Índices de performance** — adicionar índices nas colunas mais consultadas para otimizar queries.

---

## 👨‍💻 Autor

<table>
  <tr>
    <td align="center">
      <b>Ewerton Hecsley</b><br/>
      <a href="https://github.com/EwertonHecsley">GitHub</a> •
      <a href="https://next-portfolio-2-0-pearl.vercel.app/">Portfólio</a>
    </td>
  </tr>
</table>

---

<p align="center">
  Feito com ❤️ e muito SQL por <strong>Ewerton Hecsley</strong>
</p>
