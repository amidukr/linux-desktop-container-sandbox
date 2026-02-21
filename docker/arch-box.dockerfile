FROM docker.io/archlinux
ARG CONTAINER_USER

RUN sed -i '/NoExtract/ s/./#&/' /etc/pacman.conf
RUN sed -i '/NoProgressBar/a ILoveCandy' /etc/pacman.conf
RUN sed -i '/NoProgressBar/ s/./#&/' /etc/pacman.conf

# RUN pacman -Sy --noconfirm
# RUN pacman -Syu --noconfirm base-devel fakeroot git

# Create a non-root user for building

RUN pacman -Syu --noconfirm
RUN pacman -Sy --noconfirm sudo

RUN echo User = $CONTAINER_USER
RUN useradd -u 1000 $CONTAINER_USER && echo "$CONTAINER_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# 

RUN dbus-uuidgen --ensure

USER $CONTAINER_USER

