#!/bin/bash
# 🚀 SCRIPT PARA AUTOMATIZAR GITOPS - ATUALIZAR TAG DA IMAGEM

# Parâmetros
BUILD_NUMBER=$1
COMMIT_SHA=$2
NAMESPACE="philippenunes-dev"
APP_NAME="my-java-app"

if [ -z "$BUILD_NUMBER" ] || [ -z "$COMMIT_SHA" ]; then
    echo "❌ Uso: $0 <build-number> <commit-sha>"
    exit 1
fi

echo "🏗️  Atualizando GitOps para build #${BUILD_NUMBER} (${COMMIT_SHA})"

# 1. Buscar a tag mais recente do registry
echo "📋 Obtendo informações da imagem..."
IMAGE_DIGEST=$(oc get istag ${APP_NAME}:dev -n ${NAMESPACE} -o jsonpath='{.image.dockerImageReference}' | cut -d'@' -f2)

if [ -z "$IMAGE_DIGEST" ]; then
    echo "❌ Não foi possível obter o digest da imagem"
    exit 1
fi

echo "✅ Digest da imagem: ${IMAGE_DIGEST:0:12}..."

# 2. Atualizar o kustomization.yaml
KUSTOMIZE_FILE="k8s/overlays/dev/kustomization.yaml"

# Usar o build number como tag
NEW_TAG="build-${BUILD_NUMBER}"

echo "🔄 Atualizando ${KUSTOMIZE_FILE} com tag ${NEW_TAG}..."

# Substituir a linha newTag
sed -i "s/newTag: .*/newTag: ${NEW_TAG}  # Build ${BUILD_NUMBER} - ${COMMIT_SHA:0:7}/" ${KUSTOMIZE_FILE}

# 3. Commit e push
echo "📝 Fazendo commit das mudanças..."
git add ${KUSTOMIZE_FILE}
git commit -m "feat: Deploy build #${BUILD_NUMBER}

🏗️ Build: ${BUILD_NUMBER}
🔗 Commit: ${COMMIT_SHA:0:7}  
📦 Tag: ${NEW_TAG}

Automated GitOps deployment"

echo "🚀 Enviando para repositório..."
git push origin main

echo "✅ GitOps atualizado! ArgoCD aplicará automaticamente."