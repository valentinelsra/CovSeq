###############################
# Autrice : Valentine Lesourd-Aubert
# Date de création : 13 Octobre 2021
# Objet : Suppression du dossier BAM contenu dans le dossier run précédent le dossier run le plus récent
###############################

### Création du fichier de Log

#$LogFile = "T:\Valentine\logs\"

#New-Item -Path $LogFile -Name "bam_covid.log" -type "file" -Force

#Début du bloc de script

#{

    ## PARAMETRAGE ##

    #date actuelle
    echo "`n"
    $now= Get-Date -Format "yyMMdd_HHmm"
    $current_year= Get-Date -Format "yyyy"
    echo "date : $now"
    #date de l'avant-dernier run et nom
    $run= Get-ChildItem N:/nextseq_results/$current_year $dir | Sort-Object CreationTime -Descending | Select-Object -Index 1
    $run_date= $run.LastWriteTime
    echo "run date : $run_date | name: $run "

    ## MAIN ##

    #Suppression du dossier BAM s'il existe

    $bam_dir = $run.FullName | Join-Path -ChildPath "BAM"
    echo "test if there is existing $bam_dir"
    If( Test-Path -Path $bam_dir -ErrorAction SilentlyContinue ) 
    { 
    echo "$bam_dir exists"
    Remove-Item $bam_dir
    If( Test-Path -Path $bam_dir -ErrorAction SilentlyContinue )
    {
        echo "ERROR : $bam_dir has not been removed"
    }
    Else
    {
        echo "$bam_dir have been successfully removed"
    }
    }
    Else
    {
    echo "$bam_dir doesn't exist, already been removed?"
    } 

#} &gt; $LogFile

#Fin block de script