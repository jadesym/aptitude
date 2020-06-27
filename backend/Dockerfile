# To run this image execute the following commands:
# docker build --tag aptitude-backend:latest .
# docker run --detach --publish 3000:3000 aptitude-backend:latest

# Set the base image to ubuntu
# https://hub.docker.com/_/ubuntu
FROM ubuntu:18.04

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Adding non-interactive for debian front-end to hide dialog questions during build.
# Args only live during the build so they do not persist to the final image.
ARG DEBIAN_FRONTEND=noninteractive

# Update the repository sources list
# and install dependencies
RUN apt-get -qq update \
    && apt-get install -qq -y \
        apt-utils \
        curl \
        vim \
    && apt-get -qq -y autoclean

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
ENTRYPOINT ["npm", "run", "start"]
