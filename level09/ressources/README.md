# SnowCrash - level09 writeup

## Objectif

Comprendre la transformation appliquée par le binaire level09, reconstituer le mot de passe à partir du fichier token, puis récupérer le flag.

## Recon

Exécution sans argument :

```
./level09
You need to provied only one arg.
```

Test avec le fichier token :

```
./level09 token
tpmhr
```

Traçage avec ltrace :

```
ltrace ./level09
```

Le binaire empêche le débogage via ptrace, mais applique une transformation simple sur l’argument fourni.

## Analyse

Tests progressifs pour identifier le comportement :

```
./level09 a -> a
./level09 ab -> ac
./level09 abc -> ace
./level09 abcd -> aceg
./level09 abbbbbbbb -> acdefghij
```

Observation :
Chaque caractère de sortie correspond à :

- caractère d’entrée
- - son index dans la chaîne

Formule :

```
output[i] = input[i] + i
```

Le binaire chiffre donc la chaîne caractère par caractère avec un décalage croissant.

## Exploitation

Lecture du fichier token en hexadécimal :

```
hexdump -C token
```

Conversion en ASCII, puis décodage inverse :

```
ascii(token) - index
```

Mot de passe reconstruit :

```
f3iji1ju5yuevaus41q1afiuq
```

Connexion et récupération du flag :

```
su flag09
Password: f3iji1ju5yuevaus41q1afiuq
getflag
Check flag.Here is your token : s5cAJpM8ev6XHw998pRWG728z
```

## Résultat

- Technique - > Chiffrement positionnel (Caesar variable)
- Password flag09 - > f3iji1ju5yuevaus41q1afiuq
- Token getflag - > s5cAJpM8ev6XHw998pRWG728z

## Notes

- Vulnérabilité : obscurcissement faible, réversible par observation dynamique
- ptrace empêche le debug mais pas l’analyse logique
- Correction : utiliser un vrai mécanisme cryptographique, pas une transformation déterministe simple
