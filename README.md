# mnist

## Building the image
docker build -t quay.io/j0hnniewa1ker/mnist  . 

## Run the image
docker run --name mnist1 -v containers:/var/lib/containers --rm -it quay.io/j0hnniewa1ker/mnist

## Copy Files into container
docker cp environment.yml  mnist1:/tmp/
docker cp preprocessing.py  mnist1:/tmp/
docker cp train.py  mnist1:/tmp/
docker cp constants.py  mnist1:/tmp/
docker cp build-script.sh mnist1:/tmp/

## Exec build-script
docker exec mnist1 sh -c ./build-script.sh

## Tensorflow Serving

docker run -t --rm -p 8501:8501 \
    -v "$PWD/export:/models/mnist" \
    -e MODEL_NAME=mnist \
    tensorflow/serving:2.4.2

asx