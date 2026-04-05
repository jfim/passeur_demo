#!/bin/bash
set -e

echo "Running database setup and migrations..."
bin/passeur_demo eval "PasseurDemo.Release.create_and_migrate()"

echo "Starting application..."
exec bin/passeur_demo start
