# tensorflow-mnist

## Building the image
docker build -t quay.io/ibmtechgarage/tensorflow-model-train  .

## Run the image
docker run --name tensorflow-mnist -v containers:/var/lib/containers --rm -it quay.io/ibmtechgarage/tensorflow-model-train

## Copy Files into container
docker cp environment.yml  tensorflow-mnist:/tmp/
docker cp preprocessing.py  tensorflow-mnist:/tmp/
docker cp train.py  tensorflow-mnist:/tmp/
docker cp constants.py  tensorflow-mnist:/tmp/
docker cp build-script.sh tensorflow-mnist:/tmp/

## Exec build-script
docker exec tensorflow-mnist sh -c ./build-script.sh

## Push up the image
docker push quay.io/ibmtechgarage/tensorflow-model-train

## Tensorflow Serving
?
docker run -t --rm -p 8501:8501 \
    -v "$PWD/export:/models/mnist" \
    -e MODEL_NAME=mnist \
    tensorflow/serving:2.4.2

asx