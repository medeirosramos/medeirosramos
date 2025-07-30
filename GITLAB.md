### Indice

[Boas práticas para o controle das atividades de desenvolvimento](#boas-praticas-para-o-controle-das-atividades-de-desenvolvimento)  
[Branches Principais](#branches-principais)  
[Renomear Repositorio Git](#renomear-repositorio-git)  
[Comandos git](#comandos-git)  


#### Boas práticas para o controle das atividades de desenvolvimento:
Assuma a responsabilidade (Assignee) de uma atividade antes de iniciar seu desenvolvimento.  
Ao sincronizar código-fonte de atividade não concluída, utilize o padrão related medeirosramos/projeto#numero_atividade, exemplo:  
- `related medeirosramos/projeto#4 - informações do commit`  

Ao sincronizar código-fonte relacionado a correção de bug no sistema, problema de desempenho, erros e/ou inconsistencias, utilize o padrão fixed ia/projeto#numero_atividade, exemplo:  
- `fixed medeirosramos/projeto#4 - informações do commit`  

Ao sincronizar código-fonte relacionado a novas rotinas, implementações e melhorias, utilize o padrão resolved ia/projeto#numero_atividade, exemplo:  
- `resolved medeirosramos/projeto#4 - informações do commit`  

Ao sincronizar código-fonte de atividade parcialmente atendida ou que não será mais implementada, utilize o padrão closed ia/projeto#numero_atividade, exemplo:  
- `closed medeirosramos/projeto#4 - informações do commit`  

#### Branches Principais

- Branches semânticas - São branches no qual são desenvolvidos recursos novos para o projeto em questão. Essas branches tem por convenção nome começando com feat/ (exemplo: feat/extrair-dados-bnmp) e são criadas a partir da branch homolog (pois um recurso pode depender diretamente de outro recurso em algumas situações), e, ao final, são juntadas com a branch homolog;  
    - Build - alterações que afetam o sistema de build ou dependências externas  
    - Ci - alterações nos arquivos de configuração ou script do CI
    - Feat - adiciona uma nova funcionalidade
    - Fix - correção de bug
    - Perf - alteração que melhora o desempenho ou performace
    - Refact - alteração que não corrige um bug e não adicona uma funcionalidade
    - Style - alteração que não afeta o significado do código
    - Test - adição de testes ou correção de testes

- Branches homolog - É a branch que contém código em nível preparatório para o próximo deploy. Ou seja, quando branches semânticas são terminadas, elas são juntadas com a branch homolog, testadas (em conjunto, no caso de mais de uma feature), e somente depois as atualizações da branch homolog passam por mais um processo para então ser juntadas com a branch dev;

- Branch dev - São branches com um nível de confiança maior do que a branch homolog, e que se encontram em nível de preparação para ser juntada com a branch main/master e com a branch homolog (para caso tenha ocorrido alguma correção de bug). Note que, nessas branches, bugs encontrados durante os testes das features que vão para produção podem ser corrigidos mais tranquilamente, antes de irem efetivamente para produção;   

- Branch main/master - É a branch que contém código em nível de produção, ou seja, o código mais maduro existente na sua aplicação. Todo o código novo produzido eventualmente é juntado com a branch main/master, em algum momento do desenvolvimento.  


#### Testar o gitlab-ci.yaml localmente:

```
docker run -d --name gitlab-runner --restart always -v "${PWD}:/opt/presos-api-bnmp" -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest

# ultima versao com erro, problema conhecido:

# https://gitlab.com/gitlab-org/gitlab-runner/-/issues/2797
docker run -d --name gitlab-runner --restart always -v "${PWD}:/opt/presos-api-bnmp" -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:v16.9.0

```
Conectando no conteiner e executando gitrunner
```
docker ps
docker exec -it 8786 /bin/bash
cd /opt/presos-api-bnmp/
gitlab-runner exec shell build-job
# ou
docker exec -it 8786 "gitlab-runner exec shell build-job /opt/presos-api-bnmp/"
```

```
https://docs.gitlab.com/runner/install/windows.html
https://archives.docs.gitlab.com/16.11/runner/install/windows.html
https://gitlab.com/gitlab-org/gitlab-runner/-/releases/v16.5.0

set-alias gitlab-runner "C:\Program Files\Git\gitlab-runner\gitlab-runner-windows-amd64.exe"
gitlab-runner exec shell build-job

#gitlab-runner exec docker build-job

```

#### Renomear Repositorio Git:  
Renomear o projeto: Settings > General > Advanced -> Rename Repository Project
(por exemplo: https://gitlab.com/seu-usuario/novo-nome.git).

Atualizar o repositório local (VSCode / Git)
No terminal do VSCode ou da sua máquina, atualize a URL remota do Git:

```bash

git remote set-url origin https://gitlab.com/seu-usuario/novo-nome.git
git remote -v

```

(Opcional) Renomear a pasta local do projeto
Se quiser que a pasta do projeto no seu computador também tenha o novo nome:
```
bash
cd ..
mv nome-antigo novo-nome
cd novo-nome
code .
```

4. Confirmar que está funcionando:
```
bash
git fetch
git push
```

#### Comandos git:

Listar: `git branch`  
Listar Remotas: `git branch -a`  

Adicionar: `git checkout -b Feat/extrair-api-bnmp`  
Alterar: `git checkout minha-branch`  

Excluindo: `git branch -d Feat/extrair-api-bnmp`  

Renomeando: `git branch -m Feat/extrair-dados-bnmp`  
Renomeando: `git branch -m Feat/extrair-api-bnmp Feat/extrair-dados-bnmp`  
  
  
Exemplos de comandos de configuração:  
[gerando chave SSH](https://docs.gitlab.com/ee/user/ssh.html) atraves do ssh-keygen:  
`ssh-keygen -t rsa -b 4096`  

definindo usuário e e-mail:  
`git config --global user.name "Nome Sobrenome"`  
`git config --global user.email "nomesobrenome@email"`  

salvar senha:  
`git config --global credential.helper store`

clonando projetos:  
`git clone https://gitlab.tjrn.jus.br/ia/presos-api-bnmp.git`  

verificando clonagem do repositório:  
`git status`  
`git log -5`  
`git status`  




{% include rodape.md %}