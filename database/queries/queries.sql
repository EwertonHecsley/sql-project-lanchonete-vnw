-- ========================================
-- CONSULTAS BÁSICAS
-- ========================================

-- Listar todos os clientes
SELECT * FROM clientes;

-- Listar todos os clientes ordenados por nome
SELECT * FROM clientes ORDER BY nome ASC;

-- Listar todas as categorias
SELECT * FROM categorias;

-- Listar todos os produtos
SELECT * FROM produtos;

-- Listar produtos disponíveis
SELECT * FROM produtos WHERE disponivel = TRUE ORDER BY nome ASC;

-- Listar produtos indisponíveis
SELECT * FROM produtos WHERE disponivel = FALSE;

-- Listar todos os pedidos
SELECT * FROM pedidos;

-- Listar todos os itens de pedido
SELECT * FROM itens_pedido;

-- ========================================
-- CONSULTAS COM RELACIONAMENTOS (JOINS)
-- ========================================

-- Listar produtos com suas categorias
SELECT p.id, p.nome AS produto, p.descricao, p.preco, p.disponivel, c.nome AS categoria
FROM produtos p
    JOIN categorias c ON c.id = p.categoria_id
ORDER BY p.nome ASC;

-- Listar pedidos com nome do cliente
SELECT
    p.id AS pedido_id,
    c.nome AS cliente,
    p.data_pedido,
    p.status,
    p.tipo_entrega,
    p.forma_pagamento,
    p.total
FROM pedidos p
    JOIN clientes c ON c.id = p.cliente_id
ORDER BY p.data_pedido DESC;

-- Listar itens de pedido com nome do produto
SELECT ip.id, ip.pedido_id, pr.nome AS produto, ip.quantidade, ip.preco_unitario, ip.subtotal
FROM itens_pedido ip
    JOIN produtos pr ON pr.id = ip.produto_id
ORDER BY ip.pedido_id ASC;

-- Listar itens de pedido com produto e cliente
SELECT
    p.id AS pedido_id,
    c.nome AS cliente,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal
FROM
    itens_pedido ip
    JOIN pedidos p ON p.id = ip.pedido_id
    JOIN clientes c ON c.id = p.cliente_id
    JOIN produtos pr ON pr.id = ip.produto_id
ORDER BY p.id, pr.nome;

-- ========================================
-- FILTROS IMPORTANTES
-- ========================================

-- Buscar cliente pelo nome
SELECT * FROM clientes WHERE nome ILIKE '%joão%';

-- Buscar produtos por faixa de preço
SELECT id, nome, preco
FROM produtos
WHERE
    preco BETWEEN 5.00 AND 15.00
ORDER BY preco ASC;

-- Listar pedidos com status 'recebido'
SELECT * FROM pedidos WHERE status = 'recebido';

-- Listar pedidos com status 'em_preparo'
SELECT * FROM pedidos WHERE status = 'em_preparo';

-- Listar pedidos entregues
SELECT * FROM pedidos WHERE status = 'entregue';

-- Listar pedidos cancelados
SELECT * FROM pedidos WHERE status = 'cancelado';

-- Listar pedidos do tipo entrega
SELECT * FROM pedidos WHERE tipo_entrega = 'entrega';

-- Listar pedidos pagos com pix
SELECT * FROM pedidos WHERE forma_pagamento = 'pix';

-- Listar pedidos feitos por um cliente específico
SELECT p.*
FROM pedidos p
    JOIN clientes c ON c.id = p.cliente_id
WHERE
    c.nome ILIKE '%joão%';

-- ========================================
-- CONSULTAS DE AGREGAÇÃO
-- ========================================

-- Quantidade total de clientes
SELECT COUNT(*) AS total_clientes FROM clientes;

-- Quantidade total de produtos
SELECT COUNT(*) AS total_produtos FROM produtos;

-- Quantidade total de pedidos
SELECT COUNT(*) AS total_pedidos FROM pedidos;

-- Quantidade total de categorias
SELECT COUNT(*) AS total_categorias FROM categorias;

-- Valor total vendido
SELECT SUM(total) AS total_vendido
FROM pedidos
WHERE
    status <> 'cancelado';

