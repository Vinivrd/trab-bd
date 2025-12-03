-- ==========================================================
-- ARQUIVO DE DADOS (SEEDS) - VALIDADO PARA O ESQUEMA FINAL
-- ==========================================================

-- -----------------------------
-- 1. USUÁRIOS (CPFs válidos e Tipos corretos)
-- -----------------------------
INSERT INTO Usuario (CPF, Tipo) VALUES
    ('111.111.111-01', 'Cidadão'),
    ('111.111.111-02', 'Cidadão'),
    ('222.222.222-01', 'Defesa Civil'),      -- Agente Carlos
    ('222.222.222-02', 'Defesa Civil'),      -- Agente Ana
    ('333.333.333-01', 'Equipe de Manutenção'), -- Equipe Alfa
    ('333.333.333-02', 'Equipe de Manutenção'), -- Equipe Beta
    ('444.444.444-01', 'Administrador');

INSERT INTO Cidadao (Usuario, Nome) VALUES
    ('111.111.111-01', 'João Silva'),
    ('111.111.111-02', 'Maria Souza');

INSERT INTO Defesa_Civil (Usuario, Nome) VALUES
    ('222.222.222-01', 'Carlos Pereira'),
    ('222.222.222-02', 'Ana Oliveira');

INSERT INTO Equipe_de_Manutencao (Usuario, Nome, Num) VALUES
    ('333.333.333-01', 'Equipe Alfa - Centro', 101),
    ('333.333.333-02', 'Equipe Beta - Zona Sul', 202);

INSERT INTO Adm (Usuario, Nome) VALUES
    ('444.444.444-01', 'Admin Geral');

-- -----------------------------
-- 2. PONTOS HIDROLÓGICOS (Foco em RIOS para a Query 1)
-- -----------------------------
INSERT INTO Ponto_Hidrologico (Localizacao_Geografica, Tipo) VALUES
    ('RIO_TIETE_PONTE_CENTRO',     'Rio'),      -- Rios

    ('RIO_PINHEIROS_SUL',          'Rio'), 
    ('RIO_TAMANDUATEI_LESTE',      'Rio'),
    ('RIO_JAGUARE_NORTE',          'Rio'),   
    ('RIO_ARICANDUVA_LESTE',       'Rio'),
    ('RIO_GUIRAPITA_SUL',          'Rio'),
    ('RIO_VERDE_NORTE',            'Rio'),
    ('CORREGO_SAPATEIRO',          'Corrego'),    -- Corregos

    ('CORREGO_AGUA_ESPRAYADA',     'Corrego'),
    ('CORREGO_PIRAJUSSARA',        'Corrego'),
    ('CORREGO_UBERABA',            'Corrego'),
    ('CORREGO_IPIRANGA',           'Corrego'),
    ('CORREGO_TRAICAO',            'Corrego'),
    ('CORREGO_SAPATEIRO_SUL',      'Corrego'),
    ('BUEIRO_RUA_XV',              'Bueiro'),    -- Bueiros

    ('BUEIRO_AV_PAULISTA',         'Bueiro'),
    ('BUEIRO_RUA_13_MAIO',         'Bueiro'),
    ('BUEIRO_VILA_NOVA',           'Bueiro'),
    ('BUEIRO_PARQUE_CENTRAL',      'Bueiro'),
    ('BUEIRO_AV_REBOUCAS',         'Bueiro'),
    ('BUEIRO_AV_FARIA_LIMA',       'Bueiro'),
    ('BUEIRO_RUA_AUGUSTA',         'Bueiro'),
    ('BUEIRO_PRACA_DA_SE',         'Bueiro'),
    ('BUEIRO_TERM_BARRA_FUNDA',    'Bueiro'),
    ('BUEIRO_AV_BRASIL',           'Bueiro'),
    ('BUEIRO_RUA_OSCAR_FREIRE',    'Bueiro');

