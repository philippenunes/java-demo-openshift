# 🔐 SCRIPT PARA APLICAR SECRETS DO ARGOCD IMAGE UPDATER
# Uso: .\scripts\apply-secrets.ps1

param(
    [string]$EnvFile = ".env"
)

Write-Host "🔐 Aplicando secrets do ArgoCD Image Updater..." -ForegroundColor Green

# Verificar se arquivo .env existe
if (-not (Test-Path $EnvFile)) {
    Write-Host "❌ Arquivo $EnvFile não encontrado!" -ForegroundColor Red
    Write-Host "💡 Copie .env.example para .env e configure seus tokens" -ForegroundColor Yellow
    exit 1
}

# Carregar variáveis do .env
Write-Host "📖 Carregando variáveis de $EnvFile..." -ForegroundColor Blue
Get-Content $EnvFile | ForEach-Object {
    if ($_ -match '^([^#].+?)=(.+)$') {
        $name = $matches[1].Trim()
        $value = $matches[2].Trim()
        Set-Variable -Name $name -Value $value -Scope Script
        Write-Host "   ✅ $name" -ForegroundColor Green
    }
}

# Verificar se token foi configurado
if (-not $GITHUB_TOKEN -or $GITHUB_TOKEN -eq "ghp_YOUR_GITHUB_TOKEN_HERE") {
    Write-Host "❌ GITHUB_TOKEN não configurado em $EnvFile" -ForegroundColor Red
    exit 1
}

# Aplicar o secret
Write-Host "🔧 Criando secret do GitHub..." -ForegroundColor Blue
oc delete secret argocd-image-updater-secret -n openshift-gitops --ignore-not-found=true
oc create secret generic argocd-image-updater-secret -n openshift-gitops `
    --from-literal="git.github.com=$GITHUB_TOKEN"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Secret criado com sucesso!" -ForegroundColor Green
    Write-Host "🔄 Reiniciando ArgoCD Image Updater..." -ForegroundColor Blue
    oc delete pod -l app.kubernetes.io/name=argocd-image-updater -n openshift-gitops
    Write-Host "🎉 Pronto! GitOps automático configurado." -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao criar secret" -ForegroundColor Red
    exit 1
}