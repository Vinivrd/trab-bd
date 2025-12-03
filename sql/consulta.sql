-- 1 Monitoramento de Níveis de Água em Rios nos Últimos 12 Meses
SELECT
    ph.Localizacao_Geografica,
    AVG(l.Valor)      AS media_nivel_agua,
    COUNT(*)          AS qtd_leituras
FROM Ponto_Hidrologico ph
JOIN Sensor s
      ON s.Ponto_Hidrologico = ph.Localizacao_Geografica
JOIN Leitura l
      ON l.Sensor_Ponto_Hidrologico = s.Ponto_Hidrologico
     AND l.Sensor_Posicao          = s.Posicao
WHERE ph.Tipo = 'Rio'
  AND s.Tipo = 'Nível de Água'
  AND l.Data_Hora >= NOW() - INTERVAL '365 days'
GROUP BY ph.Localizacao_Geografica
ORDER BY media_nivel_agua DESC, qtd_leituras DESC
LIMIT 5;


-- 2 Bueiros com muitas manutenções e ainda com alagamentos fortes depois da última manutenção
WITH manutencao_bueiro AS (
    SELECT
        m.Bueiro              AS ponto_bueiro,
        COUNT(*)              AS qtd_manutencoes,
        MAX(m.Data_Hora)      AS ultima_manutencao
    FROM Manutencao m
    WHERE m.Data_Hora >= NOW() - INTERVAL '6 months'
    GROUP BY m.Bueiro
)
SELECT
    b.Ponto_Hidrologico              AS bueiro,
    mb.qtd_manutencoes,
    mb.ultima_manutencao,
    COUNT(a.Data_Hora)               AS qtd_alagamentos_pos
FROM manutencao_bueiro mb
JOIN Bueiro b
      ON b.Ponto_Hidrologico = mb.ponto_bueiro
LEFT JOIN Alagamento a
      ON a.Ponto_Hidrologico = b.Ponto_Hidrologico
     AND a.Data_Hora > mb.ultima_manutencao
     AND a.Severidade >= 7
GROUP BY
    b.Ponto_Hidrologico,
    mb.qtd_manutencoes,
    mb.ultima_manutencao
HAVING
    mb.qtd_manutencoes >= 2
    AND COUNT(a.Data_Hora) > 0
ORDER BY
    mb.qtd_manutencoes DESC,
    qtd_alagamentos_pos DESC;



--- Query3: Análise de Performance: Agilidade e Volume de Resposta da Defesa Civil
WITH primeira_acao_dc AS (
    SELECT
        r.Id_defesacivil,
        r.Id_alerta,
        MIN(r.Data_Hora) AS primeira_acao_dc
    FROM Relatorio_de_Acao_DC r
    GROUP BY
        r.Id_defesacivil,
        r.Id_alerta
)
SELECT
    dc.Usuario AS id_defesa_civil,
    dc.Nome,
    COUNT(DISTINCT p.Id_alerta) AS qtd_alertas_respondidos,
    AVG(p.primeira_acao_dc - a.Data_Hora) AS tempo_medio_resposta
FROM Defesa_Civil dc
JOIN primeira_acao_dc p
      ON p.Id_defesacivil = dc.Usuario
JOIN Alerta_de_Acao a
      ON a.Data_Hora = p.Id_alerta
GROUP BY
    dc.Usuario,
    dc.Nome
ORDER BY
    qtd_alertas_respondidos DESC,
    tempo_medio_resposta;


-- 4 Alertas de Ação que já possuem relatório da Equipe de Manutenção e da Defesa Civil
WITH em AS (
    SELECT
        Id_alerta,
        COUNT(*) AS qtd_em,
        MIN(Data_Hora) AS primeira_acao_em
    FROM Relatorio_de_Acao_EM
    GROUP BY Id_alerta
),
dc AS (
    SELECT
        Id_alerta,
        COUNT(*) AS qtd_dc,
        MIN(Data_Hora) AS primeira_acao_dc
    FROM Relatorio_de_Acao_DC
    GROUP BY Id_alerta
) 
SELECT
    a.Data_Hora AS id_alerta,
    a.Conteudo_da_Mensagem,
    a.Status_da_Resposta,
    em.qtd_em,
    dc.qtd_dc,
    em.primeira_acao_em,
    dc.primeira_acao_dc,
    LEAST(em.primeira_acao_em, dc.primeira_acao_dc) - a.Data_Hora AS tempo_resposta
FROM Alerta_de_Acao a
LEFT JOIN em ON em.Id_alerta = a.Data_Hora
LEFT JOIN dc ON dc.Id_alerta = a.Data_Hora
ORDER BY a.Data_Hora DESC;



-- 5 DIVISÃO RELACIONAL:
--  Defesa Civil que monitora TODOS os pontos que possuem sensor pluviométrico
SELECT
    dc.Usuario,
    dc.Nome
FROM Defesa_Civil dc
WHERE NOT EXISTS (
    SELECT 1
    FROM Ponto_Hidrologico ph
    JOIN Sensor s
          ON s.Ponto_Hidrologico = ph.Localizacao_Geografica
    WHERE s.Tipo = 'Pluviométrico'
      AND NOT EXISTS (
          SELECT 1
          FROM Monitora m
          WHERE m.Ponto_Hidrologico = ph.Localizacao_Geografica
            AND m.Defesa_Civil      = dc.Usuario
      )
);