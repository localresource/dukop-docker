#!/bin/bash

SCRIPT_DIR=$( realpath $( dirname $0 ) )
BUILD_DIR=$SCRIPT_DIR/build

source $BUILD_DIR/common.env
WEB_INSTANCE_NAME="my-$WEB_IMAGE_NAME"
DB_INSTANCE_NAME="my-$DB_IMAGE_NAME"
DB_TEST_INSTANCE_NAME="my-$DB_TEST_IMAGE_NAME"

sudo docker inspect $DB_INSTANCE_NAME >/dev/null
if [[ $? -eq 0 ]]; then
	sudo docker start $DB_INSTANCE_NAME
else
	sudo docker run --network $DOCKER_NETWORK --name $DB_INSTANCE_NAME -e POSTGRES_DB=$DATABASE_NAME -e POSTGRES_USER=$DATABASE_USER -e POSTGRES_PASSWORD=$DATABASE_PASS -d $DB_IMAGE_NAME
fi

sudo docker inspect $DB_TEST_INSTANCE_NAME >/dev/null
if [[ $? -eq 0 ]]; then
	sudo docker start $DB_TEST_INSTANCE_NAME
else
	sudo docker run --network $DOCKER_NETWORK --name $DB_TEST_INSTANCE_NAME -e POSTGRES_DB=$DATABASE_NAME -e POSTGRES_USER=$DATABASE_USER -e POSTGRES_PASSWORD=$DATABASE_PASS -d $DB_TEST_IMAGE_NAME
fi

sudo docker inspect $WEB_INSTANCE_NAME >/dev/null
if [[ $? -eq 0 ]]; then
	sudo docker start $WEB_INSTANCE_NAME
else
	sudo docker run --tty --network $DOCKER_NETWORK -v "$SCRIPT_DIR/dukop:/myapp" --name $WEB_INSTANCE_NAME -e RAILS_ENV=development -d $WEB_IMAGE_NAME
fi

ADDR=$( sudo docker inspect -f '{{range .NetworkSettings.Networks}} http://{{.IPAddress}}:9292{{end}}' $WEB_INSTANCE_NAME )

echo "********************************************************************************"
echo
echo "dukop should now be running at$ADDR"
echo
echo "********************************************************************************"
