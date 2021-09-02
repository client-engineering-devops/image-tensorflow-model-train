# Kubeflow Model Build Image 

Container image is used in the tekton pipeline to build a [Kubeflow](https://www.kubeflow.org/) model.

## Software Installed:
*   build-essentials
*   python
*   [Anaconda](https://www.anaconda.com/)
*   [Tensor Flow](https://www.tensorflow.org/)
*   [Kubeflow](https://www.kubeflow.org)

## Build Usage

```
docker exec kf-builder bash -c "./build-script.sh"
```