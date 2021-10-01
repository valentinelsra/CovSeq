
[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)  [![forthebadge](http://forthebadge.com/images/badges/powered-by-electricity.svg)](http://forthebadge.com)

### PRE-REQUIS



Pull de la dernière version de l’image docker nextclade :
docker pull nextstrain/nextclade:latest

Cron à implémenter dans crontab -e :
0 13 * * * /path/to/nextclade.sh >> /path/to/nextclade.log 2>&1

Permissions ok :
chmod 777 /path/to/nextclade.sh

<h1 id="CovSeq" align="center">
CovSeq
</h1>

<h4 id="CovSeq" align="center">
Processing data from whole-genome sequencing of sars-cov-2.
</h4>


<p align="center">
  <a href="https://app.circleci.com/pipelines/github/nextstrain/nextclade?branch=master">
    <img src="https://img.shields.io/circleci/build/github/nextstrain/nextclade/master?label=build%3Amaster" alt="CircleCI master branch">
  </a>

  <a href="https://app.circleci.com/pipelines/github/nextstrain/nextclade?branch=staging">
    <img src="https://img.shields.io/circleci/build/github/nextstrain/nextclade/staging?label=build%3Astaging" alt="CircleCI staging branch">
  </a>

  <a href="https://app.circleci.com/pipelines/github/nextstrain/nextclade?branch=release">
    <img src="https://img.shields.io/circleci/build/github/nextstrain/nextclade/release?label=build%3Arelease" alt="CircleCI release branch">
  </a>

  <a href="https://app.circleci.com/pipelines/github/nextstrain/nextclade?branch=release-cli">
    <img src="https://img.shields.io/circleci/build/github/nextstrain/nextclade/release-cli?label=build%3Arelease-cli" alt="CircleCI release-cli branch">
  </a>

  <a href="https://securityheaders.com/?q=clades.nextstrain.org&followRedirects=on">
    <img src="https://img.shields.io/security-headers?url=https%3A%2F%2Fclades.nextstrain.org" alt="Security Headers" />
  </a>
  <a href="https://observatory.mozilla.org/analyze/clades.nextstrain.org">
    <img src="https://img.shields.io/mozilla-observatory/grade/clades.nextstrain.org" alt="Mozilla Observatory" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/valentinelsra/CovSeq/commits?author=valentinelsra">
    <img
      src="https://img.shields.io/github/last-commit/CovSeq?logo=github"
      alt="GitHub last commit"
    />
  </a>

  <a href="https://github.com/valentinelsra/CovSeq/commits?author=valentinelsra">
    <img
      src="https://img.shields.io/github/commit-activity/w/nextstrain/nextclade"
      alt="GitHub commit activity"
    />
  </a>
</p>

</p>

---


<h2 id="nextclade" align="center">
💻🐋 Nextclade Analysis
</h2>
  
Viral genome clade assignment, mutation calling, and sequence quality checks
Docker Image of Nextclade: https://docs.nextstrain.org/projects/nextclade

<a href="https://hub.docker.com/r/nextstrain/nextclade">
      <img alt="Nextclade Docker image version" src="https://img.shields.io/docker/v/nextstrain/nextclade?label=%F0%9F%90%8B%20%20%20docker%3Anextclade">
  </a>


📖 ⚠️ 🌍 🔧

<h3 id="prerequis" align="center">
📦 Pré-requis
</h3>
- Installation de Augur requise pour exécuter nextclade :

python3 -m pip install nextstrain-augur

-  

<h2 id="documentation" align="center">
💻✨ Pangolin Analysis
</h2>


It is maintained by:

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

<h2 id="license" align="center">
⚖️ License
</h2>

<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="../../LICENSE" alt="License file">MIT License</a>
</p>
