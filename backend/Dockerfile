# To run this image execute the following commands:
# docker build --tag aptitude-backend:latest .
# docker run --detach --publish 3000:3000 aptitude-backend:latest

# Set the base image to jadesym/node-ubuntu-docker-base
# https://hub.docker.com/repository/docker/jadesym/node-ubuntu-docker-base
FROM jadesym/node-ubuntu-docker-base:latest

#----------------------------------------------------------------------
# Dependencies Installation
#----------------------------------------------------------------------
# Confirm Node Installation
RUN node -v
RUN npm -v

# Adding non-interactive for debian front-end to hide dialog questions during build.
# Args only live during the build so they do not persist to the final image.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -qq -y \
        less \
    && apt-get -qq -y autoclean

#----------------------------------------------------------------------
# User & Directory Setup
#----------------------------------------------------------------------
ARG USER_NAME=node
ARG DATA_DIR=/data
ARG APP_DIR=$DATA_DIR/app

RUN useradd -ms /bin/bash $USER_NAME

RUN mkdir $DATA_DIR
RUN chown -R $USER_NAME:$USER_NAME $DATA_DIR

USER $USER_NAME

RUN mkdir $APP_DIR

WORKDIR $APP_DIR

#----------------------------------------------------------------------
# Loading & Running the Repository Code
#----------------------------------------------------------------------
# 1. Loading the Application Code
# Copy dependencies definition files [package(-lock).json] as source of truth for dependencies
COPY package-lock.json $APP_DIR
COPY package.json $APP_DIR
# Copy NPM RC file for npm configurations
COPY .npmrc $APP_DIR
# Copy source code
COPY src $APP_DIR/src
# Copy typescript configuration
COPY tsconfig.json $APP_DIR

# 2. Install dependencies from package lock (clean install)
RUN npm ci

# 3. Build distribution directory
RUN npm run build

# 4. Start the server
CMD ["npm", "run", "start"]
