FROM archlinux:base-devel

COPY mirrorlist /etc/pacman.d/mirrorlist
RUN pacman -Sy
