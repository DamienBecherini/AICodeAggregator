# Concaténateur de Projet pour Windows (PowerShell)

Un script PowerShell pour fusionner tous les fichiers texte d'un projet en un seul fichier de sortie. Idéal pour créer un contexte complet à fournir à une Intelligence Artificielle, pour archiver un projet, ou pour effectuer des recherches globales.

## Fonctionnalités

- 🚀 **Concaténation Intelligente** : Parcourt récursivement le projet et assemble les fichiers.
- 📄 **En-têtes Clairs** : Ajoute un séparateur avant chaque fichier, indiquant son nom et son chemin relatif.
- ⚙️ **Configuration Facile** : Utilise un fichier `concat-config.yaml` pour gérer les exclusions (répertoires, extensions, fichiers).
- 📊 **Résumé Complet** : Affiche dans la console le nombre de fichiers traités, le nombre total de caractères et une estimation du nombre de tokens pour l'IA.
- 📦 **Gestion des Dépendances** : Détecte et propose d'installer automatiquement le module `powershell-yaml` si nécessaire.
- ✅ **Haute Compatibilité** : Conçu pour fonctionner sur Windows 10 et 11 avec la version par défaut de PowerShell (5.1) et les versions ultérieures.

## Structure des Fichiers

Pour fonctionner, le script et sa configuration doivent être placés à la racine du projet que vous souhaitez analyser.

```
/mon-projet
|-- 📄 concatenate-project.ps1  <-- Le script principal
|-- 📄 concat-config.yaml      <-- Le fichier de configuration
|-- 📂 src/
|   |-- ... (vos fichiers de projet)
|-- ... (autres fichiers et dossiers)
```

## Prérequis

- Windows 10 ou 11.
- PowerShell 5.1 (installé par défaut) ou une version plus récente.

## Installation et Configuration

1.  **Copier les fichiers** : Placez `concatenate-project.ps1` et `concat-config.yaml` à la racine de votre projet.

2.  **Personnaliser les exclusions** : Ouvrez `concat-config.yaml` avec n'importe quel éditeur de texte et modifiez les listes pour ignorer les dossiers, extensions ou fichiers que vous ne souhaitez pas inclure.

3.  **Vérifier l'encodage du script** :
    > ⚠️ **Important : Encodage du Fichier Script**
    > Pour que les accents s'affichent correctement dans le fichier de sortie, le script `concatenate-project.ps1` lui-même doit être enregistré avec l'encodage **UTF-8 with BOM**.
    >
    > - **Avec VS Code** : En bas à droite, cliquez sur `UTF-8`. Choisissez "Enregistrer avec encodage" puis "UTF-8 with BOM".
    > - **Avec le Bloc-notes** : Allez dans `Fichier > Enregistrer sous...`. En bas, changez le menu déroulant "Encodage" pour "UTF-8 avec BOM" et enregistrez.

## Utilisation

1.  **Ouvrir un terminal** : Faites un clic droit dans le dossier de votre projet et sélectionnez "Ouvrir dans le Terminal" ou "Ouvrir la fenêtre PowerShell ici".

2.  **Autoriser l'exécution** (si c'est la première fois dans ce terminal) : Pour des raisons de sécurité, PowerShell bloque les scripts par défaut. Exécutez la commande suivante pour l'autoriser uniquement pour cette session :

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    ```

3.  **Lancer la concaténation** : Exécutez le script en lui passant `.` comme argument pour désigner le dossier actuel.
    ```powershell
    .\concatenate-project.ps1 .
    ```

Le script va s'exécuter, créer un dossier `build/` et y placer le fichier texte final. Un résumé s'affichera dans la console.

## Licence

Ce projet est dédié au domaine public. Voir le fichier `LICENSE` pour plus de détails.
