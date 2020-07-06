# Docker Commands
# 1) Build the docker image
docker build . --tag aptitude-backend:latest
# 2) Run the docker image
docker run aptitude-backend:latest --detach --publish 3000:3000

# OR Run with Docker Compose
# 1A) Run all services in the docker-compose configuration
docker-compose up --detach
# 1B) Run a specific service
docker-compose up aptitude-backend 
# 2) Shutdown services when finished
docker-compose stop

# s6-overlay init daemon docs
[s6-overlay documentation](https://github.com/just-containers/s6-overlay)
