# Docker Commands
# 1) Build the docker image
docker build . --tag aptitude-backend:latest
# 2) Run the docker image
docker run aptitude-backend:latest --detach --publish 3000:3000
