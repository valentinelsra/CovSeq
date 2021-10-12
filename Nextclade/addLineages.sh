#!/usr/bin/env bash

## PARAMETRES ##

#Variables non modifiables
commandes=("nextclade" "pangolin")
images=("nextstrain/nextclade:latest" "staphb/pangolin:latest")

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
    case "$1" in
        "$nc_image")
            #Load nextclade dataset pour le SARS-CoV-2
            echo "Get '${2}' dataset."
            docker exec -i "$ID" "$2" dataset get --name='sars-cov-2' --output-dir="data/$output_dir/$2/dataset"
            #Run l'analyse avec le fichier fasta et le dataset nextclade
            echo "Run '${2}' lineages assignment."
            docker exec -i "$ID" "$2" --in-order --input-fasta=data/$FA --input-dataset=data/"$output_dir"/"$2"/dataset --output-csv=data/"$output_dir"/"$2"/nextclade.csv --output-dir=data/"$output_dir"/"$2"/ --output-basename="$2"
        ;;
        "$pg_image")
            echo "Run '${2}' lineages assignment."
            docker exec -i "$ID" "$2" --outdir "$output_dir"/"$2" /data/$FA
        ;;
    esac
    echo "EXIT CODE: $?"
    docker stop "$ID"

}

## MAIN ## à intégrer

new_lin_dir="$export_dir"LINEAGES/

if [ ! -f $multifasta ]; then
    echo "Generate nextclade and pangolin outputs."
    sudo mkdir -p "$newlin_dir"/"$nc"
    sudo mkdir -p "$new_lin_dir"/"$pg"

    echo "Nextclade and Pangolin..."
    for var in 0 1 ##{images[@]}
    do
        runImages ${images[var]} ${commandes[var]}
    done
