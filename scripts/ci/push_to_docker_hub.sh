#!/bin/bash

echo "🗄️ Moving all downloaded artifacts to ./build directory…"
find ./build -iname '*.tar' -exec mv '{}' ./build/ \;

for artifact_path in "./build"/*.tar; do
  echo "🚢 Loading Docker image from artifact: ${artifact_path}…"
  docker load -i "${artifact_path}"

  docker_image_name=$(echo "${artifact_path}" | sed "s/^\.\/build\///" | sed "s/\.tar$//")

  echo "🚀 Pushing image to Docker Hub: ${docker_image_name}…"
  docker push "${DOCKERHUB_REPOSITORY}:clamav-desktop-ci:${docker_image_name}"
done
