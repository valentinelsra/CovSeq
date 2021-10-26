#!/usr/bin/bash
# On se place dans le dossier d'exports du nextseq
cd /media/ngs_archive/nextseq_results/

#date actuelle
now=$(date +%Y%m%d)
current_year=$(date +%Y)
run=$(ls -t /media/ngs_archive/nextseq_results/ | head -1)
echo "date: $now"
echo "run date: $run"

# Parametrage

#Verification de la date de creation du dernier fichier cree par le nextseq dans le dernier dossier cree
last_dir=/media/ngs_archive/nextseq_results/$(ls -t|head -1)/
last_file="$last_dir"CompletedJobInfo.xml

error_file="$last_dir"Calling_pipeline/Log/error.txt
succeed_file="$last_dir"Calling_pipeline/Log/no_error.txt

## FUNCTIONS ##
checkPipelineProcess () {
    last_f="$1".qc.csv
    if [ -f "$last_f" ]
    then
        return 1
    else
        return 0
    fi
}

# DEBUT MODIFICATIONS ------------

runImages () {
    #update de l'image
    echo "Update docker '${2}' image."
    sudo /usr/bin/docker pull "$1"

    #Run de l'image avec le dossier run lie au dossier data du conteneur
    echo "Run '${2}' docker image and mount volume 'output_dir'."
    sudo /usr/bin/docker run --name $3 -itd -v "$export_dir:/data" --workdir /data "$1"

    #Run l'analyse avec le fichier fasta
    case "$2" in
        "nextclade")
            echo "Create text file with '${2} release."
            version=$(sudo /usr/bin/docker exec -i $3 ${2} -v)
            sudo /usr/bin/docker exec -i $3 bash -c "echo '$version (docker)' > $new_lin_dir/$2/version.txt"
            #Load nextclade dataset pour le SARS-CoV-2
            echo "Load '${2}' dataset."
            sudo /usr/bin/docker exec -i $3 "$2" dataset get --name='sars-cov-2' --output-dir="$new_lin_dir/$2/dataset"
            #Run de l'analyse avec le fichier fasta et le dataset nextclade
            echo "Run '${2}' lineages assignment."
            sudo /usr/bin/docker exec -i $3 "$2" --in-order --input-fasta=$FA --input-dataset="$new_lin_dir"/"$2"/dataset --output-csv="$new_lin_dir"/"$2"/nextclade.csv --output-dir="$new_lin_dir"/"$2"/ --output-basename="$2"
        ;;
        "pangolin")
            echo "Run '${2}' lineages assignment."
            sudo /usr/bin/docker exec -i $3 "$2" --outdir "$new_lin_dir"/"$2" /data/$FA
        ;;
    esac
    echo "EXIT CODE: $?"
    sudo /usr/bin/docker stop $3
}

# FIN MODIFICATIONS ------------

