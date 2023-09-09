FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		software-properties-common \
		apt-transport-https \
		ca-certificates \
		openssh-client \
		lsb-release \
		apt-utils \
		xz-utils \
		nodejs \
		unzip \
		make \
		ncat \
		wget \
		npm \
		zip \
		git

WORKDIR /build
