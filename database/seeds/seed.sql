BEGIN;

-- ========================================
-- SEED: CATEGORIAS
-- ========================================

INSERT INTO
    categorias (nome, descricao)
VALUES (
        'Hambúrgueres',
        'Lanches artesanais com carne e acompanhamentos'
    ),
    (
        'Bebidas',
        'Refrigerantes, sucos e água'
    ),
    (
        'Sobremesas',
        'Doces, milkshakes e sobremesas'
    );

-- ========================================
-- SEED: PRODUTOS
-- ========================================

INSERT INTO
    produtos (
        nome,
        descricao,
        preco,
        categoria_id,
        disponivel
    )
VALUES (
        'X-Burguer',
        'Pão, carne e queijo',
        12.50,
        1,
        TRUE
    ),
    (
        'X-Salada',
        'Pão, carne, queijo, alface e tomate',
        14.00,
        1,
        TRUE
    ),
    (
        'X-Bacon',
        'Pão, carne, queijo e bacon',
        16.00,
        1,
        TRUE
    ),
    (
        'Refrigerante Lata',
        '350ml',
        6.00,
        2,
        TRUE
    ),
    (
        'Suco Natural',
        'Copo 300ml',
        7.50,
        2,
        TRUE
    ),
    (
        'Água Mineral',
        '500ml',
        3.50,
        2,
        TRUE
    ),
    (
        'Milkshake Chocolate',
        '400ml',
        10.00,
        3,
        TRUE
    ),
    (
        'Sorvete',
        '2 bolas',
        8.00,
        3,
        TRUE
    );

-- ========================================
-- SEED: CLIENTES
-- ========================================

INSERT INTO
    clientes (
        nome,
        email,
        telefone,
        endereco
    )
VALUES (
        'João Silva',
        'joao@email.com',
        '83999990001',
        'Rua A, 123'
    ),
    (
        'Maria Souza',
        'maria@email.com',
        '83999990002',
        'Rua B, 456'
    ),
    (
        'Carlos Pereira',
        NULL,
        '83999990003',
        'Rua C, 789'
    );

-- ========================================
-- SEED: PEDIDOS
-- ========================================

INSERT INTO
    pedidos (
        cliente_id,
        status,
        tipo_entrega,
        forma_pagamento,
        observacoes,
        total
    )
VALUES (
        1,
        'recebido',
        'retirada',
        'pix',
        'Sem cebola',
        18.50
    ),
    (
        2,
        'em_preparo',
        'entrega',
        'cartao_credito',
        'Trocar refrigerante por suco',
        21.50
    ),
    (
        3,
        'pronto',
        'consumo_local',
        'dinheiro',
        NULL,
        19.50
    ),
    (
        1,
        'entregue',
        'entrega',
        'pix',
        NULL,
        16.00
    );

-- ========================================
-- SEED: ITENS DO PEDIDO
-- ========================================

INSERT INTO
    itens_pedido (
        pedido_id,
        produto_id,
        quantidade,
        preco_unitario,
        subtotal
    )
VALUES (1, 1, 1, 12.50, 12.50),
    (1, 4, 1, 6.00, 6.00),
    (2, 2, 1, 14.00, 14.00),
    (2, 5, 1, 7.50, 7.50),
    (3, 3, 1, 16.00, 16.00),
    (3, 6, 1, 3.50, 3.50),
    (4, 3, 1, 16.00, 16.00);

COMMIT;