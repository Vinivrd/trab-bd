-- ==========================================================
-- ARQUIVO DE INSERTS PARA O ESQUEMA ATUAL
-- Ordem: Usuario → especializações → Ponto_Hidrologico → especializações
--        Sensor → Leitura → Monitora → Alagamento → Manutencao
--        Alertas (Ação / Enchente) → Alerta_Enchente_Usuario
--        Relatorios EM / DC
-- ==========================================================

-- -----------------------------
-- USUÁRIOS E ESPECIALIZAÇÕES
-- -----------------------------
INSERT INTO Usuario (CPF, Tipo) VALUES
    (1, 'Cidadão'), 
    (2, 'Defesa Civil'),
    (3, 'Equipe de Manutenção'),
    (4, 'Administrador'),
    (5, 'Cidadão'),
    (6, 'Defesa Civil'),
    (7, 'Equipe de Manutenção'),
    (8, 'Administrador'),
    (9, 'Administrador'),
    (10, 'Cidadão'),
    (11, 'Defesa Civil'),
    (12, 'Equipe de Manutenção');

INSERT INTO Cidadao (Usuario, Nome) VALUES
    (1, 'João Silva'),
    (5, 'Maria Souza'),
    (10, 'Pedro Silva');

INSERT INTO Defesa_Civil (Usuario, Nome) VALUES
    (2, 'Carlos Pereira'),
    (6, 'Ana Oliveira'),
    (11, 'Luiz Carlos');

INSERT INTO Equipe_de_Manutencao (Usuario, Nome, Num) VALUES
    (3, 'Equipe Centro', 101),
    (7, 'Equipe Zona Sul', 202),
    (12, 'Equipe Zona Norte', 303);

INSERT INTO Adm (Usuario) VALUES
    (4),
    (8),
    (9);

-- -----------------------------
-- PONTOS HIDROLÓGICOS E TIPOS
-- -----------------------------
INSERT INTO Ponto_Hidrologico (Localizacao_Geografica, Tipo) VALUES
    ('RIO_TIETE_PONTE_CENTRO',    'Rio'),
    ('CORREGO_SANTA_PAULA',       'Corrego'),
    ('BUEIRO_AV1_Q3',             'Bueiro'),
    ('BUEIRO_AV2_Q10',            'Bueiro'),
    ('RIO_PINHEIROS_PONTE_OESTE', 'Rio'),
    ('CORREGO_JARDIM_NORTE',      'Corrego'),
    ('CORREGO_JARDIM_AZUL',       'Corrego'),
    ('RIO_TIETE_PONTE_LESTE',     'Rio'),
    ('CORREGO_SANTA_FE',          'Corrego');

