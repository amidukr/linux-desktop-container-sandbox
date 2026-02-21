#!/bin/bash

podman run -it \
	--cgroup-manager=cgroupfs \
	--read-only \
	--user 1000:1000 \
        --userns=keep-id \
	--workdir /home/$CONTAINER_USER \
	--network=pasta \
	--mount type=bind,source=$CONTAINERS_FOLDER/home/$CONTAINER_IMAGE-$CONTAINER_USER,target=/home/$CONTAINER_USER,U \
	--env XDG_RUNTIME_DIR=/run/user/1000 \
	--env WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
	--mount type=bind,source="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY",destination="/run/user/1000/$WAYLAND_DISPLAY,U",readonly \
	--tmpfs /root \
	--tmpfs /run:mode=755 \
	--tmpfs /run/user/1000:U,mode=700 \
	--tmpfs /tmp:mode=777 \
	--rootfs $CONTAINERS_FOLDER/rootfs/$CONTAINER_IMAGE \
	bash

