# 🔐 CONFIGURAÇÃO DE SECRETS NO GITHUB

Para o GitHub Actions funcionar, você precisa configurar estes secrets no repositório:

## 📋 Como configurar:
1. Vá para: https://github.com/philippenunes/java-demo-openshift/settings/secrets/actions
2. Clique em "New repository secret"
3. Adicione cada secret abaixo:

## 🔑 Secrets necessários:

### OPENSHIFT_SERVER
```
https://api.crc.testing:6443
```

### OPENSHIFT_TOKEN
```
sha256~L9X6Hf88uiuSm5a5WNe39eF8XjZ2WOEAL2LKC_YAa24
```

## ⚠️ IMPORTANTE:
- Use exatamente esses nomes (case-sensitive)
- O token atual expira, você pode gerar um novo com: `oc whoami --show-token`
- Para produção, crie um service account dedicado ao CI/CD

## 🎯 Após configurar:
1. Faça um push no código
2. O workflow executará automaticamente
3. Build será disparado no OpenShift
4. ArgoCD Image Updater detectará e fará deploy automático

## 🔄 Fluxo completo:
GitHub Push → Tests → OpenShift Build → Image Updater → Git Commit → ArgoCD Deploy