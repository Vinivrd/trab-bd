-- Especialização do Usuario
CREATE TYPE Tipo_de_usuario AS ENUM (
    'Cidadão',
    'Defesa Civil',
    'Equipe de Manutenção',
    'Administrador'
);

-- Tabela para Usuario
CREATE TABLE Usuario (
	CPF SERIAL PRIMARY KEY,
	Tipo Tipo_de_usuario NOT NULL
);

-- Tabela para Cidadao
CREATE TABLE Cidadao (
	Usuario INTEGER PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,

    CONSTRAINT fk_cidadao_usuario
        FOREIGN KEY (Usuario) 
        REFERENCES Usuario(CPF)
        ON DELETE CASCADE -- Se o Usuario for deletado, o Cidadao também é
);

-- Tabela para Defesa Civil
CREATE TABLE Defesa_Civil (
	Usuario INTEGER PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,


    CONSTRAINT fk_defesacivil_usuario
        FOREIGN KEY (Usuario) 
        REFERENCES Usuario(CPF)
        ON DELETE CASCADE -- Se o Usuario for deletado, a Defesa Civil também é
);

-- Tabela para Equipe de Manutençao
CREATE TABLE Equipe_de_Manutencao (
	Usuario INTEGER PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,
  Num INTEGER,

    CONSTRAINT fk_equipedemanutencao_usuario
        FOREIGN KEY (Usuario) 
        REFERENCES Usuario(CPF)
        ON DELETE CASCADE -- Se o Usuario for deletado, a Equipe de Manutençao também é
);

-- Tabela para Adm
CREATE TABLE Adm (
	Usuario INTEGER PRIMARY KEY,
  Nome VARCHAR(255) NOT NULL,
  
    CONSTRAINT fk_adm_usuario
        FOREIGN KEY (Usuario) 
        REFERENCES Usuario(CPF)
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
	Tipo Tipo_ponto_hidrologico NOT NULL
);

-- Tabela para Corrego
CREATE TABLE Corrego (
	Ponto_Hidrologico VARCHAR(255) PRIMARY KEY,
  Capacidade_de_Drenagem NUMERIC(10,2) NOT NULL,


    CONSTRAINT fk_corrego_pontohidrologico
        FOREIGN KEY (Ponto_Hidrologico)
        REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
        ON DELETE CASCADE -- Se o Ponto Hidrologico for deletado, o Corrego também é
);

-- Tabela para Bueiro
CREATE TABLE Bueiro (
	Ponto_Hidrologico VARCHAR(255) PRIMARY KEY,
  Capacidade_de_Drenagem NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_bueiro_pontohidrologico
        FOREIGN KEY (Ponto_Hidrologico)
        REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
        ON DELETE CASCADE -- Se o Ponto Hidrologico for deletado, o Bueiro também é
);

-- Tabela para Rio
CREATE TABLE Rio (
	Ponto_Hidrologico VARCHAR(255) PRIMARY KEY,
  Capacidade_de_Drenagem NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_rio_pontohidrologico
        FOREIGN KEY (Ponto_Hidrologico)
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
		PRIMARY KEY (Ponto_Hidrologico, Posicao),
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
		PRIMARY KEY (Data_Hora, Sensor_Ponto_Hidrologico, Sensor_Posicao),
	CONSTRAINT fk_leitura_sensor
        FOREIGN KEY (Sensor_Ponto_Hidrologico, Sensor_Posicao) 
        REFERENCES Sensor(Ponto_Hidrologico, Posicao)
);

-- Tabela para Monitora
CREATE TABLE Monitora (
    Ponto_Hidrologico VARCHAR(255) NOT NULL,
    Defesa_Civil INTEGER NOT NULL,

    CONSTRAINT pk_monitora
        PRIMARY KEY (Ponto_Hidrologico, Defesa_Civil),
    CONSTRAINT fk_monitora_ponto_hidrologico
        FOREIGN KEY (Ponto_Hidrologico)
        REFERENCES Ponto_Hidrologico(Localizacao_Geografica),
    CONSTRAINT fk_monitora_defesa_civil
        FOREIGN KEY (Defesa_Civil)
        REFERENCES Defesa_Civil(Usuario) 
);


-- Tabela para Alagamento
CREATE TABLE Alagamento (
	Ponto_Hidrologico VARCHAR(255) NOT NULL,
	Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Severidade SMALLINT NOT NULL CHECK (Severidade >= 0 AND Severidade <= 10),
	Extensao_da_Area_Afetada NUMERIC(10,2),
	Bairros_Afetados VARCHAR(255),

	CONSTRAINT pk_alagamento
		PRIMARY KEY (Ponto_Hidrologico, Data_Hora),
	CONSTRAINT fk_alagamento_pontohidrologico
		FOREIGN KEY (Ponto_Hidrologico)
		REFERENCES Ponto_Hidrologico(Localizacao_Geografica)
);

