#
# Build: docker build -t appimage-base .
# Use: docker run --rm -it -v appimage-base
#
FROM buildpack-deps:stretch

RUN apt-get update

RUN apt-get install -y --no-install-recommends binfmt-support qemu qemu-user-static debootstrap apt-src apt-transport-https devscripts git fakeroot

RUN update-binfmts --display

RUN wget http://archive.raspbian.org/raspbian.public.key -O - | apt-key add -q

WORKDIR /raspi

RUN qemu-debootstrap --variant=fakechroot --keyring=/etc/apt/trusted.gpg --arch armhf stretch /raspi http://mirrordirector.raspbian.org/raspbian/

RUN chroot /data/raspberry-pi/root uname -a
