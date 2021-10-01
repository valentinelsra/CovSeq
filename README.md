<h1 id="CovSeq" align="center">
CovSeq 
</h1>

<p id="CovSeq" align="center">
💻 Processing data from whole-genome sequencing of sars-cov-2. 
</p>




## 🐋 Nextclade Analysis

Run the nextclade docker image with multi.fasta file from the latest output of sars-cov-2 pipeline.

![Link to nextclade docker image.]("https://img.shields.io/docker/v/nextstrain/nextclade?label=%F0%9F%90%8B%20%20%20docker%3Anextclade")
 
### 📦 Requirements
   
- Installation de Augur requise pour exécuter nextclade :

``` python3 -m pip install nextstrain-augur ```

-  Pull de la dernière version de l’image docker nextclade :

``` docker pull nextstrain/nextclade:latest ```

- Cron à implémenter dans crontab -e :

``` 0 13 * * * /path/to/nextclade.sh >> /path/to/nextclade.log 2>&1 ```

- Permissions ok :

``` chmod 777 /path/to/nextclade.sh ```

## 🌍 Pangolin Analysis

---

<h2 id="maintenedby" align="center">
✨ Maintained by :
</h2>

<table align="center">
  <tr>
  <td align="center">
<p align="center">
  <p align="center">
    <a href="https://github.com/valentinelsra"> 
      <img src="https://avatars.githubusercontent.com/valentinelsra" width="100px;" alt=""/>
    </a> 
  </p>
  <p align="center">
    <p align="center">
      <a href="https://github.com/valentinelsra">
      Valentine Lesourd-Aubert
      </a>
    </p>
    <p align="center">
      <small>Junior Bio-informatician</small></br>
      <small>COVID Platform, Virology Service, CHU Bordeaux</small></br>
    </p>
  </p>
  </td>
  </tr>
</table>