-- Ticket médio dos pedidos
SELECT AVG(total) AS ticket_medio
FROM pedidos
WHERE
    status <> 'cancelado';

-- Pedido de maior valor
SELECT MAX(total) AS maior_pedido
FROM pedidos
WHERE
    status <> 'cancelado';

-- Pedido de menor valor
SELECT MIN(total) AS menor_pedido
FROM pedidos
WHERE
    status <> 'cancelado';

-- ========================================
-- RELATÓRIOS POR CLIENTE
-- ========================================

-- Quantidade de pedidos por cliente
SELECT c.id, c.nome, COUNT(p.id) AS total_pedidos
FROM clientes c
    LEFT JOIN pedidos p ON p.cliente_id = c.id
GROUP BY
    c.id,
    c.nome
ORDER BY total_pedidos DESC, c.nome ASC;

-- Total gasto por cliente
SELECT c.id, c.nome, COALESCE(SUM(p.total), 0) AS total_gasto
FROM clientes c
    LEFT JOIN pedidos p ON p.cliente_id = c.id
WHERE
    p.status <> 'cancelado'
    OR p.status IS NULL
GROUP BY
    c.id,
    c.nome
ORDER BY total_gasto DESC;

-- Média de gasto por cliente
SELECT c.id, c.nome, AVG(p.total) AS media_gasto
FROM clientes c
    JOIN pedidos p ON p.cliente_id = c.id
WHERE
    p.status <> 'cancelado'
GROUP BY
    c.id,
    c.nome
ORDER BY media_gasto DESC;

-- Último pedido de cada cliente
SELECT c.nome, MAX(p.data_pedido) AS ultimo_pedido
FROM clientes c
    LEFT JOIN pedidos p ON p.cliente_id = c.id
GROUP BY
    c.nome
ORDER BY ultimo_pedido DESC NULLS LAST;

-- Clientes que nunca fizeram pedidos
SELECT c.id, c.nome
FROM clientes c
    LEFT JOIN pedidos p ON p.cliente_id = c.id
WHERE
    p.id IS NULL;

-- ========================================
-- RELATÓRIOS POR PRODUTO
-- ========================================

-- Listar produtos com categoria
SELECT pr.id, pr.nome AS produto, c.nome AS categoria, pr.preco
FROM produtos pr
    JOIN categorias c ON c.id = pr.categoria_id
ORDER BY c.nome, pr.nome;

-- Quantidade vendida por produto
SELECT pr.id, pr.nome, COALESCE(SUM(ip.quantidade), 0) AS quantidade_vendida
FROM produtos pr
    LEFT JOIN itens_pedido ip ON ip.produto_id = pr.id
GROUP BY
    pr.id,
    pr.nome
ORDER BY quantidade_vendida DESC, pr.nome ASC;

-- Total arrecadado por produto
SELECT pr.id, pr.nome, COALESCE(SUM(ip.subtotal), 0) AS total_arrecadado
FROM produtos pr
    LEFT JOIN itens_pedido ip ON ip.produto_id = pr.id
GROUP BY
    pr.id,
    pr.nome
ORDER BY total_arrecadado DESC, pr.nome ASC;

-- Produto mais vendido
SELECT pr.nome, SUM(ip.quantidade) AS quantidade_vendida
FROM itens_pedido ip
    JOIN produtos pr ON pr.id = ip.produto_id
GROUP BY
    pr.nome
ORDER BY quantidade_vendida DESC
LIMIT 1;

-- Produto menos vendido
SELECT pr.nome, SUM(ip.quantidade) AS quantidade_vendida
FROM itens_pedido ip
    JOIN produtos pr ON pr.id = ip.produto_id
GROUP BY
    pr.nome
ORDER BY quantidade_vendida ASC
LIMIT 1;

-- Produtos que nunca foram pedidos
SELECT pr.id, pr.nome
FROM produtos pr
    LEFT JOIN itens_pedido ip ON ip.produto_id = pr.id
WHERE
    ip.id IS NULL
ORDER BY pr.nome ASC;

-- ========================================
-- RELATÓRIOS POR CATEGORIA
-- ========================================

