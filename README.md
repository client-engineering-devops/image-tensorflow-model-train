# image-tensorflow-model-train
This repo builds an image with TensorFlow and Conda to be used with the [tensorflow-model-pipeline](https://github.com/itg-devops/ibm-garage-tekton-tasks/blob/model-pipeline/pipelines/tensorflow-model-pipeline.yaml). 

## tensorflow-mnist-model
`tensorflow-mnist-model` is a sample model that can be used to test this image. It is based off of [fashion-mnist](https://github.com/zalandoresearch/fashion-mnist)

- The `Copy Files into container` step expects `tensorflow-mnist-model` next to `image-tensorflow-model-train`
```
git clone https://github.com/itg-devops/tensorflow-mnist-model.git

├── image-tensorflow-model-train
└── tensorflow-mnist-model

```
## Run a pre-built image of this repo
```
docker run --name tensorflow-mnist -v containers:/var/lib/containers --rm -it quay.io/ibmtechgarage/tensorflow-model-train
```
## Building this image
When building this image it's nice to tag it so it's easy to publish to your quay.io account.

### create quay username variable
Use read to set variable to be used with build, run, and publish steps
```
read quayusername
```

## Building this image
```
docker build -t quay.io/${quayusername}/tensorflow-model-train  .
```
## Run image you built
```
docker run --name tensorflow-mnist -v containers:/var/lib/containers --rm -it quay.io/${quayusername}/tensorflow-model-train
```


## Copy Files into container
In another terminal copy files from `tensorflow-mnist-model` repo into the running `tensorflow-mnist` container
```
docker cp ../tensorflow-mnist-model/environment.yml  tensorflow-mnist:/tmp/
docker cp ../tensorflow-mnist-model/preprocessing.py  tensorflow-mnist:/tmp/
docker cp ../tensorflow-mnist-model/train.py  tensorflow-mnist:/tmp/
docker cp ../tensorflow-mnist-model/constants.py  tensorflow-mnist:/tmp/
docker cp build-script.sh tensorflow-mnist:/tmp/
```
## Exec build-script
```
docker exec tensorflow-mnist sh -c ./build-script.sh
```
## Push up the image
```
docker push quay.io/${quayusername}/tensorflow-model-train
```