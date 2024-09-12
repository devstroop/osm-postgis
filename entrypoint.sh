#!/bin/bash

# Wait for PostGIS to be ready
until pg_isready -h "${PGHOST:-postgis}" -U "${PG_USER:-postgres}"; do
  echo "Waiting for PostGIS to be ready..."
  sleep 2
done

# Run any initialization scripts here, like creating tables or importing data
echo "PostGIS is ready. Running OSM tools..."

# Create Database and Enable PostGIS Extensions if they don't exist
echo "Creating database and enabling extensions..."
psql -h "${PGHOST:-postgis}" -U "${PG_USER:-postgres}" -d postgres -c "SELECT 'CREATE DATABASE ${PG_DB:-osmgis}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${PG_DB:-osmgis}')\gexec"

psql -h "${PGHOST:-postgis}" -U "${PG_USER:-postgres}" -d "${PG_DB:-osmgis}" -c "CREATE EXTENSION IF NOT EXISTS postgis; CREATE EXTENSION IF NOT EXISTS hstore;"

# Import OSM data using osm2pgsql
echo "Importing OSM data..."
osm2pgsql --create --database "${PG_DB:-osmgis}" /data/planet-latest.osm.pbf

# Start the server or any other services
echo "Starting server..."
exec "$@"
