#!/usr/bin/env sh
# 
# This is a little hack for Mac users to provide the tcp-based remote API from the local running docker service
#
# The hack based on the known-issues database from the docker project:
# https://docs.docker.com/docker-for-mac/troubleshoot/#/known-issues
#
# Company: Datadrivers GmbH
# Author: Markus Rekkenbeil
#
# Version: 0.1
#

DOCKER_HOST="127.0.0.1"
LISTEN_PORT="1234"
path_to_executable=$(which docker)

if [ ! -n "$path_to_executable" ] ; then
  echo "DOCKER NOT FOUND (!)"
  echo "Please install the docker toolset!"
  echo "https://www.docker.com/"
  echo "If the docker toolset is installed,"
  echo "please provide it in your PATH settings (shell environment)."
  exit 1;
fi

echo "Starting docker remote-api container..."
echo "Remote API is listening on HOST: $DOCKER_HOST PORT: $LISTEN_PORT"
echo "Running docker command:" 
echo "docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p ${DOCKER_HOST}:${LISTEN_PORT}:${LISTEN_PORT} bobrik/socat TCP-LISTEN:${LISTEN_PORT},fork UNIX-CONNECT:/var/run/docker.sock"

docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p ${DOCKER_HOST}:${LISTEN_PORT}:${LISTEN_PORT} bobrik/socat TCP-LISTEN:${LISTEN_PORT},fork UNIX-CONNECT:/var/run/docker.sock
# short break
sleep 3;
echo "Docker remote API is running. Enjoy your terraform demo with Docker!"

exit 0;
