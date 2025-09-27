# 🚀 GitOps Profissional: Kustomize + ArgoCD Image Updater

## 📁 Estrutura do Projeto

```
k8s/
├── base/                           # 🏗️ Configurações base (genéricas)
│   ├── deployment.yaml            # Deployment sem customizações
│   ├── service.yaml               # Service genérico
│   ├── route.yaml                 # Route genérica  
│   └── kustomization.yaml         # Base kustomization
│
├── overlays/                      # 🎨 Customizações por ambiente
│   └── dev/                       # Ambiente de desenvolvimento
│       └── kustomization.yaml     # Overlay para dev
│
├── application-dev.yml            # ArgoCD Application (com Image Updater)
└── application-build.yml          # ArgoCD Build Application
```

## 🔄 Fluxo GitOps Automatizado

### 1. **Desenvolvedor faz push** 
```bash
git add .
git commit -m "nova funcionalidade"
git push origin main
```

### 2. **OpenShift BuildConfig** (automático)
- Detecta mudança no Git via webhook
- Executa build S2I automaticamente
- Gera nova imagem com tag única

### 3. **ArgoCD Image Updater** (automático)
- Monitora registry do OpenShift
- Detecta nova imagem disponível
- Atualiza `newTag` no `k8s/overlays/dev/kustomization.yaml`
- Commita mudança de volta ao Git

### 4. **ArgoCD Sync** (automático)
- Detecta mudança no kustomization.yaml
- Executa `kubectl apply -k k8s/overlays/dev`
- Deploy da nova versão

## 🎯 Vantagens desta Arquitetura

### ✅ **100% GitOps**
- Tudo declarativo via Git
- Princípio pull-based respeitado
- Rollback via Git (git revert)

### ✅ **Profissional**
- Padrão usado por Netflix, Spotify, Intuit
- Separação clara: base → overlays
- Escalável para múltiplos ambientes

### ✅ **Automação Completa**
- Zero intervenção manual
- Build → Registry → Git → Deploy
- Auditoria completa via Git history

## 🔧 Comandos Úteis

### Testar Kustomize localmente:
```bash
kubectl kustomize k8s/overlays/dev
```

### Ver diferenças:
```bash
kubectl diff -k k8s/overlays/dev
```

### Aplicar manualmente (se necessário):
```bash
kubectl apply -k k8s/overlays/dev
```

## 📊 Próximos Passos

1. ✅ **DEV configurado** - Estrutura base + overlay dev
2. 🔄 **Instalar ArgoCD Image Updater**
3. 🎯 **Configurar PROD** - Criar overlay para produção
4. 🔐 **Secrets management** - Integrar com Sealed Secrets
5. 🚀 **Multi-cluster** - Expandir para outros clusters

## 🏆 Status da POC

- **Fase atual**: ✅ Estrutura Kustomize profissional criada
- **Próximo**: 🔄 Instalar e configurar ArgoCD Image Updater
- **Meta**: 🎯 Automação 100% funcional