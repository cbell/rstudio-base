# jupyter/r-notebook:feacdbfc2e89 latest as of 10-16-2020
# changing version due to issues reported here: https://github.com/jupyter/docker-stacks/issues/927
# version description: Major.Minor.Fix 
FROM jupyter/r-notebook:feacdbfc2e89
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
    pip install jupyter-rsession-proxy 
# Adding libudunits dependancies 
    COPY libudunits2-0_2.2.20-1+b1_amd64.deb /opt/
    COPY libudunits2-dev_2.2.20-1+b1_amd64.deb /opt/
    RUN dpkg -i /opt/libudunits2-0_2.2.20-1+b1_amd64.deb
    RUN apt-get install -f
    RUN dpkg -i /opt/libudunits2-dev_2.2.20-1+b1_amd64.deb
    RUN apt-get install -f
# Adding cutadapt
    RUN pip install cutadapt
    RUN fix-permissions /home/jovyan

USER jovyan
