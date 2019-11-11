# flask-echo-server
Simple flask application that echoes back all received headers and any valid JSON
request body received in in GET and POST requests to /. Responses are encoded
in JSON.

This is a tiny project built to use as a representative example Flask application
to deploy to a local kubernetes cluster using the `skaffold` project. A "development"
repo will submodule this repository (and many others) and implement the 
skaffold-specific setup to get the full environment up and running in the local cluster
in development mode, with hot reloading applications.

This is not intended to be actually useful.

### Building
`docker build -t $IMAGE:$TAG .`

### Running
`docker run --rm -p 5000:5000 $IMAGE:$TAG`

### Simple Tests
The following curl commands can be used to test that the server returns the expected
response.

#### GET
`curl http://127.0.0.1:5000/`

#### POST
`curl -X POST http://127.0.0.1:5000 -d '{"asdf": "qwer"}' -H "Content-Type: application/json"`