INSERT INTO Rio (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('RIO_TIETE_PONTE_CENTRO',    5000.00),
    ('RIO_PINHEIROS_PONTE_OESTE', 4500.00),
    ('RIO_TIETE_PONTE_LESTE',     4200.00);

INSERT INTO Corrego (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('CORREGO_SANTA_PAULA',  1200.00),
    ('CORREGO_JARDIM_NORTE', 900.00),
    ('CORREGO_JARDIM_AZUL',  900.00),
    ('CORREGO_SANTA_FE',     1100.00);

INSERT INTO Bueiro (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('BUEIRO_AV1_Q3',  80.00),
    ('BUEIRO_AV2_Q10', 65.00);


-- -----------------------------
-- SENSORES
-- -----------------------------
INSERT INTO Sensor (Ponto_Hidrologico, Posicao, Tipo) VALUES
    ('RIO_TIETE_PONTE_CENTRO', 'Montante', 'Nível de Água'),
    ('RIO_TIETE_PONTE_CENTRO', 'Jusante',  'Nível de Água'),
    ('CORREGO_SANTA_PAULA',    'Centro',   'Nível de Água'),
    ('BUEIRO_AV1_Q3',          'Entrada',  'Pluviométrico'),
    ('BUEIRO_AV2_Q10',         'Entrada',  'Pluviométrico');


-- -----------------------------
-- LEITURAS DOS SENSORES
-- -----------------------------
INSERT INTO Leitura (Data_Hora, Sensor_Ponto_Hidrologico, Sensor_Posicao, Valor) VALUES
    ('2025-01-10 08:00:00', 'RIO_TIETE_PONTE_CENTRO', 'Montante', 3.50),
    ('2025-01-10 08:15:00', 'RIO_TIETE_PONTE_CENTRO', 'Montante', 4.20),
    ('2025-01-10 08:30:00', 'RIO_TIETE_PONTE_CENTRO', 'Montante', 5.10),

    ('2025-01-10 08:00:00', 'RIO_TIETE_PONTE_CENTRO', 'Jusante',  3.20),
    ('2025-01-10 08:15:00', 'RIO_TIETE_PONTE_CENTRO', 'Jusante',  3.90),

    ('2025-01-10 08:00:00', 'CORREGO_SANTA_PAULA',    'Centro',   1.80),
    ('2025-01-10 08:30:00', 'CORREGO_SANTA_PAULA',    'Centro',   2.50),

    ('2025-01-10 07:45:00', 'BUEIRO_AV1_Q3',          'Entrada',  20.00),
    ('2025-01-10 08:15:00', 'BUEIRO_AV1_Q3',          'Entrada',  45.00),

    ('2025-01-15 17:00:00', 'BUEIRO_AV2_Q10',         'Entrada',  30.00),
    ('2025-01-15 17:20:00', 'BUEIRO_AV2_Q10',         'Entrada',  70.00);


-- -----------------------------
-- MONITORA (DEFESA CIVIL x PONTO)
-- -----------------------------
INSERT INTO Monitora (Ponto_Hidrologico, Defesa_Civil) VALUES
    ('RIO_TIETE_PONTE_CENTRO', 2),
    ('CORREGO_SANTA_PAULA',    2),
    ('BUEIRO_AV1_Q3',          6),
    ('BUEIRO_AV2_Q10',         6);


-- -----------------------------
-- ALAGAMENTOS
-- -----------------------------
INSERT INTO Alagamento (
    Ponto_Hidrologico,
    Data_Hora,
    Severidade,
    Extensao_da_Area_Afetada,
    Bairros_Afetados
) VALUES
    ('BUEIRO_AV1_Q3',
     '2025-01-10 08:40:00',
     7,
     1.50,
     'Centro, Bairro Velho'),

    ('BUEIRO_AV2_Q10',
     '2025-01-15 17:25:00',
     9,
     3.20,
     'Jardim Sul, Vila Nova');


-- -----------------------------
-- MANUTENÇÃO (BUEIRO x EQUIPE)
-- -----------------------------
INSERT INTO Manutencao (
    Bueiro,
    Equipe_de_Manutencao,
    Data_Hora,
    Tipo_de_Servico
) VALUES
    ('BUEIRO_AV1_Q3',
     3,
     '2025-01-10 10:00:00',
     'Desobstrução e limpeza do bueiro'),

    ('BUEIRO_AV2_Q10',
     7,
     '2025-01-16 09:30:00',
     'Limpeza preventiva e inspeção estrutural');


-- -----------------------------
-- ALERTAS DE AÇÃO
-- -----------------------------
INSERT INTO Alerta_de_Acao (
    Data_Hora,
    Conteudo_da_Mensagem,
    Status_da_Resposta
) VALUES
    ('2025-01-10 09:00:00',
     'Nível de água elevado no RIO_TIETE_PONTE_CENTRO. Verificar necessidade de bloqueio parcial da via.',
     'Pendente'),

    ('2025-01-15 17:40:00',
     'Alagamento crítico próximo ao BUEIRO_AV2_Q10. Avaliar evacuação de moradores.',
     'Em andamento');


-- -----------------------------
-- ALERTAS DE ENCHENTE
-- (relacionados aos ALAGAMENTOS)
-- -----------------------------
INSERT INTO Alerta_Enchente (
    Data_Hora,
    Conteudo_da_Mensagem,
    Status_da_Resposta,
    Tipo_enchente,
    Alagamento_PH,
    Alagamento_DH
) VALUES
    ('2025-01-10 08:50:00',
     'Alagamento detectado na região central, monitorar evolução e orientar população.',
     'Enviado',
     'Alagamento urbano pontual',
     'BUEIRO_AV1_Q3',
     '2025-01-10 08:40:00'),

    ('2025-01-15 17:35:00',
     'Alagamento severo em área residencial. Possível risco às habitações térreas.',
     'Enviado',
     'Alagamento urbano severo',
     'BUEIRO_AV2_Q10',
     '2025-01-15 17:25:00');


-- -----------------------------
-- ALERTA DE ENCHENTE x USUÁRIOS
-- -----------------------------
INSERT INTO Alerta_Enchente_Usuario (
    Id_alerta,
    Id_usuario
) VALUES
    -- Alerta de 10/01 para cidadãos e Defesa Civil principal
    ('2025-01-10 08:50:00', 1),  -- João (Cidadão)
    ('2025-01-10 08:50:00', 5),  -- Maria (Cidadão)
    ('2025-01-10 08:50:00', 2),  -- Carlos (Defesa Civil)

    -- Alerta de 15/01 para outro conjunto de usuários
    ('2025-01-15 17:35:00', 5),  -- Maria
    ('2025-01-15 17:35:00', 6);  -- Ana (Defesa Civil)


-- -----------------------------
-- RELATÓRIOS DE AÇÃO - EQUIPE DE MANUTENÇÃO
-- (cada equipe gera um relatório por Alerta_de_Acao)
-- -----------------------------
INSERT INTO Relatorio_de_Acao_EM (
    Id_relatorio,
    Id_equipe,
    Id_alerta,
    Descricao_da_Intervencao,
    Resultados_Alcancados,
    Data_Hora
) VALUES
    (1,
     3,
     '2025-01-10 09:00:00',
     'Equipe Centro deslocou-se até o rio, avaliou o nível de água e realizou limpeza de detritos nas margens.',
     'Redução do nível em aproximadamente 0,4m e melhora no escoamento imediato.',
     '2025-01-10 11:30:00'),

    (2,
     7,
     '2025-01-15 17:40:00',
     'Equipe Zona Sul sinalizou a via, instalou barreiras improvisadas e verificou pontos de obstrução na drenagem.',
     'Fluxo de água parcialmente restabelecido, mas recomendada obra estrutural futura.',
     '2025-01-15 19:00:00');


-- -----------------------------
-- RELATÓRIOS DE AÇÃO - DEFESA CIVIL
-- -----------------------------
INSERT INTO Relatorio_de_Acao_DC (
    Id_relatorio,
    Id_defesacivil,
    Id_alerta,
    Descricao_da_Intervencao,
    Resultados_Alcancados,
    Data_Hora
) VALUES
    (1,
     2,
     '2025-01-10 09:00:00',
     'Defesa Civil monitorou níveis ao longo da manhã, acionou comunicação com a população via redes sociais e rádio local.',
     'População orientada a evitar a região central; sem registros de vítimas.',
     '2025-01-10 12:00:00'),

    (2,
     6,
     '2025-01-15 17:40:00',
     'Defesa Civil realizou vistoria em residências, identificou casas em risco e preparou pontos de acolhimento.',
     'Três famílias realocadas temporariamente; riscos imediatos mitigados.',
     '2025-01-15 20:15:00');