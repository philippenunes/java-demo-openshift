
# My Java App on OpenShift with ArgoCD

Este projeto demonstra uma aplicação Java com pipeline GitOps utilizando OpenShift, ArgoCD e automação de promoção de imagens entre ambientes.

## Visão Geral
- **Framework:** Java (Spring Boot)
- **Orquestração:** OpenShift
- **GitOps:** ArgoCD
- **CI/CD:** GitHub Actions
- **Ambientes:** Desenvolvimento (`philippenunes-dev`) e Produção (`philippenunes-prod`)
- **Automação:** Promoção automática de digest e imagem entre dev e prod

## Estrutura do Projeto
```
k8s/
	base/           # Manifests base (Deployment, Service, Route, etc)
	overlays/
		dev/          # Overlay de desenvolvimento
		prod/         # Overlay de produção
.github/
	workflows/      # Pipelines CI/CD (build, promote-digest)
src/              # Código-fonte Java
```

## Principais Funcionalidades
- Deploy automatizado via ArgoCD com separação de ambientes
- Pipeline CI/CD com build, testes e promoção de imagem
- Kustomize para customização de manifests por ambiente
- Promoção de digest e imagem entre dev e prod sem rebuild
- Controle de acesso e versionamento via Git

## Observações
- O projeto utiliza ImageStreams do OpenShift para versionamento e promoção de imagens.
- O pipeline automatiza a sincronização de digests e a promoção de imagens entre namespaces.
- O ArgoCD gerencia o estado desejado dos recursos Kubernetes declarados no repositório.

