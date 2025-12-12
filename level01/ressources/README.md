# SnowCrash - level01

## Objectif

Trouver le mot de passe du compte flag01, se connecter, puis exécuter getflag.

## Recon

### Recherche de références à flag01 dans /etc

```
grep -rni flag01 /etc/ 2>/dev/null
/etc/passwd:41:flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash
```

## Analyse

Le fichier /etc/passwd contient un champ correspondant normalement au hash du mot de passe.

Chaîne récupérée :

```
42hDRfypTqqnw
```

Cette chaîne est reconnue par john the ripper comme correspondant au mot de passe suivant :

```
42hDRfypTqqnw -> abcdefg
```

## Exploitation

Connexion au compte flag01 avec le mot de passe trouvé :

```
su flag01
Password: abcdefg
```

Exécution de la commande getflag :

```
flag01@SnowCrash:~$ getflag
```

## Résultat

- Password flag01 - > abcdefg
- Accès au compte flag01 validé
- Commande getflag exécutée avec succès

## Notes

- Vulnérabilité : mot de passe stocké dans /etc/passwd
- Technique : cracking avec john
- Mauvaise pratique : stockage non chiffré des mots de passe système
