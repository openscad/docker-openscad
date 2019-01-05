#
# Build: docker build -t appimage-base .
# Use: docker run --rm -it -v appimage-base
#
FROM buildpack-deps:stretch

RUN apt-get update

RUN apt-get install -y --no-install-recommends binfmt-support qemu qemu-user-static debootstrap apt-src apt-transport-https devscripts git

RUN update-binfmts --display

RUN wget http://archive.raspbian.org/raspbian.public.key -O - | sudo apt-key add -q

WORKDIR /raspi

RUN qemu-debootstrap --keyring=/etc/apt/trusted.gpg --arch armhf stretch /raspi http://mirrordirector.raspbian.org/raspbian/

RUN cp /usr/bin/qemu-arm-static /raspi/usr/bin/

RUN chroot /data/raspberry-pi/root uname -a
