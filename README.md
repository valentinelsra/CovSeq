<h1 id="CovSeq" align="center">
CovSeq 
</h1>

<p id="CovSeq" align="center">
Processing data from whole-genome sequencing of sars-cov-2. Tested on MacOS.
</p>

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.04.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)


## 💻 lineages.sh

Little script Bash running the Nextclade and Pangolin docker images with multi.fasta file from the latest output of sars-cov-2 artic pipeline.

[Link to nextclade docker image]("https://hub.docker.com/r/nextstrain/nextclade")

[Link to pangolin docker image]("https://hub.docker.com/r/staphb/pangolin")
 
### 📦 Requirements

You need to install Docker, than :
   
- Create a cron

``` 0 13 * * * /path/to/nextclade.sh >> /path/to/nextclade.log 2>&1 ```

- Set permissions for the executable file

``` chmod 777 /path/to/nextclade.sh ```

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
