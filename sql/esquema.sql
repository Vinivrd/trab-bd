-- Especialização do Usuario
CREATE TYPE Tipo_de_usuario AS ENUM (
    'Cidadão',
    'Defesa Civil',
    'Equipe de Manutenção',
    'Administrador'
);

-- Tabela para Usuario
CREATE TABLE Usuario (
	Id SERIAL PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
	Tipo Tipo_de_usuario NOT NULL
);

-- Tabela para Cidadao
CREATE TABLE Cidadao (
	Id_Usuario INTEGER PRIMARY KEY,

    CONSTRAINT fk_cidadao_usuario
        FOREIGN KEY (Id_usuario) 
        REFERENCES Usuario(Id)
        ON DELETE CASCADE -- Se o Usuario for deletado, o Cidadao também é
);

-- Tabela para Defesa Civil
CREATE TABLE Defesa_Civil (
	Id_Usuario INTEGER PRIMARY KEY,

    CONSTRAINT fk_defesacivil_usuario
        FOREIGN KEY (Id_usuario) 
        REFERENCES Usuario(Id)
        ON DELETE CASCADE -- Se o Usuario for deletado, a Defesa Civil também é
);

-- Tabela para Equipe de Manutençao
CREATE TABLE Equipe_de_Manutencao (
	Id_Usuario INTEGER PRIMARY KEY,
    Num INTEGER,

    CONSTRAINT fk_equipedemanutencao_usuario
        FOREIGN KEY (Id_usuario) 
        REFERENCES Usuario(Id)
        ON DELETE CASCADE -- Se o Usuario for deletado, a Equipe de Manutençao também é
);

-- Tabela para Adm
CREATE TABLE Adm (
	Id_Usuario INTEGER PRIMARY KEY,

    CONSTRAINT fk_adm_usuario
        FOREIGN KEY (Id_usuario) 
        REFERENCES Usuario(Id)
        ON DELETE CASCADE -- Se o Usuario for deletado, o Adm também é

);

-- Especialização do Ponto Hidrologico
CREATE TYPE Tipo_ponto_hidrologico AS ENUM (
    'Corrego',
    'Rio',
    'Bueiro'
);

-- Tabela para Ponto Hidrologico
CREATE TABLE Ponto_Hidrologico (
	Localizacao_Geografica VARCHAR(255) PRIMARY KEY,
    Capacidade_de_Drenagem NUMERIC(10,2) NOT NULL,
	Tipo Tipo_ponto_hidrologico NOT NULL
)

-- Tabela para Corrego
CREATE TABLE Corrego (
	Localizacao_Geografica VARCHAR(255) PRIMARY KEY,

    CONSTRAINT fk_corrego_pontohidrologico
        FOREIGN KEY (Localizacao_Geografica)
        REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
        ON DELETE CASCADE -- Se o Ponto Hidrologico for deletado, o Corrego também é
);

-- Tabela para Bueiro
CREATE TABLE Bueiro (
	Localizacao_Geografica VARCHAR(255) PRIMARY KEY,

    CONSTRAINT fk_bueiro_pontohidrologico
        FOREIGN KEY (Localizacao_Geografica)
        REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
        ON DELETE CASCADE -- Se o Ponto Hidrologico for deletado, o Bueiro também é
);

-- Tabela para Rio
CREATE TABLE Rio (
	Localizacao_Geografica VARCHAR(255) PRIMARY KEY,

    CONSTRAINT fk_rio_pontohidrologico
        FOREIGN KEY (Localizacao_Geografica)
        REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
        ON DELETE CASCADE -- Se o Ponto Hidrologico for deletado, o Rio também é
);

-- Especialização do Sensor
CREATE TYPE Tipo_sensor AS ENUM (
    'Nível de Água',
    'Pluviométrico'
);

-- Tabela para Sensor
CREATE TABLE Sensor (
	Ponto_Hidrologico VARCHAR(255) NOT NULL,
	Posicao VARCHAR(255) NOT NULL,
	Tipo Tipo_sensor NOT NULL,
	
	CONSTRAINT pk_sensor
		PRIMARY KEY (Ponto_Hidrologico, Posição)
	CONSTRAINT fk_sensor_pontohidrologico
		FOREIGN KEY (Ponto_Hidrologico) 
		REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
);

-- Tabela para Leitura
CREATE TABLE Leitura (
	Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Sensor_Ponto_Hidrologico VARCHAR(255) NOT NULL,
	Sensor_Posicao VARCHAR(255) NOT NULL,
	Valor NUMERIC(10,2) NOT NULL,

	CONSTRAINT pk_leitura
		PRIMARY KEY (Data_Hora, Sensor_Ponto_Hidrologico, Sensor_Posicao)
	CONSTRAINT fk_leitura_sensor
        FOREIGN KEY (Sensor_Ponto_Hidrologico, Sensor_Posicao) 
        REFERENCES Sensor(Ponto_Hidrologico, Posicao)
);

-- Tabela para Monitora
CREATE TABLE Monitora (
	Leitura VARCHAR(255) NOT NULL,
	Defesa_Civil INTEGER NOT NULL,

	CONSTRAINT pk_monitora
		PRIMARY KEY (Leitura, Defesa_Civil)
	CONSTRAINT fk_monitora_leitura
		FOREIGN KEY (Leitura)
		REFERENCES Leitura(Sensor_Ponto_Hidrologico)
	CONSTRAINT fk_monitora_defesa_civil
		FOREIGN KEY (Defesa_Civil)
		REFERENCES Defesa_Civil(Id)
);


