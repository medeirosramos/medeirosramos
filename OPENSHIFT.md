##### Adicionado deploy no OpenShift, passo a passo exemplo:
```
Selecione Developer
Na aba +Add, selecione Git Repository (Import From GIT)  
Git Repo URL: https://xxxxxxxxx
Git type: GitLab
Git reference: dev | homolog | branch-especifica
Source Secret: gitlab-ca
Import Strategy: Dockerfile  
Dockerfile path: Dockerfile  
Application: Create application  
Application Name: nome_do_grupo_de_aplicacoes 
Name: nome-App
Resource type: Deployment
```

###### Deixando o Deploy Automático:  
Acessar OpenShift -> Administrator -> Builds -> BuildsConfigs -> selecione o App  
Copiar a URL do WebHook em -> Details -> Webhooks -> copiar Generic ou GitLab  
Colar URL WebHooks no GitLab -> Projeto -> Settings -> WebHooks :  
```
Push Events
Wildcard pattern: dev | homolog | main
Disable SSL verification
```
O mantenedor do OpenShift deve liberar a utilização do WebHook.