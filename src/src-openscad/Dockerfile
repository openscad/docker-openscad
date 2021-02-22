#
# Build: docker build -t src-openscad .
# Use: docker run --rm -it -v src-openscad
#
FROM alpine:3.12 AS build

ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG TAG

WORKDIR /openscad

RUN apk --update add git tar gzip && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

# Invalidate docker cache if the branch changes
ADD https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/git/refs/tags/${TAG} tag.json

RUN \
	cat tag.json && rm -f tag.json && \
	git clone --recursive --depth 10 --branch "${TAG}" "https://github.com/${GITHUB_USER}/${GITHUB_REPO}" "${TAG}" && \
	cd "${TAG}" && \
	git rev-parse --abbrev-ref HEAD && \
	git log -n8 --pretty=tformat:"%h %ai (%aN) %s"

RUN \
	mkdir -p out && \
	tar -c -v \
		-I 'gzip -9' \
		--exclude '.git' \
		--exclude '.github' \
		--exclude .gitmodules \
		--exclude \*.yml \
		--exclude .travis.yml \
		--exclude .circleci \
		--exclude snap \
		-f out/"${TAG}".src.tar.gz "${TAG}"

FROM alpine:3.12
WORKDIR /openscad/out
COPY --from=build /openscad/out .

ENTRYPOINT tar --create -C /openscad/out .
