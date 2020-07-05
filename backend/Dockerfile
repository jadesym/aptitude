# To run this image execute the following commands:
# docker build --tag aptitude-backend:latest .
# docker run --detach --publish 3000:3000 aptitude-backend:latest

# Set the base image to ubuntu
# https://hub.docker.com/_/ubuntu
FROM ubuntu:18.04

#----------------------------------------------------------------------
# Dependencies Installation
#----------------------------------------------------------------------
# Adding non-interactive for debian front-end to hide dialog questions during build.
# Args only live during the build so they do not persist to the final image.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
    && apt-get install -qq -y \
        apt-utils \
        curl \
        gpg \
        vim \
    && apt-get -qq -y autoclean

#----------------------------------------------------------------------
# Init Daemon Setup
#----------------------------------------------------------------------

# Download the s6-overlay dependency and move it to the root directory
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/

# Verify signature
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz.sig /tmp/
RUN curl https://keybase.io/justcontainers/key.asc | gpg --import
RUN gpg --verify /tmp/s6-overlay-amd64.tar.gz.sig /tmp/s6-overlay-amd64.tar.gz

# Unzip to root directory
RUN gunzip -c /tmp/s6-overlay-amd64.tar.gz | tar -xf - -C /
RUN ls -alsh /

#----------------------------------------------------------------------
# Node & NPM Setup
#----------------------------------------------------------------------

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.18.0
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ARG USER_NAME=node
ARG HOME_DIR=/home/$USER_NAME
ARG APP_DIR=/app

RUN mkdir $NVM_DIR

# install nvm
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

# confirm installation
RUN node -v
RUN npm -v

# Create the non-root user
RUN useradd -ms /bin/bash $USER_NAME

RUN mkdir $APP_DIR
WORKDIR $APP_DIR

#----------------------------------------------------------------------
# Loading the Repository Code Code
#----------------------------------------------------------------------

# 1. Loading the init daemon setup code
COPY s6-overlay/app-data-dir-permissions /etc/fix-attrs.d/app-data-dir-permissions
COPY s6-overlay/app-service-script /etc/services.d/app/run

# 2. Loading the Application Code
# Copy dependencies definition files [package(-lock).json] as source of truth for dependencies
COPY package-lock.json $APP_DIR
COPY package.json $APP_DIR
# Copy NPM RC file for npm configurations
COPY .npmrc $APP_DIR

# Install dependencies from package lock (clean install)
RUN npm ci

# Copy source code
COPY src $APP_DIR/src
# Copy typescript configuration
COPY tsconfig.json $APP_DIR

# Build distribution directory
RUN npm run build

# Start the server
ENTRYPOINT ["/init"]
