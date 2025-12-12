# SnowCrash - level00 writeup

## Objectif

Trouver le mot de passe du compte flag00, se connecter, puis exécuter getflag pour obtenir le token.

## Recon

### Recherche du fichier appartenant à flag00

```
ls -Rl / 2>/dev/null | grep flag00
----r--r-- 1 flag00 flag00 15 Mar 5 2016 john
----r--r-- 1 flag00 flag00 15 Mar 5 2016 john
```

### Localisation de john

```
find / -name john 2>/dev/null
/usr/sbin/john
/rofs/usr/sbin/john
```

## Analyse

En lisant le fichier, on récupère une chaîne :

```
cat /usr/sbin/john
cdiiddwpgswtgt
```

Cette chaîne est un chiffrement de César.
Décodage -15 (ou équivalent “+15” selon la convention) :

```
cdiiddwpgswtgt -> nottoohardhere
```

## Exploitation

Connexion au compte flag00 avec le mot de passe décodé :

```
su flag00
Password: nottoohardhere
```

Récupération du token du niveau suivant :

```
getflag
Check flag.Here is your token : x24ti5gi3x0ol2eh4esiuxias
```

## Résultat

- Password flag00 - > nottoohardhere
- Token getflag - > x24ti5gi3x0ol2eh4esiuxias

## Notes

- Technique : chiffrement César (rotation 15)
- Preuves : commandes + sortie getflag incluses ci-dessus
