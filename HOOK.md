## Automação de Verificação de Padrão de Mensagem de Commit com Git Hook

Este tutorial ensina a configurar uma verificação automática de mensagens de commit para garantir que sigam os padrões definidos no tutorial [boas práticas de como utilizar o GitLab.](./START.md)

### Passo 1: Criar o Hook de Mensagem de Commit 

Primeiro, certifique-se de que está no diretório do seu repositório Git local. Se não estiver, entre no diretório com o comando:
```
cd <caminho pro repositório>
```


Agora, crie o arquivo `commit-msg` no diretório de hooks do Git::
```
touch .git/hooks/commit-msg
```

Abra o arquivo `commit-msg` para edição e cole o código abaixo:
```
#!/bin/sh

# Obtém o nome do projeto a partir da URL do repositório em .git/config
project_name=$(basename -s .git "$(git config --get remote.origin.url)")

# Obtém o nome da branch atual
branch_name=$(git symbolic-ref --short HEAD)

# Extrai o número da atividade do nome da branch (assumindo formato como "feature/#4-some-feature")
activity_number=$(echo "$branch_name" | grep -oE '#[0-9]+')

# Lê a mensagem de commit
commit_message=$(cat "$1")

# Define regex para formatos completo e simplificado
full_format_regex='^(related|fixed|resolved|closed) ia/[a-zA-Z0-9_-]+#[0-9]+ .+'
simplified_format_regex='^(related|fixed|resolved|closed) .+'

# Verifica se a mensagem já está no formato completo
if echo "$commit_message" | grep -Eq "$full_format_regex"; then
    # Formato completo: sai sem alterações
    exit 0
elif echo "$commit_message" | grep -Eq "$simplified_format_regex"; then
    # Formato simplificado: separa tipo e informações
    commit_type=$(echo "$commit_message" | awk '{print $1}')
    commit_info=$(echo "$commit_message" | sed 's/^[^ ]* //')
else
    # Mensagem inválida
    echo "Erro: A mensagem de commit deve seguir um destes formatos:"    
	echo "related|fixed|resolved|closed ia/$project_name#0 - informações do commit"
    exit 1
fi

# Valida o tipo de commit
valid_types="related fixed resolved closed"
if ! echo "$valid_types" | grep -qw "$commit_type"; then
    echo "Erro: Tipo de commit inválido. Use algum destes: $valid_types."
    exit 1
fi

# Verifica se o nome do projeto ou o número da atividade foram extraídos corretamente
if [ -z "$project_name" ] || [ -z "$activity_number" ]; then
    echo "Erro: Não foi possível determinar o nome do projeto ou o número da atividade."
    echo "Certifique-se de que o nome da branch contenha o número da atividade (Exemplo: 'feat/#4-alguma-feature')."
    exit 1
fi

# Formata a mensagem completa
full_commit_message="$commit_type ia/$project_name$activity_number - $commit_info"

# Escreve a mensagem formatada no arquivo de commit
echo "$full_commit_message" > "$1"
```

### Passo 2: Habilitar o Hook

Para ativar o hook, torne-o executável com o comando:
```
chmod +x .git/hooks/commit-msg
```

### Passo 3: Teste o Hook

Agora o hook está configurado. Sempre que você tentar fazer um commit, o Git verificará automaticamente se a mensagem segue o padrão definido em [START.md](./START.md). Se a mensagem não estiver correta, o commit será interrompido, e uma mensagem de erro será exibida.

**Nota:** É necessário que o nome da branch contenha um número de atividade prefixado por `#` para o script funcionar (por exemplo: `feature/#4-nova-funcionalidade`).




Markdown:
[📡Documentação](https://gitlab.tjrn.jus.br/ia/gitlab-profile/-/blob/main/README.md)
[📔Guia Rápido](https://ajuda.gitlab.io/guia-rapido/markdown/markdown/) 
[📚Implementação GitLab](https://docs.gitlab.com/ee/user/markdown.html)