-- Quantidade de produtos por categoria
SELECT c.id, c.nome, COUNT(p.id) AS total_produtos
FROM categorias c
    LEFT JOIN produtos p ON p.categoria_id = c.id
GROUP BY
    c.id,
    c.nome
ORDER BY total_produtos DESC;

-- Total vendido por categoria
SELECT c.nome AS categoria, COALESCE(SUM(ip.subtotal), 0) AS total_vendido
FROM
    categorias c
    LEFT JOIN produtos pr ON pr.categoria_id = c.id
    LEFT JOIN itens_pedido ip ON ip.produto_id = pr.id
GROUP BY
    c.nome
ORDER BY total_vendido DESC;

-- Categoria com mais vendas
SELECT c.nome AS categoria, SUM(ip.subtotal) AS total_vendido
FROM
    categorias c
    JOIN produtos pr ON pr.categoria_id = c.id
    JOIN itens_pedido ip ON ip.produto_id = pr.id
GROUP BY
    c.nome
ORDER BY total_vendido DESC
LIMIT 1;

-- ========================================
-- RELATÓRIOS DE PEDIDOS
-- ========================================

-- Quantidade de pedidos por status
SELECT status, COUNT(*) AS quantidade
FROM pedidos
GROUP BY
    status
ORDER BY quantidade DESC;

-- Quantidade de pedidos por forma de pagamento
SELECT forma_pagamento, COUNT(*) AS quantidade
FROM pedidos
GROUP BY
    forma_pagamento
ORDER BY quantidade DESC;

-- Quantidade de pedidos por tipo de entrega
SELECT tipo_entrega, COUNT(*) AS quantidade
FROM pedidos
GROUP BY
    tipo_entrega
ORDER BY quantidade DESC;

-- Total vendido por forma de pagamento
SELECT
    forma_pagamento,
    SUM(total) AS total_vendido
FROM pedidos
WHERE
    status <> 'cancelado'
GROUP BY
    forma_pagamento
ORDER BY total_vendido DESC;

-- Total vendido por tipo de entrega
SELECT tipo_entrega, SUM(total) AS total_vendido
FROM pedidos
WHERE
    status <> 'cancelado'
GROUP BY
    tipo_entrega
ORDER BY total_vendido DESC;

-- Pedidos com maior valor
SELECT p.id, c.nome AS cliente, p.total
FROM pedidos p
    JOIN clientes c ON c.id = p.cliente_id
ORDER BY p.total DESC;

-- Pedidos com menor valor
SELECT p.id, c.nome AS cliente, p.total
FROM pedidos p
    JOIN clientes c ON c.id = p.cliente_id
ORDER BY p.total ASC;

-- ========================================
-- DETALHAMENTO COMPLETO DOS PEDIDOS
-- ========================================

-- Exibir cada pedido com seus itens detalhados
SELECT
    p.id AS pedido_id,
    c.nome AS cliente,
    p.status,
    p.tipo_entrega,
    p.forma_pagamento,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal
FROM
    pedidos p
    JOIN clientes c ON c.id = p.cliente_id
    JOIN itens_pedido ip ON ip.pedido_id = p.id
    JOIN produtos pr ON pr.id = ip.produto_id
ORDER BY p.id, pr.nome;

-- Exibir resumo de pedidos por cliente
SELECT c.nome AS cliente, p.id AS pedido_id, p.data_pedido, p.status, p.total
FROM clientes c
    JOIN pedidos p ON p.cliente_id = c.id
ORDER BY c.nome, p.data_pedido DESC;

-- Exibir quantidade total de itens por pedido
SELECT
    p.id AS pedido_id,
    c.nome AS cliente,
    SUM(ip.quantidade) AS total_itens
FROM
    pedidos p
    JOIN clientes c ON c.id = p.cliente_id
    JOIN itens_pedido ip ON ip.pedido_id = p.id
GROUP BY
    p.id,
    c.nome
ORDER BY p.id ASC;

-- ========================================
-- VALIDAÇÃO E CONFERÊNCIA DE DADOS
-- ========================================

-- Conferir se o total do pedido bate com a soma dos itens
SELECT
    p.id AS pedido_id,
    p.total AS total_pedido,
    SUM(ip.subtotal) AS soma_itens,
    (p.total - SUM(ip.subtotal)) AS diferenca
