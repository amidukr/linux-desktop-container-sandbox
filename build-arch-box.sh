#!/bin/bash

if [[ -z "$CONTAINERS_FOLDER" ]]; then
    echo "Must provide CONTAINERS_FOLDER in environment" 1>&2
    exit 1
fi

if [[ -z "$CONTAINER_IMAGE" ]]; then
    echo "Must provide CONTAINER_IMAGE in environment" 1>&2
    exit 1
fi

echo User = $CONTAINER_USER
podman build --no-cache --cgroup-manager=cgroupfs --build-arg CONTAINER_USER -f $CONTAINERS_FOLDER/scripts/docker/$CONTAINER_IMAGE.dockerfile -t $CONTAINER_IMAGE
