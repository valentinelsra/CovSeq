#!/usr/bin/env bash

## PRE-REQUIS ##

##Permissions
#chmod 777 /path/to/lineages.sh

##Cron a implementer dans crontab -e
#0 13 * * * /path/to/lineages.sh >> /path/to/lineages.log 2>&1

## PARAMETRES ##

#Variables non modifiables
nextseq_dir="Users/valentinelesourd-aubert/nextseq_results" #à modifier ("/path/to/nextseq_results/")
output_dir="LINEAGES"
commandes=("nextclade" "pangolin")
images=("nextstrain/nextclade:latest" "staphb/pangolin:latest")

#Date actuelle
echo -e "\n"
now=$(date +%Y%m%d)
current_year=$(date +%Y)
run=$(ls -t /${nextseq_dir}/${current_year}/ | head -1)
echo "date: $now"
echo "lastest run: $run"

## FONCTIONS ##

runImages () {
    
    #update de l'image
    echo "Update docker '${2}' image."
    docker pull "$1"
    
    #Run de l'image avec le dossier run lie au dossier data du conteneur
    echo "Run '${2}' docker image and mount volume 'output_dir'."
    docker run -itd -v "/$export_dir:/data" "$1"
    
    #recupere l'ID du dernier conteneur soit celui en cours d'execution
    echo "Get '${2}' docker image ID."
    ID=$(docker ps | grep "$1" -m 1 | awk '{ print $1 }')
    
    #Run l'analyse avec le fichier fasta
    case "$2" in
        "nextclade")
            #Load nextclade dataset pour le SARS-CoV-2
            echo "Get '${2}' dataset."
            docker exec -i "$ID" "$2" dataset get --name='sars-cov-2' --output-dir="data/$output_dir/$2/dataset"
            #Run l'analyse avec le fichier fasta et le dataset nextclade
            echo "Run '${2}' lineages assignment."
            docker exec -i "$ID" "$2" --in-order --input-fasta=data/$FA --input-dataset=data/"$output_dir"/"$2"/dataset --output-csv=data/"$output_dir"/"$2"/nextclade.csv --output-dir=data/"$output_dir"/"$2"/ --output-basename="$2"
        ;;
        "pangolin")
            echo "Run '${2}' lineages assignment."
            docker exec -i "$ID" "$2" --outdir "$output_dir"/"$2" /data/$FA
        ;;
    esac
    echo "EXIT CODE: $?"
    docker stop "$ID"

}

## MAIN ##

#on se place au niveau du repertoire racine
cd /

#verification du dossier nextseq_results
echo "Check 'nextseq_results' directory."
if [ -d "$nextseq_dir" ]; then
    
    #verification du dossier annee en cours
    echo "Check '${current_year}' directory."
    if [ -d "$nextseq_dir/$current_year" ]; then

        #verification dossier output_dir
        export_dir="$nextseq_dir"/"$current_year"/"$run"
        if [ -d "$export_dir"/"$output_dir" ]; then
            echo "ERROR: An output directory '${output_dir}' already exists."
            exit 1
        fi
        mkdir -m 777 -p "$export_dir"/"$output_dir"/"$nc" "$export_dir"/"$output_dir"/"$pg"

        #recuperation nom du fichier fasta
        FA=$(find /$export_dir -name '*.fasta'| sed 's@.*/@@')

        #run nextclade et pangolin
        echo "Run Nextclade and Pangolin..."
        for var in 0 1 ##{images[@]}
        do
            runImages ${images[var]} ${commandes[var]}
        done

    else
        echo "ERROR: Process stopped. Any directory for the year '${current_year}' was found."
    fi
else
    echo "ERROR: Process stopped. 'nextseq_results' directory not found."
    exit 1
fi
