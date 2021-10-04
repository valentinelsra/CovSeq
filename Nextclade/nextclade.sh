#! /bin/bash

###PRE-REQUIS

##Installation de Augur requise pour exécuter nextclade 
#python3 -m pip install nextstrain-augur

##Pull de la dernière version de l’image docker nextclade
#docker pull nextstrain/nextclade:latest

##Cron à implémenter dans crontab -e
#0 13 * * * /path/to/nextclade.sh >> /path/to/nextclade.log 2>&1

##Permissions ok
#chmod 777 /path/to/nextclade.sh

###ANALYSE
echo -e "\n$(date)"

##Déclaration variables modifiables
dNEXTSEQ="Users/valentinelesourd-aubert/nextseq_results/" #à modifier ("/path/to/nextseq_results/")
moAN="20"
moRUN="COVID_RUN"
dOUTPUT="nextclade"

##Vérification présence répertoire nextseq_results
cd /
if [ -d $dNEXTSEQ ]; then
    
    cd $dNEXTSEQ
    #Sélection du répertoire année le plus récent
    an=$(find . -type d -name ${moAN}\* -maxdepth 1 -exec stat -t%N {} \; | sort -r | head -1 | awk '{print $16}')
    cd "${an:2}"

    #Sélection du répertoire RUN le plus récent
    run=$(find . -type d -name ${moRUN}\* -maxdepth 1 -exec stat -t%N {} \; | sort -r | head -1 | awk '{print $16}')
    chmod 777 "${run:2}"
    cd "${run:2}"
    
    #Vérification pas de précédente analyse nextclade et création répertoire pour output
    if [ -d $dOUTPUT ]; then
        echo "ERROR: Docker image 'nextstrain/nextclade:latest' wasn't run. A nextclade directory already exists."
        exit 1
    fi
    mkdir -m 777 $dOUTPUT
    
    #Run de l'image avec le répertoire du fichier multi.fasta lié au répertoire mnt du conteneur et lie le dossier nextclade au output
    docker run -itd -v "${PWD}:/output" nextstrain/nextclade:latest
    
    #Récupère l'ID du dernier conteneur soit celui en cours d'exécution et le nom du fichier fasta
    ID=$(docker ps | grep 'nextstrain/nextclade:latest' -m 1 | awk '{ print $1 }')
    FA=$(find . -name '*.fasta')

    #Load nextclade dataset pour le SARS-CoV-2
    docker exec -i "$ID" nextclade dataset get --name='sars-cov-2' --output-dir="output/${dOUTPUT}/dataset"

    #Run l'analyse avec le fichier fasta et le dataset nextclade
    docker exec -i "$ID" nextclade --in-order --input-fasta=output/${FA:2} --input-dataset=output/$dOUTPUT/dataset --output-csv=output/$dOUTPUT/nextclade.csv --output-dir=output/$dOUTPUT/ --output-basename=nextclade
    
    echo "EXIT CODE: $?"
    
    docker stop "$ID"
else
    echo "ERROR: Process stopped. Nextseq directory not found".
    exit 1
fi