FROM pedidos p
    JOIN itens_pedido ip ON ip.pedido_id = p.id
GROUP BY
    p.id,
    p.total
ORDER BY p.id ASC;

-- Listar pedidos onde o total é diferente da soma dos itens
SELECT
    p.id AS pedido_id,
    p.total AS total_pedido,
    SUM(ip.subtotal) AS soma_itens
FROM pedidos p
    JOIN itens_pedido ip ON ip.pedido_id = p.id
GROUP BY
    p.id,
    p.total
HAVING
    p.total <> SUM(ip.subtotal);

-- Verificar produtos sem categoria
SELECT p.id, p.nome
FROM produtos p
    LEFT JOIN categorias c ON c.id = p.categoria_id
WHERE
    c.id IS NULL;

-- Verificar pedidos sem cliente
SELECT p.id
FROM pedidos p
    LEFT JOIN clientes c ON c.id = p.cliente_id
WHERE
    c.id IS NULL;

-- Verificar itens com produto inexistente
SELECT ip.id, ip.pedido_id
FROM itens_pedido ip
    LEFT JOIN produtos p ON p.id = ip.produto_id
WHERE
    p.id IS NULL;

-- ========================================
-- CONSULTAS TEMPORAIS
-- ========================================

-- Pedidos feitos hoje
SELECT * FROM pedidos WHERE DATE (data_pedido) = CURRENT_DATE;

-- Pedidos do mês atual
SELECT *
FROM pedidos
WHERE
    DATE_TRUNC('month', data_pedido) = DATE_TRUNC('month', CURRENT_DATE);

-- Total vendido por dia
SELECT DATE (data_pedido) AS dia, SUM(total) AS total_vendido
FROM pedidos
WHERE
    status <> 'cancelado'
GROUP BY
    DATE (data_pedido)
ORDER BY dia ASC;

-- Quantidade de pedidos por dia
SELECT DATE (data_pedido) AS dia, COUNT(*) AS quantidade_pedidos
FROM pedidos
GROUP BY
    DATE (data_pedido)
ORDER BY dia ASC;

-- Ranking de clientes que mais gastaram
SELECT c.nome, SUM(p.total) AS total_gasto
FROM clientes c
    JOIN pedidos p ON p.cliente_id = c.id
WHERE
    p.status <> 'cancelado'
GROUP BY
    c.nome
ORDER BY total_gasto DESC;

-- Ranking dos produtos mais vendidos
SELECT pr.nome, SUM(ip.quantidade) AS total_vendido
FROM produtos pr
    JOIN itens_pedido ip ON ip.produto_id = pr.id
GROUP BY
    pr.nome
ORDER BY total_vendido DESC;

-- Percentual de pedidos por status
SELECT
    status,
    COUNT(*) AS quantidade,
    ROUND(
        COUNT(*) * 100.0 / (
            SELECT COUNT(*)
            FROM pedidos
        ),
        2
    ) AS percentual
FROM pedidos
GROUP BY
    status
ORDER BY percentual DESC;

-- Participação de cada forma de pagamento no faturamento
SELECT
    forma_pagamento,
    SUM(total) AS valor_total,
    ROUND(
        SUM(total) * 100.0 / (
            SELECT SUM(total)
            FROM pedidos
            WHERE
                status <> 'cancelado'
        ),
        2
    ) AS percentual_faturamento
FROM pedidos
WHERE
    status <> 'cancelado'
GROUP BY
    forma_pagamento
ORDER BY valor_total DESC;

-- Produto com maior faturamento
SELECT pr.nome, SUM(ip.subtotal) AS faturamento
FROM produtos pr
    JOIN itens_pedido ip ON ip.produto_id = pr.id
GROUP BY
    pr.nome
ORDER BY faturamento DESC
LIMIT 1;

-- Cliente com maior número de pedidos
SELECT c.nome, COUNT(p.id) AS quantidade_pedidos
FROM clientes c
    JOIN pedidos p ON p.cliente_id = c.id
GROUP BY
    c.nome
ORDER BY quantidade_pedidos DESC
LIMIT 1;