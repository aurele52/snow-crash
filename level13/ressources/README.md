# SnowCrash - level13 writeup

## Objectif

Contourner la vérification d’identité dans level13 en forçant la valeur de retour d’une fonction (ex: getuid() / getuuid()) dans gdb, afin d’obtenir le token.

## Recon

Traçage rapide :

```
ltrace ./level13
```

Le binaire effectue une vérification basée sur l’UID (ou un identifiant dérivé) avant d’afficher le résultat.

## Analyse

Le contrôle repose sur une valeur en registre (retour de fonction).
Sous x86 32-bit, la valeur de retour est généralement dans EAX.

Si on intercepte l’exécution juste après le retour de la fonction de vérification et qu’on force EAX à 4242, on passe le test.

## Exploitation

Démarrage sous gdb et placement des breakpoints :

```
gdb ./level13
b main
b getuuid
run
```

Avancer pas à pas jusqu’au retour de la fonction, puis revenir au point d’appel :

```
n
finish
info register
```

Forcer la valeur de retour à 4242 :

```
set $eax=4242
```

Continuer l’exécution pour déclencher l’affichage du token :

```
n
n
```

## Résultat

- Technique - > Bypass de contrôle logique via modification de registre dans gdb
- Valeur forcée - > EAX = 4242 pour passer la vérification

## Notes

- Sur architecture i386, EAX contient la valeur de retour d’une fonction (convention d’appel)
- Alternative - patch binaire (nop du jump conditionnel) mais gdb suffit pour la soutenance
- Si ton symbole n’est pas getuuid, tu peux aussi break sur getuid / geteuid ou sur l’adresse du call trouvée via disas main