-- Tabela para Alagamento
CREATE TABLE Alagamento (
	Ponto_Hidrologico VARCHAR(50) NOT NULL,
	Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Severidade SMALLINT NOT NULL CHECK (Severidade >= 0 AND Severidade <= 10)
	Extensao_da_Area_Afetada NUMERIC(10,2),
	Bairros_Afetados VARCHAR(255),

	CONSTRAINT pk_alagamento
		PRIMARY KEY (Ponto_Hidrologico, Data_Hora)
	CONSTRAINT fk_alagamento_pontohidrologico
		FOREIGN KEY (Ponto_Hidrologico)
		REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
);

-- Tabela para Manutencao
CREATE TABLE Manutencao(
	Bueiro VARCHAR(255) NOT NULL,
	Equipe_de_Manutencao INTEGER NOT NULL,
	Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Tipo_de_Servico VARCHAR(255) NOT NULL

	CONSTRAINT pk_manutencao
		PRIMARY KEY (Bueiro, Equipe_de_Manutencao, Data_Hora)
	CONSTRAINT fk_manutenção
		FOREIGN KEY (Equipe_de_Manutencao)
		REFERENCES Equipe_de_Manutencao(Id)
);

-- Especialização da Notificacao
CREATE TYPE Tipo_notificacao AS ENUM (
    'Alerta de Ação',
    'Alerta de Enchente'
);

-- Tabela para Notificacao
CREATE TABLE Notificacao (
    Id SERIAL PRIMARY KEY,
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Conteudo_da_Mensagem TEXT,
    Status_da_Resposta VARCHAR(50),
    Tipo Tipo_notificacao NOT NULL
);

-- Tabela para Alerta de Acao
CREATE TABLE Alerta_Acao (
    Id INTEGER PRIMARY KEY,

    CONSTRAINT fk_acao_notificacao
        FOREIGN KEY (Id) 
        REFERENCES Notificacao(Id)
        ON DELETE CASCADE -- Se a Notificacao for deletada, o Alerta também é
);

-- Tabela para Alerta de Enchente
CREATE TABLE Alerta_Enchente (
    Id INTEGER PRIMARY KEY,
    Tipo_enchente VARCHAR(100),
    Extensao_da_Area_Afetada NUMERIC(10,2)

    CONSTRAINT fk_enchente_notificacao
        FOREIGN KEY (Id) 
        REFERENCES Notificacao(Id)
        ON DELETE CASCADE -- Se a Notificacao for deletada, o Alerta também é
);

-- Tabela para Alerta de Enchente para o Usuario
CREATE TABLE Alerta_Enchente_Usuario (
	Id_alerta INTEGER NOT NULL,
    Id_usuario INTEGER NOT NULL,

	CONSTRAINT fk_alerta_enchente
        FOREIGN KEY (Id_alerta) 
        REFERENCES Alerta_de_Enchente(Id)
        ON DELETE CASCADE, -- Se o Alerta for for deletado, o Alerta enviado para o Usuario também é
        
    CONSTRAINT fk_alerta_usuario
        FOREIGN KEY (Id) 
        REFERENCES Usuario(Id)
        ON DELETE CASCADE, -- Se o Usuario for for deletado, o Alerta enviado para o Usuario também é

    PRIMARY KEY (Id_alerta, Id_Usuario)
)

-- Tabela para Relatorio de Acao da Equipe de Manutencao
CREATE TABLE Relatorio_de_Acao_EM (
	Id_relatorio SERIAL,
	Id_equipe INTEGER NOT NULL,
	Id_alerta INTEGER NOT NULL,
	Descricao_da_Intervencao TEXT,
	Resultados_Alcancados TEXT,
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_relatorio_acao_em
        PRIMARY KEY (Id_relatorio, Id_equipe, Data_Hora)

	CONSTRAINT fk_relatorio_equipe
        FOREIGN KEY (Id_equipe)
        REFERENCES Equipe_de_Manutencao(Id)
        ON DELETE RESTRICT, -- Impede deletar uma equipe se ela tiver relatórios
        
    CONSTRAINT fk_relatorio_alerta
        FOREIGN KEY (Id_alerta)
        REFERENCES Alerta_de_Acao(Id)
        ON DELETE RESTRICT -- Impede deletar um alerta se ele tiver relatórios
)

-- Tabela para Relatorio de Acao da Defesa Civil
CREATE TABLE Relatorio_de_Acao_DC (
	Id_relatorio SERIAL,
	Id_defesacivil INTEGER NOT NULL,
	Id_alerta INTEGER NOT NULL,
	Descricao_da_Intervencao TEXT,
	Resultados_Alcancados TEXT,
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_relatorio_acao_dc
        PRIMARY KEY (Id_relatorio, Id_defesacivil, Data_Hora)

	CONSTRAINT fk_relatorio_equipe
        FOREIGN KEY (Id_defesacivil)
        REFERENCES Defesa_Civil(Id)
        ON DELETE RESTRICT, -- Impede deletar uma defesa civil se ela tiver relatórios
        
    -- Garante que o ID do alerta exista na tabela Alerta_de_Acao
    CONSTRAINT fk_relatorio_alerta
        FOREIGN KEY (Id_alerta)
        REFERENCES Alerta_de_Acao(Id)
        ON DELETE RESTRICT -- Impede deletar um alerta se ele tiver relatórios
)