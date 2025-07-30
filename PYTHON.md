
### Configurando Ambiente MiniConda no Windows

https://docs.anaconda.com/miniconda/install/#quick-command-line-install

```
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -o .\miniconda.exe
start /wait "" .\miniconda.exe /S
del .\miniconda.exe
```

Adicionar a váriavel de ambiente PATH o caminho: `C:\Users\xxxx\AppData\Local\miniconda3\Scripts\`

Comandos devem ser executados no prompt (color 0A):
Criar ambiente virtual: `conda create --name nome_ambiente` 
Lista de programas instalados: `conda list`  

Listar ambientes criados: `conda env list`  
Desativar ambiente virtual: `conda deactivate`  
Ativar ambiente virtual:  `conda activate nome_ambiente`  

Remover ambiente virtual: `conda remove --name py307 --all`


### Configurando Ambiente Conda:
```
conda create -n py310 python=3.10.14

conda create -n py307 python=3.7.11 openssl certifi requests -y
conda activate py307

conda create -n py308 python=3.8.16 openssl -y
conda activate py308

``` 

### Configurando o Ambiente Virtual do Projeto
 
```
cd pasta_do_projeto
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
```

### Para utilizar o Jupyter no VSCode pode ser necessário:
```
pip install ipykernel -U --force-reinstall
```

#### OpenSSL
```conda install openssl```


### LIBS importantes: 
https://python-redmine.com/

https://pypi.org/project/Office365-REST-Python-Client/

https://python-gitlab.readthedocs.io/en/stable/gl_objects/milestones.html


### Pacote Python

meu_pacote/
│
├── meu_pacote/          # Diretório do pacote principal
│   ├── __init__.py      # Arquivo especial que marca o diretório como um pacote Python
│   ├── modulo1.py       # Módulo com funções/classes
│   ├── modulo2.py       # Outro módulo
│   └── subpacote/       # Opcional: Subpacote
│       ├── __init__.py
│       └── modulo3.py
│
├── tests/               # Diretório para testes
│   ├── __init__.py
│   ├── test_modulo1.py
│   └── test_modulo2.py
│
├── setup.py             # Script de configuração para instalação do pacote
├── pyproject.toml       # Arquivo opcional para build system moderno
├── requirements.txt     # Dependências do pacote
├── README.md            # Documentação do pacote
└── LICENSE              # Licença do pacote


{% include rodape.md %}