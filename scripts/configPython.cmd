:: curl -o py.cmd https://raw.githubusercontent.com/medeirosramos/medeirosramos/refs/heads/main/scripts/configPython.cmd && py.cmd && del py.cmd
:: curl -o py.cmd https://medeirosramos.github.io/medeirosramos/scripts/configPython.cmd && py.cmd && del py.cmd

@echo off
:: setlocal EnableDelayedExpansion
setlocal
set REQUIREMENTS=requirements.txt

:: Define versão padrão do Python
set DEFAULT_PYTHON_VERSION=3.12.4

:: Verifica se um argumento foi passado
if "%~1"=="" (
    set "VERSAO_PYTHON=%DEFAULT_PYTHON_VERSION%"
) else (
    set "VERSAO_PYTHON=%~1"
)
:: Define nome do ambiente conda
echo [INFO] Versão do Python selecionada: %VERSAO_PYTHON%
set "NOME_AMBIENTE=py_%VERSAO_PYTHON:.=_%"
echo %NOME_AMBIENTE%

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
        echo call conda activate %NOME_AMBIENTE%
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
        echo ENV DISPLAY=:0
        echo ENV APP_HOME /opt/app
        echo RUN mkdir -p $APP_HOME
        echo COPY . $APP_HOME/
        echo WORKDIR $APP_HOME/
        echo RUN pip install --no-cache-dir -r $APP_HOME/requirements.txt
        echo # ENV LANG C.UTF-8
        echo ENV LANG=C.UTF-8
        echo # ENV LC_ALL C.UTF-8
        echo ENV LC_ALL=C.UTF-8
        echo ENV PYTHONUNBUFFERED=1
        echo CMD [ "python3", "$APP_HOME/main.py" ]
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

:: Cria o arquivo .gitignore se não existir
if not exist ".flake8" (
    echo [INFO] Criando arquivo .flake8...
    (
        echo "[flake8]"
        echo "max-line-length = 120"
        echo "ignore = E501, W503, F401, F821, F841, F811, F541"
        echo "exclude = venv, migrations, __pycache__"
        echo "select = F"
        echo "; | Código | Significado resumido                                              |"
        echo "; | ------ | ----------------------------------------------------------------- |"
        echo "; | F401   | Imported but unused (importação não usada)                        |"
        echo "; | F821   | Undefined name (nome usado não definido)                          |"
        echo "; | F841   | Local variable assigned but never used (variável local não usada) |"
        echo "; | F811   | Redefinition of unused name                                       |"
        echo "; | F541   | f-string missing placeholders                                     |"
        echo 
        ) > .flake8
    echo [INFO] Arquivo .flake8 criado com sucesso.
) else (
    echo [INFO] Arquivo .flake8 já existe. Nenhuma ação necessária.
)  

