# Container/Contêiner
Docker and Kubernetes


### Dockerfile

```
FROM ubuntu
RUN echo "hello there"
```
Removendo todas as imagens Docker do cache:
`docker image prune --all`

Remoção de todas as imagens, incluindo as em uso (drástico):
`docker rmi $(docker images -q)`

Para criar imagem do Dockerfile:
`docker build --tag 'image-name' .`

Para executar imagem criada com --attach (STDIN | STDOUT | STDERR), permitindo anexar o terminal à saída do container em tempo real:  
`docker run --attach (or -a) stdout --name 'container-name' 'image-name'`  
`docker run -a stdout --name 'container-name' 'image-name'`

Para executar imagem criada com --detach, permitindo a execução do container em segundo plano:  
`docker run --detach (or -d) --name 'container-name' 'image-name'`

Para executar imagem criada com --interactive e --tty, mantendo a entrada do terminal aberta durante a execução do contêiner:  
`docker run --interactive (or -i) --tty (or -t) --name 'container-name' 'image-name'`  
`docker run -it 'image-name' /bin/bash`  
`docker run -it 'image-name' /bin/bash -c "echo 'Hello, Docker!'"`  
`docker run -id 'image-name'`  

## estudar gitlab-ci

# https://rocker-project.org/images/
# image: rocker/rstudio:4.2.3
# https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
# https://heds.nz/posts/gitlab-cicd-pipeline-r-package/
# # https://www.youtube.com/watch?v=7I6tHw68DMQ    
# https://docs.gitlab.com/ee/ci/variables/
# https://stackoverflow.com/questions/78893751/setting-up-gitlab-ci-cd-for-r-packages
# https://persado.github.io/2019/10/23/R-gitlab-pipelines.html

{% include rodape.md %}