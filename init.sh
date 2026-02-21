#!/bin/bash

if [[ -z "$CONTAINERS_FOLDER" ]]; then
    echo "Must provide CONTAINERS_FOLDER in environment" 1>&2
    exit 1
fi

if [[ -z "$CONTAINER_IMAGE" ]]; then
    echo "Must provide CONTAINER_IMAGE in environment" 1>&2
    exit 1
fi

if [[ -z "$CONTAINER_USER" ]]; then
    echo "Must provide CONTAINER_USER in environment" 1>&2
    exit 1
fi

mkdir $CONTAINERS_FOLDER/home
mkdir $CONTAINERS_FOLDER/rootfs

mkdir $CONTAINERS_FOLDER/home/$CONTAINER_IMAGE-$CONTAINER_USER
mkdir $CONTAINERS_FOLDER/home/$CONTAINER_IMAGE-$CONTAINER_USER-admin