if [ -f $last_file ]; then
        last_file_date=$(date -r $last_file +%Y%m%d)
        let "diff=now-last_file_date"
        echo "Le fichier a $diff jours"
        if [[ diff -le 1 ]]; then
                ## PARAMETRAGE
                fastq_dir=$(find $last_dir -name Fastq)
                prefix=$(grep ExperimentName "$last_dir"RunParameters.xml|cut -d">" -f2|cut -d"<" -f1)

                #Concatenation des fastq
                if [[ ! -d  "$fastq_dir"/Fastq_reads/ ]]
                then
                        sudo mkdir -p "$fastq_dir"/Fastq_reads/
                        echo "Concatenation des fastq"
                        patients_ID=$(ls $fastq_dir|grep fastq.gz|grep -v Undetermined|cut -d"_" -f1|sort|uniq)
                        for patient_ID in $patients_ID
                        do
                                cat "$fastq_dir"/"$patient_ID"*R1*>"$fastq_dir"/Fastq_reads/"$patient_ID"_R1.fastq.gz
                                cat "$fastq_dir"/"$patient_ID"*R2*>"$fastq_dir"/Fastq_reads/"$patient_ID"_R2.fastq.gz
                        done
                        echo "Fastq concatenes dans $fastq_dir"
                fi

                # Recuperation du nombre de patients
                NB=$(ls "$fastq_dir"/Fastq_reads/|cut -d"_" -f1|sort|uniq|wc -l)
                run_name=$(grep ExperimentName "$last_dir"RunParameters.xml|cut -d">" -f2|cut -d"<" -f1)
                if grep -q COVID $last_file
                then
                        # Creation du dossier de resultats
                        output_dir="$last_dir"Calling_artic_pipeline/
                        sudo mkdir -p $output_dir

                        # On se place dans le repertoire contenant nextflow
                        cd /var/local/sarscov2/ncov2019-artic-nf/

                        # Lancement du pipeline artic
                        echo "Lancement du pipeline artic pour le run $run_name"
                        sudo ./nextflow run ../ncov2019-artic-nf/ -profile singularity --illumina --prefix "$prefix" --directory "$fastq_dir"/Fastq_reads/ --outdir "$output_dir"

                else
                        echo "Not a COVID run"
                fi
                while checkPipelineProcess "$output_dir"/"$prefix"
                do
                    sleep 5m
                done

                # Verification que tous les patients ont ete analyses
                NB_OUT=$(ls "$output_dir"/ncovIllumina_sequenceAnalysis_callVariants/*.variants.tsv|wc -l)

                echo " Generate multifasta and Moving files if they exist"
                if [[ "$NB" = "$NB_OUT" ]]
                then
                        export_dir=/media/n02udc01/nextseq_results/"$current_year"/"$run_name"/
                        new_var_dir="$export_dir"VARIANTS/
                        new_cons_dir="$export_dir"CONSENSUS/
                        output_sup="$output_dir"/coverageOver95.txt
                        output_inf="$output_dir"/coverageUnder95.txt
                        multifasta="$output_dir"/"$run_name"_sup95.multi.fasta

                        if [ ! -f $multifasta ]; then
                                echo "Create output directories..."
                                sudo mkdir -p "$new_var_dir"
                                sudo mkdir -p "$new_cons_dir"

                                echo "Filter coverage >=95%"

                                sed '1d' "$output_dir"/"$prefix".qc.csv|sudo awk -v of1="$output_inf" -v of2="$output_sup" 'BEGIN{FS=",";NR == 2;print "#Percentage covered bases inferior to 95%">of1 ; print "#Percentage covered bases superior or egual to 95%">of2}{if ($3>=95){print $6 > of2}else{print $1>of1}}'
                                while read line; do cat "$output_dir"/ncovIllumina_sequenceAnalysis_makeConsensus/"$line" | sudo tee -a "$multifasta" > /dev/null; done < "$output_sup"

                                echo "Moving files..."
                                new_var_dir="$export_dir"VARIANTS/
                                new_cons_dir="$export_dir"CONSENSUS/
                                echo "Create output directory..."
                                sudo mkdir -p "$new_var_dir"
                                sudo mkdir -p "$new_cons_dir"

                                # copy files : variants, consensus FASTA and QC file
                                sudo cp -r "$output_dir"/ncovIllumina_sequenceAnalysis_callVariants/* "$new_var_dir"
                                sudo cp -r "$output_dir"/ncovIllumina_sequenceAnalysis_makeConsensus/* "$new_cons_dir"
                                sudo cp "$output_dir"/"$prefix".qc.csv /media/n02udc01/nextseq_results/"$current_year"/"$run_name"/
                                sudo cp "$output_sup" "$export_dir"
                                sudo cp "$output_inf" "$export_dir"
                                sudo cp "$multifasta" "$export_dir"

                                # delete working dir
                                sudo rm -rf /var/local/sarscov2/ncov2019-artic-nf/work/*

                                # Export BAM files et generation des index
                                sudo cp "$output_dir"/ncovIllumina_sequenceAnalysis_readMapping/* /media/n02udc01/nextseq_results/"$current_year"/"$run_name"/BAM/
                                cd /media/n02udc01/nextseq_results/"$current_year"/"$run_name"/BAM/
                                for bam in `ls`
                                do
                                        sudo samtools index $bam
                                done
                                cd -

                                # export FASTQ files
                                sudo cp "$output_dir"/ncovIllumina_sequenceAnalysis_readTrimming/* /media/n02udc01/nextseq_results/"$current_year"/"$run_name"/FASTQ/

                                # DEBUT MODIFICATIONS ------------

                                # Parameters for Nextclade and Pangolin
                                commandes=("nextclade" "pangolin")
                                images=("nextstrain/nextclade:latest" "staphb/pangolin:latest")
                                new_lin_dir="LINEAGES"
                                FA="$run_name"_sup95.multi.fasta
                                
                                #Run Nextclade and Pangolin images
                                echo "Nextclade and Pangolin..."
                                for var in 0 1
                                        do
                                        echo "Generate Nextclade and Pangolin output directories."
                                        sudo mkdir -p "$export_dir"/"$new_lin_dir"/${commandes[var]}
                                        container_name="$run_name$var"
                                        sudo runImages ${images[var]} ${commandes[var]} "$container_name"
                                        done

                                # FIN MODIFICATIONS ------------

                        else
                                echo "Analyse already done and files generated"
                else
                        echo "Pipeline ended with error...not the good number of patient at the end : files have not been moved"
                fi
                echo "Fin de l'analyse du run COVID $run_name"
        else
                echo "Le fichier a plus de 3 jours ($diff jours)."
        fi
else
        echo "Le fichier n'existe pas"
fi
                                                             
