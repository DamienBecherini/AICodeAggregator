<#
.SYNOPSIS
    Concatène les fichiers d'un projet en un seul fichier de sortie,
    en excluant les éléments spécifiés dans concat-config.yaml.

.DESCRIPTION
    Ce script est compatible avec Windows PowerShell 5.1 et versions ultérieures.
    Il nécessite le module 'powershell-yaml' et proposera de l'installer si besoin.

.PARAMETER ProjectPath
    Le chemin vers le répertoire racine du projet à concaténer. La valeur par défaut est le répertoire courant.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Chemin vers la racine du projet.")]
    [string]$ProjectPath = "."
)

# Assurer un affichage correct des accents dans la console
$OutputEncoding = [System.Text.Encoding]::UTF8

# --- VÉRIFICATION ET INSTALLATION DE LA DÉPENDANCE YAML ---
$yamlModuleName = "powershell-yaml"
if (-not (Get-Module -ListAvailable -Name $yamlModuleName)) {
    Write-Host "Le module '$yamlModuleName' est requis pour lire le fichier de configuration YAML." -ForegroundColor Yellow
    $choice = Read-Host "Voulez-vous l'installer depuis la PowerShell Gallery maintenant ? (o/n)"
    if ($choice -eq 'o') {
        try {
            Write-Host "Installation de '$yamlModuleName'... Cela peut prendre un moment."
            Install-Module -Name $yamlModuleName -Scope CurrentUser -Repository PSGallery -Force -AllowClobber
            Write-Host "Module installé avec succès." -ForegroundColor Green
        } catch {
            Write-Error "L'installation a échoué. Veuillez essayer d'exécuter 'Install-Module -Name $yamlModuleName -Scope CurrentUser' dans un terminal PowerShell avec des droits d'administrateur si nécessaire."
            return
        }
    } else {
        Write-Error "Installation annulée. Le script ne peut pas continuer sans le module '$yamlModuleName'."
        return
    }
}
Import-Module $yamlModuleName

# --- VALIDATION INITIALE ---
$ResolvedProjectPath = Resolve-Path -Path $ProjectPath
if (-not (Test-Path -Path $ResolvedProjectPath -PathType Container)) {
    Write-Error "Le chemin spécifié '$ResolvedProjectPath' n'existe pas ou n'est pas un répertoire."
    return
}

$ConfigPath = Join-Path -Path $ResolvedProjectPath -ChildPath "concat-config.yaml"
if (-not (Test-Path -Path $ConfigPath)) {
    Write-Error "Le fichier de configuration 'concat-config.yaml' est introuvable à la racine du projet : $ResolvedProjectPath"
    return
}

# --- INITIALISATION ET CONFIGURATION ---
Write-Host "Lancement de la concaténation du projet : $ResolvedProjectPath" -ForegroundColor Cyan
$config = Get-Content -Path $ConfigPath -Raw | ConvertFrom-Yaml
$ProjectName = (Get-Item -Path $ResolvedProjectPath).Name
$BuildDir = Join-Path -Path $ResolvedProjectPath -ChildPath "build"
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$OutputFileName = "${ProjectName}_concat_${Timestamp}.txt"
$OutputFilePath = Join-Path -Path $BuildDir -ChildPath $OutputFileName

if (-not (Test-Path $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}

# --- GÉNÉRATION DE L'EN-TÊTE DU FICHIER DE SORTIE ---
$Header = @"
================================================================================
Projet              : $ProjectName
Date de génération  : 30 août 2025
Généré par          : Script PowerShell (concatenate-project.ps1)
================================================================================

Ce fichier est une concaténation de plusieurs fichiers sources du projet.
Chaque fichier est précédé d'un en-tête indiquant son chemin d'origine.

"@

# MODIFICATION n°1: Utiliser Out-File pour créer le fichier avec un encodage UTF-8 avec BOM
Out-File -FilePath $OutputFilePath -InputObject $Header -Encoding utf8

# --- TRAITEMENT DES FICHIERS ---
Write-Host "Recherche et filtrage des fichiers..."
$excludeDirsRegex = ($config.exclude_dirs | ForEach-Object { [regex]::Escape($_) }) -join '|'
$filesToProcess = Get-ChildItem -Path $ResolvedProjectPath -Recurse -File | Where-Object {
    $file = $_
    $isDirExcluded = $file.FullName -match "\\($excludeDirsRegex)\\"
    $isExtExcluded = $config.exclude_extensions -contains $file.Extension
    $isFileExcluded = $config.exclude_files -contains $file.Name
    -not ($isDirExcluded -or $isExtExcluded -or $isFileExcluded)
}

Write-Host "Concaténation de $($filesToProcess.Count) fichiers..."

foreach ($file in $filesToProcess) {
    # Compatibilité PowerShell 5.1 pour le chemin relatif
    $relativePath = $file.FullName.Replace($ResolvedProjectPath, '').TrimStart('\').TrimStart('/')
    
    $fileHeader = @"

--------------------------------------------------------------------------------
-- Fichier : $($file.Name)
-- Chemin  : $relativePath
--------------------------------------------------------------------------------

"@
    
    # MODIFICATION n°2: Utiliser Out-File avec -Append pour ajouter du contenu
    Out-File -FilePath $OutputFilePath -InputObject $fileHeader -Encoding utf8 -Append
    
    # MODIFICATION n°3: Lire le fichier source en spécifiant l'encodage UTF-8
    $fileContent = Get-Content -Path $file.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    Out-File -FilePath $OutputFilePath -InputObject $fileContent -Encoding utf8 -Append
}

# --- RÉCAPITULATIF FINAL ---
Write-Host "Opération terminée avec succès !" -ForegroundColor Green
$outputContent = Get-Content -Path $OutputFilePath -Raw -Encoding UTF8
$charCount = $outputContent.Length
$tokenCount = [Math]::Ceiling($charCount / 4)

Write-Host "------------------- RÉCAPITULATIF -------------------"
Write-Host "Fichier de sortie créé : " -NoNewline; Write-Host $OutputFilePath -ForegroundColor Yellow
Write-Host "Nombre de fichiers traités : " -NoNewline; Write-Host $($filesToProcess.Count) -ForegroundColor Yellow
Write-Host "Nombre total de caractères : " -NoNewline; Write-Host $charCount.ToString("N0") -ForegroundColor Yellow
Write-Host "Estimation du nombre de tokens (IA) : " -NoNewline; Write-Host "~$($tokenCount.ToString("N0")) tokens" -ForegroundColor Yellow
Write-Host "-----------------------------------------------------"