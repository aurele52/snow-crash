# SnowCrash - level14 writeup

## Objectif

Exécuter getflag en contournant ses protections anti-debug (ptrace) et en forçant l’UID ciblé (3014 pour flag14) afin d’obtenir le token.

## Recon

L’utilisateur flag14 a l’UID 3014 :

```
flag14:x:3014:3014::/home/flag/flag14:/bin/bash
```

getflag utilise des vérifications anti-debug et récupère l’UID courant pour choisir quel token afficher.

## Analyse

Deux obstacles typiques :

- ptrace() - empêche l’exécution sous gdb
- getuid() - détermine quel flag/token est renvoyé

Sur i386, les retours de fonction passent par EAX.
On peut donc :

- forcer le retour de ptrace() à 0 (succès)
- forcer le retour de getuid() à 3014 (UID de flag14)

## Exploitation

Démarrage de getflag sous gdb :

```
gdb getflag
```

Bypass anti-debug :

```
b ptrace
run
finish
set $eax=0
```

Forcer l’UID :

```
b getuid
n
finish
set $eax=3014
```

Continuer l’exécution pour afficher le token :

```
continue
```

## Résultat

- Technique - > Bypass ptrace + spoof getuid via patch registre EAX
- UID forcé - > 3014 (flag14)
- Token getflag - > (à remplir avec la sortie exacte)

## Notes

- finish retourne au caller et laisse la valeur de retour dans EAX
- set $eax=... permet de “mentir” sur le résultat des fonctions de contrôle
- Alternative : patcher le binaire (NOPS / jump conditionnel), mais gdb est suffisant ici
