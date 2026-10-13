# AICodeAggregator

Un script PowerShell simple et puissant pour fusionner tous les fichiers texte d'un projet en un seul fichier de sortie. Idéal pour créer un contexte complet à fournir à une Intelligence Artificielle, pour archiver un projet, ou pour effectuer des recherches globales.

## Fonctionnalités

- 🚀 **Concaténation Intelligente** : Parcourt récursivement le projet et assemble les fichiers.
- 📄 **En-têtes Clairs** : Ajoute un séparateur avant chaque fichier, indiquant son nom, son chemin relatif, ainsi qu'un en-tête général avec un timestamp.
- ⚙️ **Configuration Facile** : Utilise un fichier `concat-config.yaml` pour gérer les exclusions (répertoires, extensions, fichiers).
- 📊 **Résumé Complet** : Affiche dans la console le nombre de fichiers traités, le nombre total de caractères et une estimation du nombre de tokens pour l'IA.
- 📦 **Gestion des Dépendances** : Détecte et propose d'installer automatiquement le module `powershell-yaml` si nécessaire.
- ✅ **Haute Compatibilité** : Conçu pour fonctionner sur Windows 10 et 11 avec la version par défaut de PowerShell (5.1) et les versions ultérieures.

## Installation et Configuration

1.  **Copiez les fichiers** : Placez `AICodeAggregator.ps1` et `concat-config.yaml` à la racine de votre projet cible.

2.  **Personnalisez les exclusions** : Ouvrez `concat-config.yaml` et modifiez les listes pour ignorer les éléments non désirés.

3.  **Encodage du Script** :
    > ⚠️ **Important : Encodage du Fichier Script**
    > Pour que les accents s'affichent correctement, le script `AICodeAggregator.ps1` doit être enregistré avec l'encodage **UTF-8 with BOM**.
    >
    > - **Avec VS Code** : Cliquez sur `UTF-8` en bas à droite > "Enregistrer avec encodage" > "UTF-8 with BOM".
    > - **Avec le Bloc-notes** : `Fichier > Enregistrer sous...` > Changez "Encodage" en "UTF-8 avec BOM".

## Utilisation

### Méthode 1 : Script Local (Recommandé)

1.  Ouvrez un terminal dans le dossier racine de votre projet.
2.  Autorisez l'exécution (une seule fois par session) :
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    ```
3.  Lancez le script :
    ```powershell
    .\AICodeAggregator.ps1 .
    ```

### Méthode 2 : Script Centralisé (Avancé)

1.  Placez `AICodeAggregator.ps1` dans un dossier d'outils (ex: `C:\MesOutils\`).
2.  Copiez `concat-config.yaml` à la racine du projet cible.
3.  Ouvrez un terminal dans le projet cible.
4.  Autorisez l'exécution (si nécessaire).
5.  Lancez le script via son chemin complet :
    ```powershell
    # Adaptez le chemin
    C:\MesOutils\AICodeAggregator.ps1 .
    ```

## Licence

Ce projet est publié sous [licence MIT](LICENSE).

## Mots-clés / Tags

powershell, script, code-aggregation, ai-context, developer-tools, windows, text-processing, file-management, code-concatenation, project-archiving
