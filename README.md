# Scrap & Sparks

A story game that teaches n8n from zero. Every mission is a real workflow you build in your own n8n, on your computer, and the game checks it. Chapters 1 to 6 are free.

**Website, install guide and demo:** https://scrap-and-sparks-dnk.pages.dev

## Install

**The easy way: one installer.** It installs Docker if it is missing, then the game, with an icon to start it.

- **Windows:** download **[ScrapAndSparks-Setup.exe](https://github.com/Ouranos88/scrap-and-sparks/releases/latest/download/ScrapAndSparks-Setup.exe)** and open it. It is not signed with a paid certificate, so Windows says *Windows protected your PC*: click **More info**, then **Run anyway**.
- **Mac and Linux:** paste this line into Terminal and press Enter:

  ```sh
  curl -fsSL https://scrap-and-sparks-dnk.pages.dev/install.sh | sh
  ```

**Or step by step:** install Docker (the [install guide](https://scrap-and-sparks-dnk.pages.dev/install/) shows how), download **[scrap-and-sparks.zip](https://github.com/Ouranos88/scrap-and-sparks/releases/latest/download/scrap-and-sparks.zip)**, unzip it, and start it: `start.bat` (Windows), `start.command` (Mac, double-click) or `sh start.sh` (Linux).

The first start downloads n8n and the game (about 4 GB), then the game opens at http://localhost:8765 on Level 0, which guides you from there. Your progress and your n8n stay saved when you stop it.

This repository holds only these starter files (`install.sh` and the Windows installer are in the [releases](https://github.com/Ouranos88/scrap-and-sparks/releases)). The game runs from a prebuilt image, `ghcr.io/ouranos88/scrap-and-sparks-companion`, next to n8n's official images. Everything listens on your own computer only (127.0.0.1).

Feedback: https://scrap-and-sparks-dnk.pages.dev/feedback/

---

## En français

Un jeu à histoire pour apprendre n8n de zéro. Chaque mission est un vrai workflow que tu construis dans ton propre n8n, sur ton ordinateur, et le jeu le vérifie. Les chapitres 1 à 6 sont gratuits.

**Site, guide d'installation et démo :** https://scrap-and-sparks-dnk.pages.dev/fr/

**Le plus simple : un installateur.** Il installe Docker s'il manque, puis le jeu, avec une icône pour le lancer.

- **Windows :** télécharge **[ScrapAndSparks-Setup.exe](https://github.com/Ouranos88/scrap-and-sparks/releases/latest/download/ScrapAndSparks-Setup.exe)** et ouvre-le. Il n'est pas signé avec un certificat payant, donc Windows affiche *Windows a protégé votre ordinateur* : clique sur **Informations complémentaires**, puis sur **Exécuter quand même**.
- **Mac et Linux :** colle cette ligne dans le Terminal et appuie sur Entrée :

  ```sh
  curl -fsSL https://scrap-and-sparks-dnk.pages.dev/install.sh | sh
  ```

**Ou étape par étape :** installe Docker (le [guide d'installation](https://scrap-and-sparks-dnk.pages.dev/fr/install/) montre comment), télécharge **[scrap-and-sparks.zip](https://github.com/Ouranos88/scrap-and-sparks/releases/latest/download/scrap-and-sparks.zip)**, décompresse-le et démarre-le : `start.bat` (Windows), `start.command` (Mac, double-clic) ou `sh start.sh` (Linux).

Le premier démarrage télécharge n8n et le jeu (environ 4 Go), puis le jeu s'ouvre à l'adresse http://localhost:8765 sur le niveau 0, qui te guide à partir de là.

---

Scrap & Sparks is an unofficial game. It is not affiliated with or endorsed by n8n. · Scrap & Sparks est un jeu non officiel, sans lien avec n8n.
