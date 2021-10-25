runImages () {
    
    #update de l'image
    echo "Update docker '${2}' image."
    docker pull "$1"
    
    #Run de l'image avec le dossier run lie au dossier data du conteneur
    echo "Run '${2}' docker image and mount volume 'output_dir'."
    docker run --name $3 -itd -v "/$export_dir:/data" --workdir /data "$1"

    #recupere l'ID du dernier conteneur soit celui en cours d'execution
    #echo "Get '${2}' docker image ID."
    #ID=$(docker ps | grep "$1" -m 1 | awk '{ print $1 }')
    
    #Run l'analyse avec le fichier fasta
    case "$2" in
        "nextclade")
            #Creation fichier texte avec version nc
            #echo "Create '${2}' version.txt."
            #docker exec -i $ID touch -f data/$output_dir/$2/version.txt
            #docker exec echo
            #docker exec -i $3 touch -f test.txt
            version=$(docker exec -i $3 ${2} -v)
            docker exec -i $3 bash -c "echo '$version (docker)' > $output_dir/$2/version.txt"
            #Load nextclade dataset pour le SARS-CoV-2
            echo "Load '${2}' dataset."
            docker exec -i $3 "$2" dataset get --name='sars-cov-2' --output-dir="$output_dir/$2/dataset"
            #Run l'analyse avec le fichier fasta et le dataset nextclade
            echo "Run '${2}' lineages assignment."
            docker exec -i $3 "$2" --in-order --input-fasta=$FA --input-dataset="$output_dir"/"$2"/dataset --output-csv="$output_dir"/"$2"/nextclade.csv --output-dir="$output_dir"/"$2"/ --output-basename="$2"
        ;;
        "pangolin")
            echo "Run '${2}' lineages assignment."
            docker exec -i $3 "$2" --outdir "$output_dir"/"$2" /data/$FA
        ;;
    esac
    echo "EXIT CODE: $?"
    docker stop $3

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

        #recuperation nom du fichier fasta
        FA=$(find /$export_dir -name '*.fasta'| sed 's@.*/@@')

        #run nextclade et pangolin
        echo "Run Nextclade and Pangolin..."
        for var in 0 1
        do
            mkdir -m 777 -p "$export_dir"/"$output_dir"/${commandes[var]}
            #if [ ${commandes[var]} == 'nextclade' ]; then
                #touch -f $export_dir/version.txt #touch -f $export_dir/$output_dir/${commandes[var]}/version.txt
            #fi
            
            container_name="test35$var" #"$run$var"
            runImages ${images[var]} ${commandes[var]} "$container_name"
        done

    else
        echo "ERROR: Process stopped. Any directory for the year '${current_year}' was found."
    fi
else
    echo "ERROR: Process stopped. 'nextseq_results' directory not found."
    exit 1
fi