INSERT INTO Rio (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('RIO_TIETE_PONTE_CENTRO', 5000.00),
    ('RIO_PINHEIROS_SUL',      4500.00),
    ('RIO_TAMANDUATEI_LESTE',  3800.00),
    ('RIO_JAGUARE_NORTE',      2500.00),
    ('RIO_ARICANDUVA_LESTE',   4100.00),
    ('RIO_GUIRAPITA_SUL',      2900.00),
    ('RIO_VERDE_NORTE',        3200.00);

INSERT INTO Corrego (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('CORREGO_SAPATEIRO',      1200.00),
    ('CORREGO_AGUA_ESPRAYADA', 1800.00),
    ('CORREGO_PIRAJUSSARA',    1650.00),
    ('CORREGO_UBERABA',        1100.00),
    ('CORREGO_IPIRANGA',       1350.00),
    ('CORREGO_TRAICAO',        1900.00),
    ('CORREGO_SAPATEIRO_SUL',  1150.00);

INSERT INTO Bueiro (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('BUEIRO_RUA_XV',           80.00),
    ('BUEIRO_AV_PAULISTA',      90.00),
    ('BUEIRO_RUA_13_MAIO',      75.00),
    ('BUEIRO_VILA_NOVA',        85.00),
    ('BUEIRO_PARQUE_CENTRAL',   95.00),
    ('BUEIRO_AV_REBOUCAS',      92.00),
    ('BUEIRO_AV_FARIA_LIMA',    98.00),
    ('BUEIRO_RUA_AUGUSTA',      80.00),
    ('BUEIRO_PRACA_DA_SE',      85.00),
    ('BUEIRO_TERM_BARRA_FUNDA', 100.00),
    ('BUEIRO_AV_BRASIL',        95.00),
    ('BUEIRO_RUA_OSCAR_FREIRE', 78.00);

-- -----------------------------
-- 3. SENSORES (Necessários para a tabela Leitura)
-- -----------------------------
INSERT INTO Sensor (Ponto_Hidrologico, Posicao, Tipo) VALUES
    ('RIO_TIETE_PONTE_CENTRO', 'Montante', 'Nível de Água'), -- Alvo Query 1
    ('RIO_TIETE_PONTE_CENTRO', 'Jusante',  'Nível de Água'), -- Alvo Query 1
    ('RIO_PINHEIROS_SUL',      'Centro',   'Nível de Água'), -- Alvo Query 1
     ('RIO_TAMANDUATEI_LESTE', 'Centro',   'Nível de Água'), -- Alvo Query 1
    ('RIO_JAGUARE_NORTE',      'Montante', 'Nível de Água'), -- Alvo Query 1
    ('BUEIRO_RUA_XV',          'Entrada',  'Pluviométrico'),
    ('CORREGO_SAPATEIRO',      'Montante', 'Pluviométrico'),
    ('RIO_PINHEIROS_SUL',      'Pluvio-1', 'Pluviométrico'),
    ('BUEIRO_AV_PAULISTA',     'Entrada',  'Pluviométrico'),
    ('BUEIRO_PARQUE_CENTRAL',  'Entrada',  'Pluviométrico');

-- -----------------------------
-- 4. LEITURAS (Dados Recentes para Query 1)
-- Gerando leituras dentro da janela de "NOW() - 365 days"
-- -----------------------------
INSERT INTO Leitura (Data_Hora, Sensor_Ponto_Hidrologico, Sensor_Posicao, Valor) VALUES
    -- Rio Tiete (Níveis altos para testar a média)
    (NOW() - INTERVAL '2 days',  'RIO_TIETE_PONTE_CENTRO', 'Montante', 5.50),
    (NOW() - INTERVAL '1 day',   'RIO_TIETE_PONTE_CENTRO', 'Montante', 6.20),
    (NOW() - INTERVAL '12 hours','RIO_TIETE_PONTE_CENTRO', 'Montante', 6.80),
    
  
    (NOW() - INTERVAL '2 days',  'RIO_TIETE_PONTE_CENTRO', 'Jusante',  5.10), -- Rio Tiete (Outra posição)
    (NOW() - INTERVAL '1 day',   'RIO_TIETE_PONTE_CENTRO', 'Jusante',  5.90),

    
    (NOW() - INTERVAL '5 days',  'RIO_PINHEIROS_SUL',      'Centro',   2.10),-- Rio Pinheiros (Níveis mais baixos)
    (NOW() - INTERVAL '3 days',  'RIO_PINHEIROS_SUL',      'Centro',   2.30),
    (NOW() - INTERVAL '1 day',   'RIO_PINHEIROS_SUL',      'Centro',   2.50),

   
    (NOW() - INTERVAL '7 days', 'RIO_TAMANDUATEI_LESTE', 'Centro', 3.10), -- Rio Tamanduateí (nível moderado)
    (NOW() - INTERVAL '3 days', 'RIO_TAMANDUATEI_LESTE', 'Centro', 3.50),

   
    (NOW() - INTERVAL '6 days', 'RIO_JAGUARE_NORTE', 'Montante', 2.90), -- Rio Jaguaré (nível instável)
    (NOW() - INTERVAL '2 days', 'RIO_JAGUARE_NORTE', 'Montante', 4.20),
    (NOW() - INTERVAL '20 days','RIO_JAGUARE_NORTE', 'Montante', 3.60),

   
    (NOW() - INTERVAL '500 days', 'RIO_JAGUARE_NORTE', 'Montante', 1.50), -- Leitura antiga (TESTE para NÃO incluir na Query 1)


    (NOW() - INTERVAL '400 days','RIO_TIETE_PONTE_CENTRO', 'Montante', 1.00);    -- Leitura antiga (Mais de 1 ano atrás) - NÃO deve aparecer na Query 1


-- -----------------------------
-- 5. ALERTAS DE AÇÃO (Base para Query 4)
-- -----------------------------
INSERT INTO Alerta_de_Acao (Data_Hora, Conteudo_da_Mensagem, Status_da_Resposta) VALUES
    ('2024-11-20 10:00:00', 'Risco iminente de transbordamento no Centro. Ação conjunta necessária.', 'Em andamento'),    -- Alerta 1: Caso Complexo (Muitas respostas)

    
    
    ('2024-11-25 14:00:00', 'Obstrução parcial identificada no Rio Pinheiros.', 'Concluído'),    -- Alerta 2: Caso Simples

    ('2024-11-18 08:00:00', 'Nível acima do esperado no Tamanduateí.', 'Concluído'),
    ('2024-11-27 16:30:00', 'Possível transbordamento no Jaguaré.', 'Em andamento'),

    ('2024-11-28 09:00:00', 'Alerta teste sem mobilização.', 'Pendente'),    -- Alerta 3: Sem resposta -> importante para testar LEFT JOIN

    ('2024-11-26 07:55:00', 'Obstrução detectada porém ainda sem envio de equipes.', 'Pendente'),
    ('2024-11-29 11:00:00', 'Chuvas intensas em vários pontos da cidade. Mobilização ampliada.', 'Em andamento'),

    ('2024-11-30 17:15:00', 'Alagamento intransitável próximo ao Bueiro da Faria Lima. Trânsito parado.', 'Em andamento'),    -- Crise Urbana em novos pontos (Bueiros)

    ('2024-11-30 17:45:00', 'Bueiro da Av. Reboucas com retorno de esgoto. Equipe de saneamento acionada.', 'Pendente'),

    ('2024-12-01 06:30:00', 'Cota de emergência atingida no Rio Aricanduva Leste. Risco alto.', 'Em andamento'),    -- Alertas Críticos em Rios (Conexão com novos Rios)

    ('2024-12-01 08:00:00', 'Vazão normalizada no Rio Verde Norte após abertura de comportas.', 'Concluído'),

    ('2024-11-22 09:00:00', 'Retirada de entulho no Córrego Pirajussara finalizada.', 'Concluído'),    -- Manutenção preventiva e Ocorrências menores (Córregos)

    ('2024-12-02 14:20:00', 'Denúncia de descarte irregular no Córrego Traição.', 'Pendente'), -- Outro bom caso para LEFT JOIN (sem resposta imediata)

    ('2024-12-03 03:00:00', 'Falha de comunicação com sensores da Zona Leste.', 'Pendente'),    -- Falha Sistêmica (Mensagem genérica)


    ('2024-11-29 12:00:00', 'Nível do Rio Tietê baixando lentamente. Monitoramento mantido.', 'Em andamento'),    -- Monitoramento contínuo (Atualização de casos antigos)

    ('2024-11-25 10:00:00', 'Limpeza de grade no Bueiro Rua XV realizada com sucesso.', 'Concluído');

-- 6. RELATÓRIOS (Cruzamento para Query 4)
-- IMPORTANTE: Usar exatamente o mesmo Timestamp do Alerta_de_Acao
-- -----------------------------

-- Relatórios da Equipe de Manutenção (EM)
INSERT INTO Relatorio_de_Acao_EM (Id_equipe, Id_alerta, Descricao_da_Intervencao, Resultados_Alcancados, Data_Hora) VALUES
    ('333.333.333-01', '2024-11-20 10:00:00', 'Instalação de barreiras de contenção.', 'Contenção realizada.', '2024-11-20 10:30:00'),     -- Alerta 1 (2 equipes responderam)

    ('333.333.333-02', '2024-11-20 10:00:00', 'Limpeza de detritos na grade de proteção.', 'Fluxo liberado.', '2024-11-20 11:00:00'),

    ('333.333.333-02', '2024-11-25 14:00:00', 'Remoção de tronco de árvore.', 'Obstrução removida.', '2024-11-25 14:45:00'),    -- Alerta 2 (1 equipe respondeu)


    ('333.333.333-01', '2024-11-18 08:00:00', 'Limpeza e remoção de lixo flutuante.', 'Fluxo normalizado.', '2024-11-18 09:10:00'),    -- Alerta adicional

    ('333.333.333-02', '2024-11-27 16:30:00', 'Instalação de barreiras preventivas.', 'Aguardando estabilização do nível.', '2024-11-27 17:00:00');


-- Relatórios da Defesa Civil (DC)
INSERT INTO Relatorio_de_Acao_DC (Id_defesacivil, Id_alerta, Descricao_da_Intervencao, Resultados_Alcancados, Data_Hora) VALUES
    ('222.222.222-01', '2024-11-20 10:00:00', 'Evacuação preventiva das casas ribeirinhas.', '10 famílias removidas.', '2024-11-20 10:15:00'),    -- Para o Alerta 1 (1 agente respondeu, chegou ANTES da manutenção)

    
    ('222.222.222-02', '2024-11-25 14:00:00', 'Monitoramento visual durante a operação.', 'Segurança garantida.', '2024-11-25 14:30:00'),    -- Para o Alerta 2 (1 agente respondeu)

    ('222.222.222-02', '2024-11-18 08:00:00', 'Monitoramento das margens ribeirinhas.', 'Sem evacuações necessárias.', '2024-11-18 09:00:00'),
    ('222.222.222-01', '2024-11-27 16:30:00', 'Avaliação de risco de inundação.', 'População alertada preventivamente.', '2024-11-27 17:10:00');

INSERT INTO Relatorio_de_Acao_DC (Id_defesacivil, Id_alerta, Descricao_da_Intervencao, Resultados_Alcancados, Data_Hora) VALUES
    ('222.222.222-01', '2024-11-25 14:00:00', 'Nova inspeção da Defesa Civil após a manutenção.', 'Situação estabilizada.', '2024-11-25 15:00:00'),
    ('222.222.222-02', '2024-11-29 11:00:00', 'Monitoramento de áreas críticas durante as chuvas intensas.', 'População orientada.', '2024-11-29 11:30:00');

INSERT INTO Manutencao (Bueiro, Equipe_de_Manutencao, Data_Hora, Tipo_de_Servico) VALUES
    ('BUEIRO_RUA_XV', '333.333.333-01', NOW() - INTERVAL '20 days', 'Limpeza preventiva do bueiro') , 
    ('BUEIRO_RUA_XV', '333.333.333-01', NOW() - INTERVAL '5 days',  'Desobstrução completa do bueiro'),

    ('BUEIRO_AV_PAULISTA', '333.333.333-01', NOW() - INTERVAL '15 days', 'Limpeza preventiva do bueiro'),
    ('BUEIRO_AV_PAULISTA', '333.333.333-01', NOW() - INTERVAL '6 days',  'Desobstrução após acúmulo de lixo'),

    ('BUEIRO_RUA_13_MAIO', '333.333.333-01', NOW() - INTERVAL '25 days', 'Limpeza preventiva do bueiro'),     -- BUEIRO_RUA_13_MAIO (Equipe de Manutenção)

    ('BUEIRO_RUA_13_MAIO', '333.333.333-01', NOW() - INTERVAL '8 days',  'Reforço de grade de proteção'),

    ('BUEIRO_VILA_NOVA', '333.333.333-02', NOW() - INTERVAL '18 days', 'Limpeza preventiva do bueiro'),     -- BUEIRO_VILA_NOVA (Equipe de Manutenção)

    ('BUEIRO_VILA_NOVA', '333.333.333-02', NOW() - INTERVAL '7 days',  'Desobstrução de detritos'),

    ('BUEIRO_PARQUE_CENTRAL', '333.333.333-02', NOW() - INTERVAL '12 days', 'Limpeza preventiva do bueiro'),     -- BUEIRO_PARQUE_CENTRAL (Equipe de Manutenção)

    ('BUEIRO_PARQUE_CENTRAL', '333.333.333-02', NOW() - INTERVAL '4 days',  'Desobstrução completa do bueiro');

INSERT INTO Alagamento (Ponto_Hidrologico, Data_Hora, Severidade, Extensao_da_Area_Afetada, Bairros_Afetados) VALUES
    ('BUEIRO_RUA_XV', NOW() - INTERVAL '3 days', 8,  50.00, 'Centro'),
    ('BUEIRO_RUA_XV', NOW() - INTERVAL '1 day',  9,  70.00, 'Centro'),

    ('BUEIRO_AV_PAULISTA', NOW() - INTERVAL '5 days', 8, 60.00, 'Centro'),     -- BUEIRO_AV_PAULISTA (última manutenção ~6 dias)

    ('BUEIRO_AV_PAULISTA', NOW() - INTERVAL '2 days', 9, 80.00, 'Centro'),

    ('BUEIRO_RUA_13_MAIO', NOW() - INTERVAL '6 days', 7, 40.00, 'Bela Vista'),     -- BUEIRO_RUA_13_MAIO (última manutenção ~8 dias)


    ('BUEIRO_VILA_NOVA', NOW() - INTERVAL '5 days', 8, 55.00, 'Vila Nova'),     -- BUEIRO_VILA_NOVA (última manutenção ~7 dias)


    ('BUEIRO_PARQUE_CENTRAL', NOW() - INTERVAL '3 days', 9, 70.00, 'Parque Central');     -- BUEIRO_PARQUE_CENTRAL (última manutenção ~4 dias)


INSERT INTO Monitora (Ponto_Hidrologico, Defesa_Civil) VALUES
    ('BUEIRO_RUA_XV',         '222.222.222-01'),
    ('CORREGO_SAPATEIRO',     '222.222.222-01'),
    ('RIO_PINHEIROS_SUL',     '222.222.222-01'),
    ('BUEIRO_AV_PAULISTA',    '222.222.222-01'),
    ('BUEIRO_PARQUE_CENTRAL', '222.222.222-01'),
    ('BUEIRO_RUA_XV',         '222.222.222-02'),
    ('CORREGO_SAPATEIRO',     '222.222.222-02'),
    ('BUEIRO_AV_PAULISTA',    '222.222.222-02');
