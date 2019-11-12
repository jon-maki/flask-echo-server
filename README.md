# flask-echo-server
Simple flask application that echoes back all received headers and any valid JSON
request body received in in GET and POST requests to /. Responses are encoded
in JSON.

This is a tiny project built to use as a representative example Flask application
to deploy to a local kubernetes cluster using the `skaffold` project. Running this 
application in developer mode via `skaffold` assumes that the user has a local
kubernetes cluster that is managed by `k3d` up and running. See the `rancher/k3d` 
documentation for help on getting started with `k3d`: https://github.com/rancher/k3d.
Once the cluster is up and running, the appropriate `KUBECONFIG` environment variable
will need to be set in the shell that `skaffold dev --port-forward` is run from so 
that `skaffold` will understand how to deploy the pod.

Once you have `k3d` installed locally, you can create a local cluster very simply by
running:

`k3d create --image rancher/k3s:v0.10.2`

To interact with the local cluster, you'll need to install `kubectl`. See the 
official kubernetes documentation for help on installing `kubectl`:
https://kubernetes.io/docs/tasks/tools/install-kubectl/.

Additionally, this project assumes that the user has `skaffold` installed on their
local machine. See the `GoogleContainerTools/skaffold` documentation for help on 
getting started with `skaffold`: https://github.com/GoogleContainerTools/skaffold.

To get up and running in continuous development mode for this application, all you 
should need to do is install `skaffold` locally, create a local cluster with `k3d` 
and run:

`skaffold dev --port-forward`

from the main project directory. This will build the image using the local docker
daemon, import it into your `k3d`-managed cluster and deploy the correct pod.

The interesting piece here that this project implements is a custom build stage
for `skaffold` that builds the docker image using the local docker daemon and 
then imports it into the `k3d`-managed cluster using `k3d import-images`. This 
allows us to avoid using any docker image registries and facillitates 
developing in an "offline" environment (a.k.a. not internet-connected), 
provided that we have local mirrors of the required package repositories 
(`alpine:3.10` and `PyPi`). 

Additionally, this project sets up manual syncing of the application files into the
running kubernetes pod, which allows the developer to make code changes on their 
local machine and have them immediately synced to the running pod, skipping the 
image building step. Effectively, this project will hot-reload the Flask application
when run in `FLASK_DEBUG` mode.

For now, we just deploy a single pod with this application. It is easy to see how 
this could be extended into a full kubernetes deployment, if desired. To extend that,
simply create and add valid kubernetes manifests into the `manifests/` directory. 
`skaffold` will take care of the actual deployment using the local `kubectl` binary.

This is not intended to be actually useful as anything other than a simple example of
using a `skaffold` continuous development pipeline with a local `k3d`-managed 
kubernetes cluster.

### Building
To build using the local docker daemon:

`docker build -t $IMAGE:$TAG .`

To build and import into the `k3d`-managed cluster via `skaffold`:

`skaffold build`

### Running
To run the image locally:

`docker run --rm -p 5000:5000 $IMAGE:$TAG`

To build and run the pod in the local kubernetes cluster via `skaffold`:

`skaffold run`

To kick off the continuous development pipeline defined in `skaffold.yaml`:

`skaffold dev`

To automatically set up port-forwarding to the pod that is deployed in the local 
kubernetes cluster while in continuous development mode:

`skaffold dev --port-forward`

### Simple Tests
The following curl commands can be used to test that the server returns the expected
response. These will work out of the box if port-forwarding to the deployed pod is 
set up.

#### GET
`curl http://127.0.0.1:5000/`

#### POST
`curl -X POST http://127.0.0.1:5000 -d '{"asdf": "qwer"}' -H "Content-Type: application/json"`

### Cleaning up
Skaffold will automatically clean up on `CTRL+c` by deleting the pod. This will leave 
the docker image artifacts that were created during the build. You can optionally 
instruct `skaffold` to remove these artifacts on `CTRL+c` using:

`skaffold dev --port-forward --no-prune=false --cache-artifacts=false`

In an offline environment, I don't like to do this because keeping the image caches around
is very useful as it dramatically speeds up build times. Additionally, I can build once
while connected to the developer network that mirrors the package repositories for the 
stuff I need, and then disconnect from that network for all subsequent builds and rely 
on my local docker image cache. This strategy obviously breaks down if I determine I need
to add an additional dependency to my Dockerfile.

