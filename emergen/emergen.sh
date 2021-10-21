#####################
#Date: 21/10/2021
#Author: Valentine Lesourd-Aubert
#Object: pre-completion of emergen template
#####################

cd /

## PARAMETERS ##

#Variables
drive="//zisilon03/N02UDC1" #à modifier
nextseq_dir="$drive"/nextseq_results
lineages_dir="LINEAGES"

#Log informations
echo -e "\n"
now=$(date +%Y%m%d)
current_year=$(date +%Y)
run=$(ls -t /${nextseq_dir}/${current_year}/ | head -1)
echo "date: $now"
echo "lastest run: $run"

## MAIN ##

#Go into nextseq_results directory, current year directory and lastest run directory


echo "Check if LINEAGES directory is available."
run_dir="$nextseq_dir"/"$current_year"/"$run"
if ! [ -d "$run_dir"/"$lineages_dir" ]; then
    echo "ERROR: Process stopped. No '${lineages_dir}' directory available."
    exit 1
else
    echo "Check if xlsx template file and version.txt are available."
    if ! [ -f "$drive"/NGS\ COVID/EMERGEN/*.xlsx ] && [ -f "$drive"/NGS\ COVID/EMERGEN/version.txt ]; then
        echo "ERROR: Process stopped. No xlsx template file or no version.txt file available."
        exit 1
    else
        echo "Check if RUN directory for new xlsx emergen file already exists."
        num_run=$(python -c 'import re; print(re.findall(r"\d{1}", "'$run'")[0])')
        export_dir="${drive}/NGS COVID/EMERGEN/RUN ${num_run}"
        if [ -d "$export_dir" ];then
            echo "ERROR: Process stopped. A xlsx emergen file for run '${run}' already exists."
            exit 1
        else
            echo "Create new RUN directory for new xlsx emergen file."
            sudo mkdir -m 777 -p "$export_dir"

            echo "Get xlsx template filepath."
            path_xlsx=$(ls ${drive}/NGS\ COVID/EMERGEN/*.xlsx | head -1)

            echo "Run trame.py."
            sudo python3 /var/local/CRONfiles/emergen.py "$path_xlsx" "$export_dir" "$run" "$run_dir"

            echo "Check if new xlsx has been created."
            if ! [ -f "$export_dir"/*.xlsx ]; then
                echo "ERROR: No xlsx emergen file created. A problem occurs when running trame.py ."
                exit 1
            else
                echo "New xlsx emergen file created."
                echo "EXIT CODE: $?"
            fi
        fi
    fi
fi
