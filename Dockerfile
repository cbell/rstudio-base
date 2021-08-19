# jupyter/r-notebook:feacdbfc2e89 latest as of 08-16-21
# version description: Major.Minor.Fix 
FROM jupyter/r-notebook:r-4.1.1
USER root
COPY rsession.conf /etc/rstudio/rsession.conf
ENV RSESSION_PROXY_RSTUDIO_1_4=yes
# Per jupyter-rsession-proxy install config

RUN sudo apt-get update && \
    sudo apt-get install gdebi-core -y && \
    wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb && \
    sudo gdebi rstudio-server-1.4.1717-amd64.deb -n && \
    rm -rf rstudio-server-1.4.1717-amd64.deb && \
    sudo su - \
    -c "R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\"" && \
    wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.16.958-amd64.deb
RUN cat /etc/rstudio/rsession.conf
RUN sudo gdebi shiny-server-1.5.16.958-amd64.deb -n && \
    rm -rf shiny-server-1.5.16.958-amd64.deb
# latest version of rstudio-server as of 08-19-2021
# isolate user packages to a nice and clean folder 
RUN sudo ln /usr/bin/R /usr/local/bin/R && \
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
    RUN fix-permissions /var/lib/rstudio-server/rstudio.sqlite
    RUN fix-permissions /etc/rstudio

USER jovyan