# CovSeq
Processing data from whole-genome sequencing of sars-cov-2.

[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)  [![forthebadge](http://forthebadge.com/images/badges/powered-by-electricity.svg)](http://forthebadge.com)

## NEXTCLADE ANALYSIS

### PRE-REQUIS

Installation de Augur requise pour exécuter nextclade :
python3 -m pip install nextstrain-augur

Pull de la dernière version de l’image docker nextclade :
docker pull nextstrain/nextclade:latest

Cron à implémenter dans crontab -e :
0 13 * * * /path/to/nextclade.sh >> /path/to/nextclade.log 2>&1

Permissions ok :
chmod 777 /path/to/nextclade.sh

