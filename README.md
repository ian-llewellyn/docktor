# Docktor

Docktor is a container that can be spun up within a Kubernetes Pod or on a system running Docker engine to provide extra insight into the structure / workings of a running container.

The ambitions of docktor are to:
* Be easy to get started with
* Be lightweight
* Provide common tools by default
* Enable extensibility (contributors via `git branch` and users via Dockerfile `FROM`)

## Getting started examples
In all of the examples below, the Docktor container uses the process namespace of the container being debugged. You can also walk onto that container's root filesystem using `cd /proc/1/root/`.

### Docker
Using the `--pid` argument to `docker run`, you can run your new container in the same process namespace as the already running one.
```bash
docker run -it --pid=container:<my-container> iancli/docktor
```

### Kubernetes (reload Pod with shareProcessSpace)
Without EphemeralContainers enabled (see below), bringing a set of debug tools into an already running Pod is challenging. The process outlined here requires you to recreate your Pod with some extra configuration to attach Docktor:

```bash
kubectl get pod <pod-name> -o yaml > my-pod.yaml
```

Add the following to the PodSpec (spec section):
```yaml
  shareProcessSpace: true
```

And create a new ContainerSpec (element under containers):
```yaml
  - image: iancli/docktor
    name: docktor
```

### Kubernetes with EphemeralContainers
If you have the `EphemeralContainers` feature gate enabled in your Kubernetes cluster, the following will spin up Docktor:
```bash
kubectl debug -it <pod-name> --image=iancli/docktor --target=pod-name
```

### Minikube default (without EphemeralContainers)
Since we have easy access to our minikube Kubernetes node, we can launch Docktor outside of the k8s infrastructure:
```bash
minikube kubectl -- describe pod <pod-name> | grep "Container ID"
minikube ssh -- docker run -it --pid=container:<my-container-id> iancli/docktor
```
