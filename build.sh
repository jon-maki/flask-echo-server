#!/usr/bin/env bash
set -e

# Build the image using the local docker daemon
docker build -t "$IMAGE" .

# Calculate the image tag that skaffold will use as the image tag in
# the skaffold-updated kubernetes pod YAML.
calculated_image_tag=$(docker images "$IMAGE" --no-trunc --format "{{.Repository}}:{{.ID}}" | sed 's/sha256://g')

# Tag the image appropriately so we can import it to our k3d-created cluster
docker tag "$IMAGE" "$calculated_image_tag"

# Import the image into our k3d cluster so skaffold can deploy it
k3d import-images "$calculated_image_tag"
