#!/bin/bash

if [ -z "$1" ]; then
    echo -e "\n Missing agument.  Usage:  '${0} Model Repo Name '\n"
    exit 1
fi

MODEL_REPO_NAME=$1

# build conda environments
cp environment.yml /tmp/${MODEL_REPO_NAME}/conda/
/opt/conda/bin/conda update -n base -c defaults conda
/opt/conda/bin/conda env create -f /tmp/${MODEL_REPO_NAME}/conda/environment.yml
/opt/conda/bin/conda clean -afy

# switch to the conda environment
echo "conda activate ${MODEL_REPO_NAME}" >> ~/.bashrc
PATH=/opt/conda/envs/${MODEL_REPO_NAME}/bin:$PATH
/opt/conda/bin/activate ${MODEL_REPO_NAME}

# Pre-process

python preprocessing.py --data_dir=/root/data 
# Train
python train.py --data_dir=/root/data 

# path from /workspace/kubeflow-mnist/output.txt 
export MNIST_PATH=$(cat /workspace/kubeflow-mnist/output.txt) && \
    tar -czvf ${MODEL_REPO_NAME}.tar.gz $MNIST_PATH

# copy the tar to the build workspace path for the pipeline
cp ${MODEL_REPO_NAME}.tar.gz /tmp/.