:: Cria o arquivo .gitlab-ci.yml se não existir
if not exist ".gitlab-ci.yml" (
    echo [INFO] Criando arquivo .gitlab-ci.yml...
    (
        echo stages: 
        echo.  - lint
        echo.  - test
        echo.  - build
        echo.  - scan
        echo.  # - deploy
        echo.
        echo variables:
        echo.  APP_NAME: presos-etl-siapen
        echo.  IMAGE_NAME: presos/%%APP_NAME%%
        echo.  PYTHON_VERSION: %VERSAO_PYTHON%
        echo.  CI_REGISTRY: harbor-test.homologacao.tjrn.jus.br
        echo.  CI_IMAGE: %%CI_REGISTRY%%/ia/%%IMAGE_NAME%%:%%IMAGE_TAG%%
        echo.  IMAGE_TAG: %%CI_COMMIT_REF_SLUG%%
        echo.  DOCKER_HOST: tcp://docker:2375
        echo.  DOCKER_TLS_CERTDIR: ""  # Desativa TLS para facilitar a comunicação
        echo.  DOCKER_DRIVER: overlay2
        echo.
        echo lint_code:
        echo.  stage: lint
        echo.  image: python:%%PYTHON_VERSION%%
        echo.  script:
        echo.    - pip install flake8
        echo.    - flake8 .
        echo.
        echo run_tests:
        echo.  stage: test
        echo.  image: python:%%PYTHON_VERSION%%
        echo.  before_script:
        echo.    - python -m pip install --upgrade pip
        echo.    - pip install -r requirements.txt ^|^| pip install .
        echo.  script:
        echo.    - set PYTHONPATH=. ^&^& pytest tests/ --junitxml=report.xml
        echo.  artifacts:
        echo.    reports:
        echo.      junit: report.xml
        echo.    expire_in: 1 week
        echo.
        echo build_image:
        echo.  stage: build
        echo.  image: docker:latest
        echo.  services:
        echo.    - name: docker:dind
        echo.      alias: docker
        echo.  before_script:
        echo.    - docker system prune -af ^|^| true
        echo.    - echo %%DOCKER_USER%%
        echo.    - echo "%%DOCKER_PASSWORD%%" ^| docker login -u "%%DOCKER_USER%%" --password-stdin
        echo.  script:
        echo.    - docker info
        echo.    - docker build --no-cache -t %%CI_IMAGE%% .
        echo.    - docker save %%CI_IMAGE%% -o image.tar
        echo.  artifacts:
        echo.    paths:
        echo.      - image.tar
        echo.    expire_in: 1 hour
        echo.
        echo push_image_harbor:
        echo.  stage: build
        echo.  image: docker:latest
        echo.  services:
        echo.    - name: docker:dind
        echo.      alias: docker
        echo.  dependencies:
        echo.    - build_image
        echo.  before_script:
        echo.    - echo %%HARBOR_USER%%
        echo.    - echo "%%HARBOR_PASSWORD%%" ^| docker login -u "%%HARBOR_USER%%" --password-stdin %%CI_REGISTRY%%
        echo.  script:
        echo.    - docker load -i image.tar
        echo.    - docker push %%CI_IMAGE%%
    ) > .gitlab-ci.yml
    echo [INFO] Arquivo .gitlab-ci.yml criado com sucesso.
) else (
    echo [INFO] Arquivo .gitlab-ci.yml já existe. Nenhuma ação necessária.
)

:: Verifica se a pasta tests existe, se não, cria
if not exist "tests" (
    echo [INFO] Criando diretório tests...
    mkdir tests
)

:: Verifica se o arquivo tests/test_01.py existe, se não, cria com conteúdo padrão
if not exist "tests\test_01.py" (
    echo [INFO] Criando arquivo tests\test_01.py...
    (
        echo # tests/test_01.py
        echo import sys
        echo import os
        echo sys.path.insert^(0, os.path.abspath^('.'^)^)
        echo. 
        echo import unittest
        echo # from presos_etl_siapen.api_Siapen import test_api_siapen
        echo.
        echo.
        echo class TestModulo1(unittest.TestCase):
        echo.    def test_padrao(self):
        echo.        # self.assertEqual(test_api_dashboard(), "resultado esperado")
        echo.        # assert test_api_siapen() == None
        echo.        assert None == None
    ) > tests\test_01.py
    echo [INFO] Arquivo test_01.py criado com sucesso.
) else (
    echo [INFO] Arquivo test_01.py já existe. Nenhuma ação necessária.
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
        echo "setuptools>=65.5.1"
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

:: Verifica se o ambiente %NOME_AMBIENTE% já existe
call conda env list | findstr /C:%NOME_AMBIENTE% >nul
if errorlevel 1 (
    echo [INFO] Ambiente %NOME_AMBIENTE% não encontrado. Criando agora...
    call conda create -y -n %NOME_AMBIENTE% python=%VERSAO_PYTHON%
) else (
    echo [INFO] Ambiente %NOME_AMBIENTE% já existe.
)

:: Desativa qualquer ambiente ativo
call conda deactivate >nul 2>&1

:: Ativa o ambiente conda
echo [INFO] Ativando o ambiente %NOME_AMBIENTE%...
call conda activate %NOME_AMBIENTE%

:: Cria venv dentro do ambiente conda (apenas se não existir)
if not exist ".venv\" (
    echo [INFO] Criando ambiente virtual .venv dentro do %NOME_AMBIENTE%...
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
