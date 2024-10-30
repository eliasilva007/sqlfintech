--Cria a sequencia do Id_usuario
CREATE SEQUENCE seq_usuario
START WITH 1
INCREMENT BY 1;

-- Tabela Pai (Superclasse) - T_Usuario
CREATE TABLE T_Usuario (
    id_usuario INTEGER PRIMARY KEY,
    nm_usuario VARCHAR2(60) NOT NULL,
    sobrenome VARCHAR2(60) NOT NULL,
    email VARCHAR2(60) NOT NULL,
    nr_telefone VARCHAR2(60) NOT NULL,
    dt_registro TIMESTAMP WITH LOCAL TIME ZONE NOT NULL,
    tipo_pessoa VARCHAR2(60) NOT NULL CHECK (tipo_pessoa IN ('F', 'J')) -- 'F' para Física e 'J' para Jurídica
);

-- Tabela Filha (Subclasse) - T_Pessoa_Fisica
CREATE TABLE T_Pessoa_Fisica (
    id_usuario INTEGER PRIMARY KEY, -- Mesma chave primária que T_Usuario para fazer a relação de herança
    nr_cpf VARCHAR2(11) NOT NULL UNIQUE,
    nr_rg VARCHAR2(15) NOT NULL,
    dt_nascimento DATE NOT NULL,
    genero VARCHAR2(10) NOT NULL,
    estado_civil VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_pessoa_fisica_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

-- Tabela Filha (Subclasse) - T_Pessoa_Juridica
CREATE TABLE T_Pessoa_Juridica (
    id_usuario INTEGER PRIMARY KEY, -- Mesma chave primária que T_Usuario
    nr_cnpj VARCHAR2(20) NOT NULL UNIQUE,
    razao_social VARCHAR2(150) NOT NULL,
    nm_fantasia VARCHAR2(150) NOT NULL,
    inscricao_estadual VARCHAR2(150) NOT NULL,
    CONSTRAINT fk_pessoa_juridica_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

ALTER TABLE T_Pessoa_Fisica
ADD CONSTRAINT uq_pessoa_fisica_rg UNIQUE (nr_rg);

-- Tabela de Transação
CREATE TABLE T_Transacao (
    id_transacao INTEGER PRIMARY KEY,
    id_usuario INTEGER,
    CONSTRAINT fk_transacao_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

-- Tabela de Transação Receita
CREATE TABLE T_Transacao_Receita (
    id_recebimento INTEGER PRIMARY KEY,
    id_transacao INTEGER NOT NULL,
    valor_recebimento DECIMAL(10, 2) NOT NULL,
    forma_recebimento VARCHAR2(20) NOT NULL,
    data_recebimento DATE NOT NULL,
    categoria_recebimento VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_transacao_receita FOREIGN KEY (id_transacao) REFERENCES T_Transacao(id_transacao)
);

-- Tabela de Transação Gasto
CREATE TABLE T_Transacao_Gasto (
    id_gasto INTEGER PRIMARY KEY,
    id_transacao INTEGER NOT NULL,
    valor_gasto DECIMAL(10, 2) NOT NULL,
    forma_pagamento VARCHAR2(20) NOT NULL,
    data_gasto DATE NOT NULL,
    categoria_gasto VARCHAR2(20) NOT NULL,
    CONSTRAINT fk_transacao_gasto FOREIGN KEY (id_transacao) REFERENCES T_Transacao(id_transacao)
);

-- Tabela de Investimento
CREATE TABLE T_Investimento (
    id_investimento INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    tipo VARCHAR2(20) NOT NULL,
    valor_investimento DECIMAL(10, 2) NOT NULL,
    taxa_retorno DECIMAL(10, 2),
    dt_inicio DATE NOT NULL,
    dt_fim DATE,
    CONSTRAINT fk_investimento_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

-- Tabela de Meta
CREATE TABLE T_Meta (
    id_meta INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    descricao VARCHAR2(50) NOT NULL,
    valor_meta DECIMAL(10, 2) NOT NULL,
    data_limite DATE NOT NULL,
    CONSTRAINT fk_meta_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

-- Tabela de Dívida
CREATE TABLE T_Divida (
    id_divida INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    valor_pago DECIMAL(10, 2) NOT NULL,
    data_vencimento DATE NOT NULL,
    status VARCHAR2(20) NOT NULL,
    tipo VARCHAR2(20) NOT NULL,
    descricao VARCHAR2(100) NOT NULL,
    CONSTRAINT fk_divida_usuario FOREIGN KEY (id_usuario) REFERENCES T_Usuario(id_usuario)
);

COMMIT;

ALTER TABLE T_Transacao
MODIFY id_usuario INTEGER NOT NULL;

COMMIT;



