# Overview

This project provides scripting for **imageless, mutable, persistent, and lightweight** Linux desktop runtimes inside a Podman container. It’s perfect for testing apps, experimenting with Linux commands, or running GUI applications **without affecting your main system**.

You might ask: *“I can already run Podman containers — why so much scripting, and what’s special here?”*

The key difference is that **this container is persistent, mutable, and imageless**, whereas typical Podman containers are **volatile**, and images are **immutable once built**.

Typical Podman/Docker workflows target server environments: you build an immutable image and deploy it across multiple nodes in a cluster.

Here, we’re using Podman differently — inspired by **Bubblewrap** and **Flatpak** — to create an isolated environment for desktop applications. By leveraging Podman’s advanced features (like user namespaces and runtime isolation), this sandbox allows you to isolate applications from your host system while retaining flexibility and persistence.

# Objective

If you’re familiar with **Bubblewrap** or **Flatpak**, you already understand the problem being addressed:

1. **Enhanced desktop security** — Run applications you trust less inside a container, restricting access to your host filesystem, kernel resources, or other apps.
1. **Dependency isolation** — Run software with incompatible dependencies or conflicting runtime configurations without breaking your main system.
1. **Persistent configuration** — Unlike standard Podman containers, changes to the runtime persist across system restarts.
1. **Flexible runtime management** — Unlike Flatpak, you can pull Docker/Podman images, use your package manager, and configure the environment as needed. Flatpak apps are sandboxed but **don’t provide direct access to a package manager**, and typical Docker images don’t offer desktop-ready GUI integration. This sandbox combines **full package manager access with GUI-ready, persistent, isolated desktop runtimes**.

# Why Not Flatpak or Bubblewrap

- **Bubblewrap**: Podman `--rootfs` mode works in a way similar to Bubblewrap, providing filesystem-level isolation. However, Bubblewrap configurations can be more complex and easier to misconfigure, which may accidentally compromise isolation. Podman offers **additional advanced features**, such as configurable networking and user namespace mapping, making it **more robust and secure for desktop sandboxing**.
- **Flatpak**: Provides sandboxing for desktop apps but is limited in flexibility. Flatpak apps **cannot use the system’s package manager** directly, making it harder to manage dependencies or configure complex runtime environments. This sandbox gives you **both GUI-ready isolation and full package manager control**.

## Why Not Standard Podman

- Standard Podman containers are designed for ephemeral workloads: once the container stops, changes are lost unless committed to a new image.
- Podman images are immutable by design, making iterative experimentation with GUI desktop apps cumbersome.
- The sandbox run in Podman `--rootfs mode`, which is fully imageless and unlike typical rootless containers using fuse-overlayfs, this mode avoids user-space overlay layers entirely, resulting in superior performance, especially for GUI applications and desktop workflows.
- While Podman `--rootfs` provides Bubblewrap-like isolation, this project combines it with **persistent, mutable, desktop-friendly** scripting that also leverages **Podman’s advanced networking and user-mapping features**. The result is **secure, flexible, GUI-ready, persistent sandboxing** that standard containers alone don’t provide.

# Quick Start


## 1. Set global variabes:
```bash
export CONTAINERS_FOLDER=~/Containers
export CONTAINER_IMAGE=arch-box
export CONTAINER_USER=demo
```

## 2. Install Container and initialize Containers script
``` bash
mkdir $CONTAINERS_FOLDER
git clone https://github.com/amidukr/linux-desktop-container-sandbox.git \
        $CONTAINERS_FOLDER/scripts

$CONTAINERS_FOLDER/scripts/init.sh
```

## 3. Build arch-box container:
```bash

$CONTAINERS_FOLDER/scripts/build-arch-box.sh
$CONTAINERS_FOLDER/scripts/extract-arch-box.sh
```

## 4. Let's check permissions for just a user
```bash

# Shell into container user regular user

$CONTAINERS_FOLDER/scripts/run-arch-box-user.sh

# Let's try to write file to home directory
echo Hello World> ~/file.txt
# Should succeed

#Let's try to do the same with root directory
echo Hello World> /file.txt
# Will fail because root fs mounted as readonly, expected behaviour

# If just run kentwalk, it should fail since package not installed yet
knetwalk

# Let's try to run pacman package manage
pacman -Sy knetwalk
# Should fail by complaining that operation needs to be run from sudo

# Let's try sudo
sudo pacman -Sy knetwalk
# Sudo should execute command under container root, however system would complain about different permissions issue

exit
```

## 5. Same check by for admin user:
```bash
$CONTAINERS_FOLDER/scripts/run-arch-box-admin.sh


echo Hello World> ~/file.txt
echo Hello World> /file.txt
knetwalk
pacman -Sy knetwalk

# All this command above should work or fail similarly as for simple user

exit
```


## 6. Installing knetwalk from admin user:
```
$CONTAINERS_FOLDER/scripts/run-arch-box-admin.sh

sudo pacman -Sy knetwalk
sudo pacman -Sy noto-fonts

# And running should work now
export $(dbus-launch)
knetwalk 

exit
```

## 7. And running knetwalk from unprivileged user
```
$CONTAINERS_FOLDER/scripts/run-arch-box-user.sh

# Just same again
export $(dbus-launch)
knetwalk 

exit

```

## 8. And finally let's check how much space totally was used:

```bash
du -h -d 1 $CONTAINERS_FOLDER 2>/dev/null
```
