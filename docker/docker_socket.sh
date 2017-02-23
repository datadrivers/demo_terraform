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
# Version: 0.2
#

# variables
DOCKER_HOST="127.0.0.1"
LISTEN_PORT="1234"
DOCKER_IMAGE="bobrik/socat"
DOCKER_CMD_PROCESS="docker run -d -v /var/run/docker.sock:/var/run/docker.sock -p ${DOCKER_HOST}:${LISTEN_PORT}:${LISTEN_PORT} ${DOCKER_IMAGE} TCP-LISTEN:${LISTEN_PORT},fork UNIX-CONNECT:/var/run/docker.sock"
DOCKER_CMD_ID_PROCESS=`docker ps --filter ancestor=${DOCKER_IMAGE} --format '{{.ID}}'`

# check command for an existing docker toolset
command -v docker >/dev/null 2>&1 || { printf "DOCKER NOT FOUND (!)\nPlease install the docker toolset!\nhttps://www.docker.com/\nIf the docker toolset is installed,\nplease provide it in your PATH settings (shell environment).\n" <&2; exit 1; }

# function to get docker process id
docker_image_process_status() {
	RUNNINGCMD=$(docker inspect --format="{{ .State.Running }}" ${DOCKER_CMD_ID_PROCESS} 2> /dev/null)
	if [ "$RUNNINGCMD" == "true" ]; then
		RUNNING_STATE="RUNNING"
	else
		RUNNING_STATE="NOTRUNNING"
	fi
}

case $1 in
	start)
		# start docker process
		docker_image_process_status
		if ! [ `echo $RUNNING_STATE` == "RUNNING" ]; then
			printf "Starting docker remote-api container...\n"
                        printf "Running docker command:\n${DOCKER_CMD_PROCESS}\n"
                        # docker command to start
                        $DOCKER_CMD_PROCESS 2>&1 > /dev/null
		        status=$?
		        if ! [ `echo $status` == 0 ] ; then
			        printf "ERROR (!) - Please check the error message from above.\n"
			        exit 2;
		        fi
		        # short break
                        sleep 2;
		        printf "Remote API is listening on HOST: ${DOCKER_HOST} PORT: ${LISTEN_PORT}\n";
                        printf "Docker remote API is running. Enjoy your terraform demo with Docker!\n"
                        exit $status
		else
			printf "The docker container ${DOCKER_IMAGE} is running.\n"
			exit 2
		fi
		;;
	stop)
		# stop docker process
		docker_image_process_status
		if [ `echo $RUNNING_STATE` == "RUNNING" ]; then
			printf "Stopping docker remote-api container\n"
			docker stop ${DOCKER_CMD_ID_PROCESS} 2>&1 > /dev/null
		        status=$?
			printf "Stopped docker remote-api container ${DOCKER_IMAGE}\n"
		        exit $status
		else
			printf "Nothing is stopped, because Docker container ${DOCKER_IMAGE} isn't running or found by the script.\n"
			exit 2
		fi
		;;
	restart)
		# restart docker process
		$0 stop && sleep 2 && $0 start
		;;
	status)
		# status of the docker process
	        docker_image_process_status
		printf "Docker container is ${RUNNING_STATE}\n"
		exit 0
		;;
	*)
		# display help
		printf "Usage: $0 {start|stop|restart|status}\n"
		exit 2
		;;


esac
