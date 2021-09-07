# kubeflow-mnist

## Running Locally

Install the Conda environment:

```sh
conda env create -f environment.yml
```

Then run training:

```sh
% python preprocessing.py --data_dir data
% python train.py --data_dir data --model_path export
```

## Building the image
docker build -t k1 .

## Run the image
docker run --name kubeflow -v containers:/var/lib/containers -it --rm k1 


## Exec build-script
docker exec kubeflow sh -c ./build-script.sh

## Tensorflow Serving

docker run -t --rm -p 8501:8501 \
    -v "$PWD/export:/models/mnist" \
    -e MODEL_NAME=mnist \
    tensorflow/serving:2.4.2

asx