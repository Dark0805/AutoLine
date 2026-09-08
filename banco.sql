-- Criação do Banco de Dados
CREATE DATABASE oficina_mecanica;
USE oficina_mecanica;

-- 1. TABELA DE FUNCIONÁRIOS (Inclui o Administrador)
CREATE TABLE funcionarios (
    cpf VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(255) NOT NULL, -- Recomendado usar hash no PHP (password_hash)
    cargo VARCHAR(50) NOT NULL,
    tipo_permissao INT NOT NULL, -- 1: 1 veículo, 2: alguns, 3: todos, 4: todos + clientes (ADM)
    quantidade_veiculos_permitidos INT DEFAULT NULL -- Usado se a permissão for tipo 2
);

-- 2. TABELA DE CLIENTES
CREATE TABLE clientes (
    cpf_cli VARCHAR(11) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    endereco TEXT NOT NULL, -- Pode armazenar o endereço completo ou CEP/Número conforme o PHP
    telefone1 VARCHAR(15) NOT NULL,
    telefone2 VARCHAR(15) DEFAULT NULL
);

-- 3. TABELA DE VEÍCULOS
CREATE TABLE veiculos (
    placa VARCHAR(7) PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,    -- Ex: Carro, Moto
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    cor VARCHAR(30) NOT NULL,
    problema TEXT NOT NULL,
    dificuldade ENUM('facil', 'medio', 'dificil', 'sem salvacao') NOT NULL,
    status_etapa INT DEFAULT 1,   -- Controla a etapa atual do conserto (ex: 1 a 5)
    data_prevista DATE DEFAULT NULL,
    valor_estimado DECIMAL(10, 2) DEFAULT NULL,
    cpf_cliente VARCHAR(11) NOT NULL,
    FOREIGN KEY (cpf_cliente) REFERENCES clientes(cpf_cli) ON DELETE CASCADE
);

-- 4. TABELA DE AVARIAS (Um veículo pode ter várias avarias)
CREATE TABLE avarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa_veiculo VARCHAR(7) NOT NULL,
    descricao_avaria TEXT NOT NULL,
    FOREIGN KEY (placa_veiculo) REFERENCES veiculos(placa) ON DELETE CASCADE
);

-- 5. TABELA DE TAREFAS DIÁRIAS DOS FUNCIONÁRIOS
CREATE TABLE tarefas_diarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cpf_funcionario VARCHAR(11) NOT NULL,
    placa_veiculo VARCHAR(7) NOT NULL,
    data_selecao DATE NOT NULL,
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionarios(cpf),
    FOREIGN KEY (placa_veiculo) REFERENCES veiculos(placa)
);

-- 6. TABELA DE HISTÓRICO / LOGS (Para exclusões e edições com justificativa)
CREATE TABLE historico_alteracoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_acao ENUM('edicao_cliente', 'exclusao_cliente', 'edicao_veiculo', 'exclusao_veiculo') NOT NULL,
    identificador_alvo VARCHAR(11) NOT NULL, -- Armazena o CPF do cliente ou Placa do veículo afetado
    justificativa TEXT NOT NULL,
    cpf_funcionario VARCHAR(11) NOT NULL,
    data_acao DATETIME NOT NULL,
    FOREIGN KEY (cpf_funcionario) REFERENCES funcionarios(cpf)
);

-- Inserindo o Administrador padrão inicial para você conseguir logar e cadastrar os outros
INSERT INTO funcionarios (cpf, nome, senha, cargo, tipo_permissao) 
VALUES ('00000000000', 'Administrador', 'admin123', 'Gerente', 4);