-- Tabela para Manutencao
CREATE TABLE Manutencao(
	Bueiro VARCHAR(255) NOT NULL,
	Equipe_de_Manutencao INTEGER NOT NULL,
	Data_Hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	Tipo_de_Servico VARCHAR(255) NOT NULL,

	CONSTRAINT pk_manutencao
		PRIMARY KEY (Bueiro, Equipe_de_Manutencao, Data_Hora),
	CONSTRAINT fk_manutencao
		FOREIGN KEY (Equipe_de_Manutencao)
		REFERENCES Equipe_de_Manutencao(Usuario)
);

-- Especialização da Notificacao
CREATE TYPE Tipo_notificacao AS ENUM (
    'Alerta de Ação',
    'Alerta de Enchente'
);

-- Tabela para Alerta de Acao
CREATE TABLE Alerta_de_Acao (
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Conteudo_da_Mensagem TEXT,
    Status_da_Resposta VARCHAR(50),

  
    CONSTRAINT pk_alerta_acao
		  PRIMARY KEY (Data_Hora)
);

-- Tabela para Alerta de Enchente
CREATE TABLE Alerta_Enchente (
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Conteudo_da_Mensagem TEXT,
    Status_da_Resposta VARCHAR(50),
    Tipo_enchente VARCHAR(100),
    Alagamento_PH VARCHAR(255) NOT NULL,
    Alagamento_DH TIMESTAMP NOT NULL,


    CONSTRAINT pk_alerta_enchente
		  PRIMARY KEY (Data_Hora),
    CONSTRAINT fk_alagamento
        FOREIGN KEY (Alagamento_PH, Alagamento_DH) 
        REFERENCES Alagamento(Ponto_Hidrologico, Data_Hora)
        ON DELETE CASCADE -- Se a Notificacao for deletada, o Alerta também é
);

-- Tabela para Alerta de Enchente para o Usuario
CREATE TABLE Alerta_Enchente_Usuario (
    Id_alerta TIMESTAMP NOT NULL,
    Id_usuario INTEGER NOT NULL,

    CONSTRAINT pk_alerta_enchente_usuario
       PRIMARY KEY (Id_alerta, Id_usuario),
    CONSTRAINT fk_alerta_enchente_usuario
        FOREIGN KEY (Id_alerta) 
        REFERENCES Alerta_Enchente(Data_Hora)
        ON DELETE CASCADE,
    CONSTRAINT fk_alerta_usuario
        FOREIGN KEY (Id_usuario) 
        REFERENCES Usuario(CPF)
        ON DELETE CASCADE
);

-- Tabela para Relatorio de Acao da Equipe de Manutencao
CREATE TABLE Relatorio_de_Acao_EM (
    Id_relatorio SERIAL,
    Id_equipe INTEGER NOT NULL,
    Id_alerta TIMESTAMP NOT NULL,
    Descricao_da_Intervencao TEXT,
    Resultados_Alcancados TEXT,
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_relatorio_acao_em
        PRIMARY KEY (Id_relatorio, Id_equipe, Id_alerta),
    CONSTRAINT fk_relatorio_equipe_em
        FOREIGN KEY (Id_equipe)
        REFERENCES Equipe_de_Manutencao(Usuario), 
    CONSTRAINT fk_relatorio_alerta_em
        FOREIGN KEY (Id_alerta)
        REFERENCES Alerta_de_Acao(Data_Hora)  
        ON DELETE RESTRICT,
    CONSTRAINT un_equipe_alerta_em
        UNIQUE(Id_equipe, Id_alerta)
);
-- Tabela para Relatorio de Acao da Defesa Civil
CREATE TABLE Relatorio_de_Acao_DC (
    Id_relatorio SERIAL,
    Id_defesacivil INTEGER NOT NULL,
    Id_alerta TIMESTAMP NOT NULL,
    Descricao_da_Intervencao TEXT,
    Resultados_Alcancados TEXT,
    Data_Hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_relatorio_acao_dc
        PRIMARY KEY (Id_relatorio, Id_defesacivil, Id_alerta),
    CONSTRAINT fk_relatorio_defesacivil
        FOREIGN KEY (Id_defesacivil)
        REFERENCES Defesa_Civil(Usuario), 
    CONSTRAINT fk_relatorio_alerta_dc
        FOREIGN KEY (Id_alerta)
        REFERENCES Alerta_de_Acao(Data_Hora)  
        ON DELETE RESTRICT,
    CONSTRAINT un_equipe_alerta_dc
        UNIQUE(Id_defesacivil, Id_alerta)
);