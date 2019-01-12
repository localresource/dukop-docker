#!/bin/bash

cd /myapp

echo -n "Waiting for Development DB to be ready ..."
DB_READY=0
while [[ $DB_READY == 0 ]]; do
	OUTPUT=$( PGPASSWORD=admin psql --command="SELECT 1" -h my-dukop-db -t -A dukop admin 2>/dev/null )
	if [[ $OUTPUT == "1" ]]; then
		DB_READY=1
		echo " OK!"
	else
		sleep 1
		echo -n "."
	fi
done

echo -n "Waiting for Test DB to be ready ..."
TEST_DB_READY=0
while [[ $TEST_DB_READY == 0 ]]; do
	OUTPUT=$( PGPASSWORD=admin psql --command="SELECT 1" -h my-dukop-db-test -t -A dukop admin 2>/dev/null )
	if [[ $OUTPUT == "1" ]]; then
		TEST_DB_READY=1
		echo " OK!"
	else
		sleep 1
		echo -n "."
	fi
done

RAILS_ENV=development rake db:migrate
RAILS_ENV=test rake db:migrate

NUM_OF_EVENTS=$( PGPASSWORD=admin psql --command="SELECT COUNT(*) FROM events;" -h my-dukop-db -t -A dukop admin 2>/dev/null )
if [[ $NUM_OF_EVENTS == "0" ]]; then
	RAILS_ENV=development rake det_sker:reload
fi

exec puma
