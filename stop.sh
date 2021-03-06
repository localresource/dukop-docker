#!/bin/bash
SCRIPT_DIR=$( realpath $( dirname $0 ) )
BUILD_DIR=$SCRIPT_DIR/build

source $BUILD_DIR/common.env
WEB_INSTANCE_NAME="my-$WEB_IMAGE_NAME"
DB_INSTANCE_NAME="my-$DB_IMAGE_NAME"
DB_TEST_INSTANCE_NAME="my-$DB_TEST_IMAGE_NAME"

sudo docker stop $WEB_INSTANCE_NAME $DB_INSTANCE_NAME $DB_TEST_INSTANCE_NAME
