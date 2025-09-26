# Java Demo OpenShift - GitOps POC

## 🏗️ Arquitetura

- **ArgoCD**: Rodando no KIND (WSL) para gerenciamento GitOps
- **OpenShift**: CRC local como cluster de destino
- **Aplicação**: Spring Boot Java deployada via GitOps

## 📁 Estrutura GitOps

```
k8s/
├── application-build.yml       # ArgoCD App para builds
├── application-dev.yml         # ArgoCD App para deploys  
├── crc-cluster-secret.yml      # Secret para conectar ArgoCD → CRC
├── build/                      # Recursos de build
│   ├── buildconfig-dev.yaml    # BuildConfig OpenShift
│   └── imagestream.yaml        # ImageStream
└── dev/                        # Recursos de deploy
    └── my-java-app-dev.yaml    # Deployment, Service, Route
```

## 🚀 Como usar

### 1. Iniciar ArgoCD (KIND)
```bash
# Criar cluster KIND
wsl -- kind create cluster --name argocd

# Instalar ArgoCD
wsl -- kubectl create namespace argocd
wsl -- kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Port-forward
Start-Job -ScriptBlock { wsl -- kubectl port-forward svc/argocd-server -n argocd 8080:443 }
```

### 2. Configurar conectividade (Windows como admin)
```powershell
# Abrir firewall
netsh advfirewall firewall add rule name="CRC API Server" dir=in action=allow protocol=TCP localport=6443

# Verificar IP Windows
ipconfig | Select-String "IPv4"
```

### 3. Aplicar GitOps
```bash
# Criar namespace no CRC
oc create namespace philippenunes-dev

# Aplicar secrets e applications
wsl -- kubectl apply -f k8s/crc-cluster-secret.yml
wsl -- kubectl apply -f k8s/application-build.yml  
wsl -- kubectl apply -f k8s/application-dev.yml
```

## 🔐 Credenciais

### ArgoCD
- **URL**: http://localhost:8080
- **User**: admin
- **Password**: `wsl -- kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

### CRC
- **Console**: `crc console`
- **Admin**: `crc console --credentials`

## ✅ Status Esperado

```
wsl -- kubectl get applications -n argocd
NAME                SYNC STATUS   HEALTH STATUS
my-java-app-build   Synced        Healthy
my-java-app-dev     Synced        Healthy
```

## 🔄 Fluxo Completo

1. **Commit** → GitHub repository
2. **ArgoCD** detecta mudança → Sync automático
3. **Build** → Cria imagem no registry OpenShift
4. **Deploy** → Atualiza pods com nova imagem
5. **Route** → Aplicação disponível via URL

## 🔐 Segurança

### Arquivos sensíveis (NÃO commitados):
- `k8s/crc-cluster-secret.yml` - Contém bearer token
- Use sempre o template: `k8s/crc-cluster-secret.template.yml`

### Para renovar token:
```bash
# Obter novo token CRC
oc whoami -t

# Atualizar secret no ArgoCD
wsl -- kubectl delete secret crc-cluster-secret -n argocd
wsl -- kubectl apply -f k8s/crc-cluster-secret.yml
```