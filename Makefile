JENKINS_APP_NAME='myjenkins-app'
JENKINS_DATA_NAME='myjenkins-data'

all: build

build:
	@docker build --tag=mizunashi/jenkins .

quickstart:
	@echo "Starting jenkins container..."
	@docker run --name=${JENKINS_APP_NAME} -d \
		--publish=8080:8080 \
		--publish=50000:50000 \
		mizunashi/jenkins
	@docker run --name=${JENKINS_DATA_NAME} -d \
		--volumes-from=${JENKINS_APP_NAME} \
		busybox:latest
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping jenkins app..."
	@docker stop ${JENKINS_APP_NAME} >/dev/null
	@echo "Stopping jenkins data..."
	@docker stop ${JENKINS_DATA_NAME} >/dev/null

purge: stop
	@echo "Removing stopped containers..."
	@docker rm -v ${JENKINS_APP_NAME} >/dev/null
	@docker rm -v ${JENKINS_DATA_NAME} >/dev/null

logs:
	@docker logs -f ${JENKINS_APP_NAME}

