-- 1) Maiores níveis médios de água em rios nos últimos 7 dias
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
  AND l.Data_Hora >= NOW() - INTERVAL '7 days'
GROUP BY ph.Localizacao_Geografica
HAVING COUNT(*) >= 10
ORDER BY media_nivel_agua DESC, qtd_leituras DESC
LIMIT 5;


-- 2) Bueiros com muitas manutenções e ainda com alagamentos fortes depois da última manutenção
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


-- 3) Desempenho da Defesa Civil: pontos monitorados e alagamentos associados ok
SELECT
    dc.Usuario                         AS id_defesa_civil,
    dc.Nome,
    COUNT(DISTINCT m.Ponto_Hidrologico) AS qtd_pontos_monitorados,
    COUNT(DISTINCT a.Data_Hora)         AS qtd_alagamentos_registrados,
    COALESCE(AVG(a.Severidade), 0)      AS severidade_media
FROM Defesa_Civil dc
LEFT JOIN Monitora m
       ON m.Defesa_Civil = dc.Usuario
LEFT JOIN Alagamento a
       ON a.Ponto_Hidrologico = m.Ponto_Hidrologico
GROUP BY
    dc.Usuario,
    dc.Nome
HAVING
    COUNT(DISTINCT m.Ponto_Hidrologico) > 0
ORDER BY
    qtd_alagamentos_registrados DESC,
    severidade_media DESC;


-- 4) Alertas de Ação que já possuem relatório da Equipe de Manutenção e da Defesa Civil   ok
WITH em AS (
    SELECT
        Id_alerta,
        COUNT(*)           AS qtd_em,
        MIN(Data_Hora)     AS primeira_acao_em
    FROM Relatorio_de_Acao_EM
    GROUP BY Id_alerta
),
dc AS (
    SELECT
        Id_alerta,
        COUNT(*)           AS qtd_dc,
        MIN(Data_Hora)     AS primeira_acao_dc
    FROM Relatorio_de_Acao_DC
    GROUP BY Id_alerta
)
SELECT
    a.Data_Hora              AS id_alerta,
    a.Conteudo_da_Mensagem,
    a.Status_da_Resposta,
    em.qtd_em,
    dc.qtd_dc,
    em.primeira_acao_em,
    dc.primeira_acao_dc
FROM Alerta_de_Acao a
JOIN em
      ON em.Id_alerta = a.Data_Hora
JOIN dc
      ON dc.Id_alerta = a.Data_Hora
ORDER BY a.Data_Hora DESC;


-- 5) DIVISÃO RELACIONAL:
--    Defesa Civil que monitora TODOS os pontos que possuem sensor pluviométrico
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