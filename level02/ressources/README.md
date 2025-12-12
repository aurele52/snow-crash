# SnowCrash - level02 writeup

## Objectif

Extraire le mot de passe de flag02 depuis un fichier PCAP, se connecter, puis exécuter getflag.

## Recon

Analyse du trafic réseau avec tcpdump en affichage hex + ASCII :

```
tcpdump -qns 0 -X -r level02.pcap
```

Le flux correspond à une session type Telnet (négociation IAC visible via ff fb, ff fd, etc.).

## Analyse

Après le prompt Password: on observe les caractères envoyés par le client.

Dans la sortie tcpdump, le contenu est affiché en ASCII et certains caractères apparaissent comme des points ..
Dans ce contexte, . correspond à un caractère non imprimable, ici un retour arrière (backspace \b), ce qui modifie le mot de passe final tapé.

Reconstruction - mot de passe final :

```
"ft_wandr...NDRel.L0L"
```

En interprétant . comme backspace, on obtient :

```
ft_waNDReL0L
```

## Exploitation

Connexion au compte flag02 :

```
su flag02
Password: ft_waNDReL0L
```

Récupération du token :

```
getflag
Check flag.Here is your token : kooda2puivaav1idi4f57q8iq
```

## Résultat

- Password flag02 - > ft_waNDReL0L
- Token getflag - > kooda2puivaav1idi4f57q8iq

## Notes

- Source : capture réseau (PCAP)
- Point important : gérer les caractères de contrôle (backspace) lors de la reconstruction
- Outils : tcpdump -X (ou Wireshark / tshark équivalents)
