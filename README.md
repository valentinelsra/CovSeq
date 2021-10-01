<h6 id="CovSeq" align="center">
Processing data from whole-genome sequencing of sars-cov-2. 
</h6>

<p align="center">
   <img alt="build succeeded" src="https://img.shields.io/badge/build-succeeded-brightgreen.svg">
</p>






<h1 id="nextclade" align="center">
💻🐋 Nextclade Analysis
</h1>

<p align="center">
<img alt="Nextclade Docker image version" src="https://img.shields.io/docker/v/nextstrain/nextclade?label=%F0%9F%90%8B%20%20%20docker%3Anextclade"> Run the docker image of nextclade with multi.fasta file from the latest sars-cov-2 run.
</p>
   
<p align="center">
Outputs: Viral genome clade assignment, mutation calling, and sequence quality checks.
</p>


📖 ⚠️ 🌍 🔧

<h3 id="prerequis" align="center">
📦 Requirements
</h3>


- Installation de Augur requise pour exécuter nextclade :

``` python3 -m pip install nextstrain-augur ```

-  Pull de la dernière version de l’image docker nextclade :

``` docker pull nextstrain/nextclade:latest ```

- Cron à implémenter dans crontab -e :
- 
``` 0 13 * * * /path/to/nextclade.sh >> /path/to/nextclade.log 2>&1 ```

- Permissions ok :

``` chmod 777 /path/to/nextclade.sh ```



<h2 id="pangolin" align="center">
💻✨ Pangolin Analysis
</h2>



---

<h2 id="maintenedby" align="center">
Maintained by :
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

I am thankful to all contributors, no matter how they contribute: in ideas, science, code, documentation or otherwise. Thanks goes to these people (<a target="_blank" rel="noopener noreferrer" href="https://allcontributors.org/docs/en/emoji-key">emoji key</a>):

---

<h2 id="license" align="center">
⚖️ License
</h2>

<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="../../LICENSE" alt="License file">MIT License</a>
</p>
