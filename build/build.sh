#!/bin/bash
BUILD_DIR=$( dirname $0 )
SCRIPT_DIR=""

source $BUILD_DIR/common.env

if [[ -f $BUILD_DIR/../run.sh ]]; then
	SCRIPT_DIR=$( realpath $BUILD_DIR/.. )
else
	echo "ERROR: Unable to locate run.sh."
	exit 2
fi

sudo docker inspect $DOCKER_NETWORK >/dev/null
if [[ $? -eq 1 ]]; then
	sudo docker network create $DOCKER_NETWORK
fi

sudo docker inspect $DB_IMAGE_NAME >/dev/null
if [[ $? -eq 1 ]]; then
	sudo docker build -t $DB_IMAGE_NAME $BUILD_DIR/db
fi

sudo docker inspect $DB_TEST_IMAGE_NAME >/dev/null
if [[ $? -eq 1 ]]; then
	sudo docker build -t $DB_TEST_IMAGE_NAME $BUILD_DIR/db-test
fi

if [[ ! -d $SCRIPT_DIR/dukop ]]; then
	git clone --branch ruby2.5-dev 'https://github.com/localresource/duk_op.git' $SCRIPT_DIR/dukop || exit 1
fi

if [[ ! -f $SCRIPT_DIR/dukop/Gemfile ]]; then
	echo "ERROR: Unable to find Gemfile."
	exit 2
else
	cp $SCRIPT_DIR/dukop/Gemfile $BUILD_DIR/web/conf/Gemfile
fi

if [[ ! -f $SCRIPT_DIR/dukop/Gemfile.lock ]]; then
	echo "ERROR: Unable to find Gemfile.lock."
	exit 2
else
	cp $SCRIPT_DIR/dukop/Gemfile.lock $BUILD_DIR/web/conf/Gemfile.lock
fi

sudo docker inspect $WEB_IMAGE_NAME >/dev/null
if [[ $? -eq 1 ]]; then
	sudo docker build -t $WEB_IMAGE_NAME $BUILD_DIR/web
fi
