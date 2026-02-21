#!/bin/bash

podman run -it \
	--cgroup-manager=cgroupfs \
	--user 0:0 \
        --userns=host \
	--workdir /root \
	--network=pasta \
	--cap-drop=CAP_NET_RAW \
	--env XDG_RUNTIME_DIR=/run/user/1000 \
	--env WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
	--mount type=bind,source="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY",destination="'run/user/1000/$WAYLAND_DISPLAY,U",readonly \
	--tmpfs /root \
	--tmpfs /run:U \
	--rootfs $CONTAINERS_FOLDER/rootfs/$CONTAINER_IMAGE \
	bash

