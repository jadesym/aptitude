# Docker Commands

# 1) Build the docker image

docker build . --tag aptitude-backend:latest

# 2) Run the docker image

docker run aptitude-backend:latest --detach --publish 3000:3000

# OR Run with Docker Compose

# 1) Build the services with Docker Compose

docker-compose build

# 1B) Build w/ no cache

docker-compose build --no-cache

# 2A) Run all services in the docker-compose configuration

docker-compose up --detach

# 2B) Run a specific service

docker-compose run --detach --service-ports aptitude-backend

# 3) Shutdown services when finished

docker-compose down

# s6-overlay init daemon docs

[s6-overlay documentation](https://github.com/just-containers/s6-overlay)
