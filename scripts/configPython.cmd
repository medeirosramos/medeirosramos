REM curl -o py.cmd https://raw.githubusercontent.com/medeirosramos/medeirosramos/refs/heads/main/scripts/configPython.cmd && py.cmd && del py.cmd
REM curl -o py.cmd https://medeirosramos.github.io/medeirosramos/scripts/configPython.cmd && py.cmd && del py.cmd

@echo off
setlocal
set REQUIREMENTS=requirements.txt
set VERSAO_PYTHON=3.12.4

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
