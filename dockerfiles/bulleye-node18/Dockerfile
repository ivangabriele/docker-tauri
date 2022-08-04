# Run `make build-11-18` to build this image

FROM rust:bullseye

# Node.js
RUN apt-get update -qq
RUN apt-get install -qq -y curl
RUN curl -fsSL "https://deb.nodesource.com/setup_18.x" | bash -
RUN apt-get install -y nodejs
RUN npm i -g yarn
