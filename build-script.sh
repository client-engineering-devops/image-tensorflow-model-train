# Pre-process
python preprocessing.py --data_dir=/root/data 
# Train
python train.py --data_dir=/root/data 

# path from /workspace/kubeflow-mnist/output.txt 
export MNIST_PATH=$(cat /workspace/kubeflow-mnist/output.txt) && \
   tar -czvf /var/lib/containers/kubeflow-mnist.tar.gz $MNIST_PATH

