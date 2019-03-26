#!/bin/bash

set -eu

DB_HOST=${DB_HOST:-"mysql"}
DB_USER=${DB_USER:-"hexaa"}
DB_PASS=${DB_PASS:-"hexaa"}
DB_NAME=${DB_NAME:-"hexaa"}
DB_TMP_NAME=${DB_TMP_NAME:-"hexaa_dump"}
DB_ROOT_PASS=${DB_ROOT_PASS:-"root"}

MYSQL="mysql -h $DB_HOST"

read -p "This script will delete the current content of the target HEXAA db. Are you sure? [y/N] " -r
if [[ ! $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo "Quiting"
    exit 0
fi

$MYSQL -u root -p${DB_ROOT_PASS} <<EOF
    CREATE DATABASE ${DB_TMP_NAME};
    GRANT ALL PRIVILEGES ON \`${DB_TMP_NAME}\`.* TO 'hexaa'@'%';
EOF

echo 'Creating schema of the target DB'
$MYSQL -u $DB_USER -p${DB_PASS} $DB_NAME < /migrator/hexaa_schema_new.sql
echo 'Loading SQL dump'
$MYSQL -u $DB_USER -p${DB_PASS} $DB_TMP_NAME < /hexaadump.sql

/migrator/migrator.py \
    -oh $DB_HOST -ou $DB_USER -opw $DB_PASS \
    -nh $DB_HOST -nu $DB_USER -npw $DB_PASS \
    -od $DB_TMP_NAME -nd $DB_NAME \
    --old-prefix 'urn:geant:niif.hu:hexaa' \
    --new-prefix 'urn:geant:hexaa.eu:hexaa'

$MYSQL -u root -p${DB_ROOT_PASS} <<EOF
    DROP DATABASE ${DB_TMP_NAME};
EOF
