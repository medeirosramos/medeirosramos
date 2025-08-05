:: curl -o py.cmd https://raw.githubusercontent.com/medeirosramos/medeirosramos/refs/heads/main/scripts/configPython.cmd && py.cmd && del py.cmd
:: curl -o py.cmd https://medeirosramos.github.io/medeirosramos/scripts/configPython.cmd && py.cmd && del py.cmd

@echo off
setlocal EnableDelayedExpansion
set REQUIREMENTS=requirements.txt

:: Define versão padrão do Python
set DEFAULT_PYTHON_VERSION=3.12.4

:: Verifica se um argumento foi passado
if "%~1"=="" (
    set "VERSAO_PYTHON=%DEFAULT_PYTHON_VERSION%"
) else (
    set "VERSAO_PYTHON=%~1"
)

echo ====================================
echo [INFO] Criando arquivos de configuração
echo ====================================

:: Cria arquivo ativar_ambiente.bat
if not exist "ativar_ambiente.bat" (
    echo [INFO] Criando arquivo ativar_ambiente.bat...
    (
        echo REM curl -o py.cmd https://raw.githubusercontent.com/medeirosramos/medeirosramos/refs/heads/main/scripts/configPython.cmd ^&^& py.cmd ^&^& del py.cmd
        echo REM curl -o py.cmd https://medeirosramos.github.io/medeirosramos/scripts/configPython.cmd ^&^& py.cmd ^&^& del py.cmd
        echo.
        echo @echo off
        echo.
        echo echo "Executando Ativação do Conda"
        echo call conda activate py312
        echo.
        echo echo "Executando Ativação do ENV"
        echo call .\.venv\Scripts\activate
    ) > ativar_ambiente.bat
    echo [INFO] Arquivo ativar_ambiente.bat criado com sucesso.
) else (
    echo [INFO] Arquivo ativar_ambiente.bat já existe. Nenhuma ação necessária.
)

:: Cria Dockerfile se não existir
if not exist "Dockerfile" (
    echo [INFO] Criando Dockerfile...
    (
        echo FROM python:%VERSAO_PYTHON%
        echo LABEL maintainer="rodrigoramos@tjrn.jus.br"
        echo ENV DEBIAN_FRONTEND=noninteractive
        echo ^# RUN apt-get update && apt-get install -y firefox-esr 
        echo ENV DISPLAY=:0
        echo ENV APP_HOME=!APP_HOME!
        echo RUN mkdir -p !APP_HOME!
        echo COPY . !APP_HOME!/
        echo WORKDIR !APP_HOME!/
        echo RUN pip install --no-cache-dir -r !APP_HOME!/requirements.txt
        echo # ENV LANG C.UTF-8
        echo ENV LANG=C.UTF-8
        echo # ENV LC_ALL C.UTF-8
        echo ENV LC_ALL=C.UTF-8
        echo ENV PYTHONUNBUFFERED=1
        echo CMD [ "python3", "!APP_HOME!/main.py" ]
    ) > Dockerfile
    echo [INFO] Dockerfile criado com sucesso.
) else (
    echo [INFO] Dockerfile já existe. Nenhuma ação necessária.
)

:: Cria arquivo .dockerignore se não existir
if not exist ".dockerignore" (
    echo [INFO] Criando arquivo .dockerignore...
    (
        echo .venv/
        echo __pycache__/
        echo *.pyc
        echo *.pyo
        echo *.pyd
        echo *.db
        echo *.sqlite3
        echo *.log
        echo *.tar
        echo *.gz
        echo *.zip
        echo *.egg-info
        echo venv/
        echo .env
        echo .env.*   
        echo .pytest_cache/
        echo .mypy_cache/
        echo .coverage
        echo .idea/
        echo .vscode/
        echo .DS_Store
        echo .git/
        echo .gitignore
    ) > .dockerignore
    echo [INFO] Arquivo .dockerignore criado com sucesso.
) else (
    echo [INFO] Arquivo .dockerignore já existe. Nenhuma ação necessária.
)

:: Cria o arquivo .gitignore se não existir
if not exist ".gitignore" (
    echo [INFO] Criando arquivo .gitignore...
    (
        echo .venv/
        echo __pycache__/
        echo *.pyc
        echo *.pyo
        echo *.pyd
        echo *.db
        echo *.sqlite3
        echo *.log
        echo *.tar
        echo *.gz
        echo *.zip
        echo *.egg-info
        echo venv/
        echo .env
        echo .env.*
        echo .pytest_cache/
        echo .mypy_cache/
        echo .coverage
        echo .idea/
        echo .vscode/
        echo .DS_Store
        echo .git/
        ) > .gitignore
    echo [INFO] Arquivo .gitignore criado com sucesso.
) else (
    echo [INFO] Arquivo .gitignore já existe. Nenhuma ação necessária.
)  


:: Cria arquivo requirements.txt se não existir
if not exist "%REQUIREMENTS%" (
    echo [INFO] Criando arquivo %REQUIREMENTS%...
    (
        echo # Dependências do projeto
        echo # Adicione suas dependências aqui, por exemplo:
        echo "pandas>=2.1.0"
        echo "requests>=2.31.0"
        echo "SQLAlchemy>=1.4.47"
        echo "psycopg2-binary>=2.9.9  # usar psycopg2-binary evita a compilação local"
        echo "openpyxl>=3.1.3"
        echo "python-dotenv>=0.21.1"
        echo "urllib3>=1.26.16"
        echo "pytest>=7.4.4"
        echo # Adicione outras dependências conforme necessário
    ) > %REQUIREMENTS%
    echo [INFO] Arquivo %REQUIREMENTS% criado com sucesso.
) else (
    echo [INFO] Arquivo %REQUIREMENTS% já existe. Nenhuma ação necessária.
)  



echo ====================================
echo [INFO] Iniciando configuração do ambiente
echo ====================================

:: Verifica se o conda está disponível
where conda >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Conda não encontrado no PATH. Instale o Anaconda ou Miniconda.
    goto :EOF
)

echo [INFO] Conda detectado.

:: Verifica se o ambiente py312 já existe
call conda env list | findstr /C:"py312" >nul
if errorlevel 1 (
    echo [INFO] Ambiente py312 não encontrado. Criando agora...
    call conda create -y -n py312 python=%VERSAO_PYTHON%
) else (
    echo [INFO] Ambiente py312 já existe.
)

:: Desativa qualquer ambiente ativo
call conda deactivate >nul 2>&1

:: Ativa o ambiente conda
echo [INFO] Ativando o ambiente py312...
call conda activate py312

:: Cria venv dentro do ambiente conda (apenas se não existir)
if not exist ".venv\" (
    echo [INFO] Criando ambiente virtual .venv dentro do py312...
    python -m venv .venv
    if errorlevel 1 (
        echo [ERRO] Falha ao criar o ambiente .venv.
        goto :EOF
    )
) else (
    echo [INFO] Ambiente .venv já existe.
)

:: Ativa o venv (dentro do conda)
echo [INFO] Ativando o ambiente .venv...
call .\.venv\Scripts\activate

:: Instala dependências, se existirem
if exist "%REQUIREMENTS%" (
    echo [INFO] Instalando dependências do %REQUIREMENTS%...
    pip install -r %REQUIREMENTS%
) else (
    echo [AVISO] %REQUIREMENTS% não encontrado. Pulando instalação de dependências.
)




endlocal
echo [INFO] Configuração do ambiente concluída com sucesso.
echo ====================================

:: Fim do script
pause
