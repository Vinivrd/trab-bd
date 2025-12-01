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
    ('RIO_TIETE_PONTE_CENTRO',    'Rio'),  
    ('RIO_PINHEIROS_SUL',         'Rio'), 
    ('RIO_TAMANDUATEI_LESTE', 'Rio'),
    ('RIO_JAGUARE_NORTE', 'Rio'),   
    ('CORREGO_SAPATEIRO',         'Corrego'),
    ('BUEIRO_RUA_XV',             'Bueiro');


INSERT INTO Rio (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('RIO_TIETE_PONTE_CENTRO',    5000.00),
    ('RIO_PINHEIROS_SUL',         4500.00),
    ('RIO_TAMANDUATEI_LESTE', 3800.00),
    ('RIO_JAGUARE_NORTE', 2500.00);

INSERT INTO Corrego (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('CORREGO_SAPATEIRO', 1200.00);

INSERT INTO Bueiro (Ponto_Hidrologico, Capacidade_de_Drenagem) VALUES
    ('BUEIRO_RUA_XV', 80.00);

-- -----------------------------
-- 3. SENSORES (Necessários para a tabela Leitura)
-- -----------------------------
INSERT INTO Sensor (Ponto_Hidrologico, Posicao, Tipo) VALUES
    ('RIO_TIETE_PONTE_CENTRO', 'Montante', 'Nível de Água'), -- Alvo Query 1
    ('RIO_TIETE_PONTE_CENTRO', 'Jusante',  'Nível de Água'), -- Alvo Query 1
    ('RIO_PINHEIROS_SUL',      'Centro',   'Nível de Água'), -- Alvo Query 1
     ('RIO_TAMANDUATEI_LESTE', 'Centro', 'Nível de Água'), -- Alvo Query 1
    ('RIO_JAGUARE_NORTE', 'Montante', 'Nível de Água'), -- Alvo Query 1
    ('BUEIRO_RUA_XV',          'Entrada',  'Pluviométrico');

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

    ('2024-11-26 07:55:00', 'Obstrução detectada porém ainda sem envio de equipes.', 'Pendente');
    -----------------------------------------------------------------------
   
   


-- -----------------------------
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
