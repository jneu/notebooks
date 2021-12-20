FROM continuumio/miniconda3

# choose a name for the non-root user that will run in this container
ARG RUN_AS_USER=nb
# choose a version of python
ARG PYTHON_VERSION=3.8

###
# commands run as root
###

# update system packages and conda
RUN \
    apt-get update && \
    apt-get upgrade --yes && \
    apt-get install --yes \
        build-essential \
    && \
    conda update --name base --channel defaults conda

# create the non-root user and give it control of conda
RUN \
    useradd --create-home $RUN_AS_USER && \
    chown --recursive $RUN_AS_USER:$RUN_AS_USER /opt/conda

###
# commands not run as root
###

# switch to the non-root user from here on out
USER $RUN_AS_USER

# set up the shells for conda use
SHELL ["/bin/bash", "-c"]
RUN \
    conda init && \
    echo 'eval "$(/opt/conda/bin/conda shell.bash hook)"' >> ~/.bash_env
ENV BASH_ENV=/home/$RUN_AS_USER/.bash_env

# create a conda environment and activate it by default
RUN \
    conda create --name notebooks_env python=$PYTHON_VERSION && \
    echo 'conda activate notebooks_env' >> ~/.bashrc && \
    echo 'conda activate notebooks_env' >> ~/.bash_env

# install a base set of packages; we want the latest of each
RUN \
    pip install \
        jupyter \
        papermill

# create a working directory
RUN mkdir --parents ~/notebooks/src
WORKDIR /home/$RUN_AS_USER/notebooks/
COPY --chown=$RUN_AS_USER:$RUN_AS_USER \
    cicd/docker/run_notebooks.bash ./run_notebooks.bash
