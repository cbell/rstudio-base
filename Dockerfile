# jupyter/r-notebook:414b5d749704 latest as of 02-03-2020
# version description: Major.Minor.Fix 
FROM jupyter/r-notebook:414b5d749704 
USER root

RUN sudo apt-get update && \
    sudo apt-get install gdebi-core -y && \
    wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5033-amd64.deb && \
    sudo gdebi  --non-interactive rstudio-server-1.2.5033-amd64.deb && \
    rm -rf rstudio-server-1.2.5033-amd64.deb && \
    wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb && \
    sudo gdebi --non-interactive shiny-server-1.5.12.933-amd64.deb && \
    rm -rf shiny-server-1.5.12.933-amd64.deb && \
# latest version of rstudio-server as of 02-03-2020
    echo r-libs-user=~/R/packages >> /etc/rstudio/rsession.conf && \
# isolate user packages to a nice and clean folder 
    sudo ln /usr/bin/R /usr/local/bin/R && \
    mkdir -p /home/jovyan/R/packages && \
    pip install jupyter-rsession-proxy && \ 
    fix-permissions /home/jovyan

USER jovyan
