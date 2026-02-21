#!/bin/bash

if [[ -z "$CONTAINERS_FOLDER" ]]; then
    echo "Must provide CONTAINERS_FOLDER in environment" 1>&2
    exit 1
fi

if [[ -z "$CONTAINER_IMAGE" ]]; then
    echo "Must provide CONTAINER_IMAGE in environment" 1>&2
    exit 1
fi

CONTAINER_ROOT_FS=$CONTAINERS_FOLDER/rootfs/$CONTAINER_IMAGE
echo Setting up container root folder: $CONTAINER_ROOT_FS

podman create --cgroup-manager=cgroupfs --name $CONTAINER_IMAGE \
	--replace \
	--read-only \
	$CONTAINER_IMAGE \
	ls -l /

podman cp --cgroup-manager=cgroupfs $CONTAINER_IMAGE:/ $CONTAINER_ROOT_FS

REMOVE_FOLDER_LIST=("tmp" "dev" "proc" "run") 

chmod u+rwx $CONTAINER_ROOT_FS

for REMOVE_FOLDER in "${REMOVE_FOLDER_LIST[@]}"; do
  [ ! -d $CONTAINER_ROOT_FS/$REMOVE_FOLDER ] && continue
  echo Removing folder: $CONTAINER_ROOT_FS/$REMOVE_FOLDER
  chmod -R u+rwx $CONTAINER_ROOT_FS/$REMOVE_FOLDER
  rm -rf $CONTAINER_ROOT_FS/$REMOVE_FOLDER
done

