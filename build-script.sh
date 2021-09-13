# Build Conda Environment
/opt/conda/bin/conda update -y -n base -c defaults conda
/opt/conda/bin/conda env create -f /tmp/environment.yml
/opt/conda/bin/conda clean -afy

export PATH=$PATH:/opt/conda/envs/kubeflow-mnist/bin
/opt/conda/bin/activate kubeflow-mnist

# Pre-process
python preprocessing.py --data_dir=/root/data 
# Train
python train.py --data_dir=/root/data 

# path from /workspace/kubeflow-mnist/output.txt 
export MNIST_PATH=$(cat /workspace/kubeflow-mnist/output.txt) && \
   tar -czvf /var/lib/containers/mnist.tar.gz $MNIST_PATH

