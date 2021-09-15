
# Setup tekton pipeline for this repo
## prerequisite

### Github
- github account
``` 
githubaccount=YourAccount
```
- fork [image-kubeflow-model-build](https://github.com/itg-devops/image-kubeflow-model-build.git)
- configure a token that has `admin:repo_hook, repo` 
    - [Generate a GitHub personal access token](https://www.ibm.com/docs/en/cloud-paks/cp-applications/4.2?topic=accelerators-building-deploying-applications)

### Tekton
Install [cli](https://github.com/tektoncd/cli)
```
tkn version  
Client version: 0.20.0
Pipeline version: v0.22.0
Triggers version: v0.12.1
```


### OpenShift Cluster
Install [cli](https://docs.openshift.com/container-platform/4.2/cli_reference/openshift_cli/getting-started-cli.html#cli-installing-cli_cli-developer-commands)
this is known to work on version: 4.7.23

```
oc version
Client Version: 4.7.13
Server Version: 4.7.23
Kubernetes Version: v1.20.0+558d959
```

### Cloud-Native Toolkit
Install [Cloud-Native Toolkit](https://cloudnativetoolkit.dev)
```
curl -sfL get.cloudnativetoolkit.dev | sh -
```

### Repos
```
git clone https://github.com/${githubaccount}/image-kubeflow-model-build.git
git clone https://github.com/${githubaccount}/ibm-garage-tekton-tasks.git
```

## Apply the pipeline and tasks to tools project
```
oc status
oc project tools
cd ibm-garage-tekton-tasks
oc apply -f tasks/2-build-tensorflow-model-push.yaml
oc apply -f pipelines/tensorflow-edge-pipeline.yaml
```

## Sync and pipeline a `model-build` 
```
cd ../image-kubeflow-model-build
git status
oc sync model-build --dev
oc adm policy add-scc-to-user privileged  -z pipeline 
echo $ghp | pbcopy
oc pipeline --tekton --pipeline tensorflow-edge --param scan-image=false lint-dockerfile=false  health-endpoint=/ https://github.com/${githubaccount}/image-kubeflow-model-build.git
tkn pr logs -f <pipelinerun>
curl <artfactory url> -O
tar -tvf mnist.tar.gz
```

