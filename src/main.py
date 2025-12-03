#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Protótipo simples em linha de comando para o sistema de monitoramento.

Funcionalidades mínimas exigidas pelo projeto:

- Cadastro de dados:
  * Cadastro de novo cidadão, inserindo em Usuario (tipo "Cidadão")
    e em Cidadao, dentro de uma transação explícita.

- Consulta parametrizada ao banco:
  * Consulta dos maiores níveis médios de água em rios, considerando
    um período parametrizado pelo usuário (N últimos dias).

Requisitos atendidos:
- Uso explícito de comandos SQL (sem ORM).
- SQL parametrizado para evitar SQL Injection.
- Controle transacional simples (commit/rollback) e tratamento de erros.
"""

import os
import sys
import configparser
from datetime import datetime, timedelta

import psycopg2

from psycopg2 import OperationalError, Error
from psycopg2.errors import UniqueViolation
from psycopg2.errors import CheckViolation
from tabulate import tabulate
from dotenv import load_dotenv


def load_config() -> configparser.SectionProxy:
    """Carrega configurações de banco a partir de config.ini.

    Espera um arquivo config.ini na raiz do projeto, baseado em
    config.example.ini.
    """

    load_dotenv()

    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    ini_path = os.path.join(base_dir, "config.ini")

    if not os.path.exists(ini_path):
        print(f"Arquivo de configuração não encontrado: {ini_path}")
        print("Copie config.example.ini para config.ini e preencha com seus dados.")
        sys.exit(1)

    config = configparser.ConfigParser()
    config.read(ini_path)

    if "database" not in config:
        print("Seção [database] não encontrada em config.ini.")
        sys.exit(1)

    return config["database"]


def create_connection():
    """Cria conexão com o SGBD usando psycopg2 (PostgreSQL).

    O tipo do SGBD é lido de config.ini (chave type). Neste protótipo,
    apenas PostgreSQL está implementado.
    """

    db_cfg = load_config()
    db_type = db_cfg.get("type", "postgresql").lower()

    if db_type == "postgresql":
        try:
            conn = psycopg2.connect(
                host=db_cfg.get("host", "localhost"),
                port=db_cfg.getint("port", 5432),
                dbname=db_cfg.get("database"),
                user=db_cfg.get("user"),
                password=db_cfg.get("password"),
            )
            # Controle transacional manual (commit/rollback explícitos)
            conn.autocommit = False
            return conn
        except OperationalError as exc:
            print("Erro ao conectar ao PostgreSQL:")
            print(exc)
            sys.exit(1)




def cadastrar_cidadao(conn) -> None:
    """Cadastra um novo cidadão.

    Passos (tudo em uma única transação):
    1) Insere em Usuario com Tipo = 'Cidadão'.
    2) Usa o CPF formatado para inserir em Cidadao (Usuario, Nome).
    """
    
    print("\n=== Cadastro de Cidadão ===")
    nome = input("Nome completo do cidadão: ").strip()
    
    # Manter a instrução de entrada clara para o usuário
    cpf_formatado = input("CPF (Obrigatório o formato 999.999.999-99): ").strip()

    if not nome:
        print("Nome não pode ser vazio.")
        return
    if not cpf_formatado:
        print("CPF não pode ser vazio.")
        return

    # O valor para o banco de dados é a própria string formatada
    cpf_valor_bd = cpf_formatado 

    cur = conn.cursor()
    try:
        # 1) Insere na tabela Usuario com a string formatada
        cur.execute(
            "INSERT INTO Usuario (CPF, Tipo) VALUES (%s, %s)",
            (cpf_valor_bd, "Cidadão"),
        )

        # 2) Insere na tabela Cidadao usando a string formatada como chave estrangeira
        cur.execute(
            "INSERT INTO Cidadao (Usuario, Nome) VALUES (%s, %s)",
            (cpf_valor_bd, nome),
        )

        # Tudo ocorreu bem: efetiva a transação
        conn.commit()
        print(f"Cidadão cadastrado com sucesso. CPF: {cpf_valor_bd}")
        
    # 1. Trata a exceção de CPF já existente (Chave Primária/Única)
    except UniqueViolation:
        conn.rollback()
        print("Já existe um usuário cadastrado com esse CPF. Escolha outro CPF.")
        
    # 2. 🚨 Trata a exceção de violação do CHECK Constraint (Formato ou Regras)
    except CheckViolation:
        conn.rollback()
        print("CPF inválido. O formato deve ser 999.999.999-99 e/ou não atende às regras de validação do banco de dados.")
        
    # 3. Trata outros erros gerais do SGBD (erros de sintaxe, conexão, etc.)
    except Error as exc:
        conn.rollback()
        print("Erro ao cadastrar cidadão. Transação desfeita.")
        print(f"Detalhes do erro: {exc}")
        
    finally:
        cur.close()

def consultar_maiores_niveis_rios(conn) -> None:
    """Consulta níveis médios de água em rios em uma janela de dias.

    Baseada na consulta 1 do arquivo consulta.sql, mas com o número de dias
    (janela de tempo) recebido como parâmetro do usuário.
    """

    print("\n=== Consulta: Maiores níveis médios de água em rios ===")
    dias_str = input("Considerar últimos quantos dias? [padrão: 7] ").strip()

    if not dias_str:
        dias = 7
    else:
        try:
            dias = int(dias_str)
            if dias <= 0:
                raise ValueError
        except ValueError:
            print("Número de dias inválido. Informe um inteiro positivo.")
            return

    limite = datetime.now() - timedelta(days=dias)

    cur = conn.cursor()
    try:
        # Consulta parametrizada: o limite de data/hora vem de variável Python
        cur.execute(
            """
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
              AND l.Data_Hora >= %s
            GROUP BY ph.Localizacao_Geografica
            HAVING COUNT(*) >= 1
            ORDER BY media_nivel_agua DESC, qtd_leituras DESC
            """,
            (limite,),
        )

        rows = cur.fetchall()
        if not rows:
            print("Nenhum resultado encontrado para o período informado.")
            return

        headers = [
            "Ponto Hidrológico",
            "Média Nível de Água",
            "Quantidade de Leituras",
        ]

        print()
        print(tabulate(rows, headers=headers, tablefmt="psql", floatfmt=".2f"))
    except Error as exc:
        print("Erro ao executar consulta.")
        print(exc)
    finally:
        cur.close()


def main_menu(conn) -> None:
    """Exibe o menu principal em linha de comando."""

    while True:
        print("\n=== Sistema de Monitoramento de Enchentes ===")
        print("1) Cadastrar novo cidadão")
        print("2) Consultar maiores níveis médios de água em rios")
        print("0) Sair")

        opcao = input("Escolha uma opção: ").strip()

        if opcao == "1":
            cadastrar_cidadao(conn)
        elif opcao == "2":
            consultar_maiores_niveis_rios(conn)
        elif opcao == "0":
            print("Encerrando sistema.")
            break
        else:
            print("Opção inválida. Tente novamente.")


def main() -> None:
    """Função principal: cria conexão e inicia o menu."""

    conn = create_connection()
    try:
        main_menu(conn)
    finally:
        conn.close()


if __name__ == "__main__":
    main()

