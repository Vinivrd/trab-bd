# Sistema de Gerenciamento de Biblioteca Universitária
## Projeto de Banco de Dados - Fase 3

### Descrição
Sistema completo de gerenciamento de biblioteca universitária com funcionalidades de cadastro, empréstimo, reserva e consulta de livros.

### Estrutura do Projeto
```
trab-bd/
├── sql/
│   ├── esquema.sql      # Script de criação do banco de dados
│   ├── dados.sql        # Script de alimentação inicial
│   └── consultas.sql    # Consultas complexas (mínimo 5)
├── src/
│   ├── main.py          # Programa principal
│   ├── database.py      # Módulo de conexão com BD
│   ├── cadastro.py      # Funcionalidades de cadastro
│   └── consultas.py     # Funcionalidades de consulta
├── requirements.txt     # Dependências Python
├── config.example.ini   # Exemplo de configuração
└── README.md           # Este arquivo
```

### Requisitos do Sistema
- **SGBD**: PostgreSQL 12+ ou Oracle 11g+
- **Linguagem**: Python 3.8+
- **Bibliotecas**: psycopg2 (PostgreSQL) ou cx_Oracle (Oracle)

### Instalação

#### 1. Clonar o repositório
```bash
git clone <url-do-repositorio>
cd trab-bd
```

#### 2. Instalar dependências
```bash
pip install -r requirements.txt
```

#### 3. Configurar banco de dados
Copie o arquivo de configuração de exemplo:
```bash
cp config.example.ini config.ini
```

Edite `config.ini` com suas credenciais do banco de dados.

#### 4. Criar o banco de dados
```bash
# Para PostgreSQL
psql -U seu_usuario -d seu_banco -f sql/esquema.sql
psql -U seu_usuario -d seu_banco -f sql/dados.sql
```

### Execução
```bash
python src/main.py
```

### Funcionalidades Implementadas

#### 1. Cadastro de Dados
- Cadastro de novos livros
- Cadastro de novos usuários
- Registro de empréstimos
- Tratamento completo de erros e validações

#### 2. Consultas Parametrizadas
- Busca de livros por título/autor
- Consulta de histórico de empréstimos
- Verificação de disponibilidade
- Relatórios estatísticos

### Consultas SQL Implementadas

1. **Consulta com Junção Interna e Externa**: Livros e seus empréstimos
2. **Consulta com Agrupamento**: Estatísticas de empréstimos por categoria
3. **Consulta Aninhada Correlacionada**: Usuários com mais empréstimos que a média
4. **Consulta Aninhada Não Correlacionada**: Livros nunca emprestados
5. **Consulta com Divisão Relacional**: Usuários que emprestaram livros de todas as categorias

### Segurança
- Proteção contra SQL Injection usando prepared statements
- Controle transacional para operações críticas
- Validação de entrada de dados

### Autores
[Seu Nome e Grupo]

### Data de Entrega
03/12/2025
