CREATE TABLE IF NOT EXISTS pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL CHECK (
        status IN (
            'recebido',
            'em_preparo',
            'pronto',
            'entregue',
            'cancelado'
        )
    ),
    tipo_entrega VARCHAR(20) NOT NULL CHECK (
        tipo_entrega IN (
            'retirada',
            'entrega',
            'consumo_local'
        )
    ),
    forma_pagamento VARCHAR(20) NOT NULL CHECK (
        forma_pagamento IN (
            'dinheiro',
            'cartao_debito',
            'cartao_credito',
            'pix'
        )
    ),
    observacoes TEXT,
    total NUMERIC(10, 2) NOT NULL CHECK (total >= 0),
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);