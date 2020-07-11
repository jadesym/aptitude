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
ARG DATA_DIR=/data/
ARG APP_DIR=$DATA_DIR/app/

RUN mkdir -p $APP_DIR

RUN useradd -ms /bin/bash $USER_NAME
RUN chown -R $USER_NAME:$USER_NAME $DATA_DIR

USER $USER_NAME

WORKDIR $APP_DIR

#----------------------------------------------------------------------
# Loading & Running the Repository Code
#----------------------------------------------------------------------
# 1. Loading the Application Code
COPY \
  # Copy NPM RC file for npm configurations
  .npmrc \
  # Copy dependencies definition files [package(-lock).json] as source of truth for dependencies
  package-lock.json \
  package.json \
  # Typescript configuration
  tsconfig.json \
  # To destination directory
  $APP_DIR

# Copy source code contents. Directories are treated differently.
# Copying with multiple source files will copy the contents of the file
# instead of the directory, which is why this COPY command is separate.
COPY src $APP_DIR/src

# 2. Install dependencies from package lock (clean install)
RUN npm ci

# 3. Build distribution directory
RUN npm run build

# 4. Start the server
CMD ["npm", "run", "start"]
