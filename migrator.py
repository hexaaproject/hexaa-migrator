#!/usr/bin/env python3

# -*- coding: utf-8 -*-
#
# Copyright 2018 MTA SZTAKI ugyeletes@sztaki.hu
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a copy of
# the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

"""HEXAA database migrator to HEXAA version 2."""

import argparse
import mysql.connector


def main(argv=None):
    if not argv:
        import sys
        argv = sys.argv[1:]  # first arg is the program name

    parser = argparse.ArgumentParser(description='HEXAA db migrator')

    parser.add_argument('--old-host', '-oh', type=str,
                        help='Address of old DB.')
    parser.add_argument('--old-user', '-ou', type=str,
                        help='User for old DB.')
    parser.add_argument('--old-passwd', '-op', type=str,
                        help='Password for old DB.')
    parser.add_argument('--old-db', '-od', type=str,
                        help='Database name for old DB.')

    parser.add_argument('--new-host', '-nh', type=str,
                        help='Address of new DB.')
    parser.add_argument('--new-user', '-nu', type=str,
                        help='User for new DB.')
    parser.add_argument('--new-passwd', '-np', type=str,
                        help='Password for new DB.')
    parser.add_argument('--new-db', '-nd', type=str,
                        help='Database name for new DB.')

    args = parser.parse_args(argv)

    old_conf = dict(
        host=args.old_host,
        user=args.old_user,
        passwd=args.old_passwd,
        database=args.old_db
    )
    new_conf = dict(
        host=args.new_host,
        user=args.new_user,
        passwd=args.new_passwd,
        database=args.new_db
    )

    old_db = mysql.connector.connect(**old_conf)
    new_db = mysql.connector.connect(**new_conf)

    migrate(old_db, new_db)

    new_db.commit()

    new_db.close()
    old_db.close()


#: List of tables that are copeid directly, first element is the old table name,
#: the second is the new (if changed)
EXACT_COPY = (
    ('attribute_spec', None),
    ('attribute_value_organization', None),
    ('attribute_value_principal', None),
    ('entitlement', None),
    ('entitlement_pack', None),
    ('entitlement_pack_entitlement', None),
    ('hook', None),
    ('invitation', None),
    ('news', None),
    ('organization', None),
    ('organization_manager', None),
    ('organization_principal', None),
    ('organization_security_domain', None),
    ('organization_tag', None),
    ('personal_token', None),
    ('principal', None),
    ('role', None),
    ('role_entitlement', None),
    ('role_principal', None),
    ('security_domain', None),
    ('service', None),
    ('service_attribute_spec', None),
    ('service_attribute_value_principal', None),
    ('service_principal', None),
    ('service_security_domain', None),
    ('service_tag', None),
    ('tag', None),

    # renamed:
    ('attributevalueorganization_service',
     'service_attribute_value_organization'),
)


def migrate(old_db, new_db):
    old_cursor = old_db.cursor()
    new_cursor = new_db.cursor()

    # disable constraint checks for the current session (referenced rows are
    # inserted later than their key is referenced)
    new_cursor.execute('SET FOREIGN_KEY_CHECKS=0')

    # ----------------------
    # create exact replicas

    for old_table, new_table in EXACT_COPY:
        new_table = new_table or old_table
        print(f'{old_table:10s} -> {new_table:10s}')

        select = f'SELECT * FROM {old_table}'
        print('   ', select)
        old_cursor.execute(select)

        # column order may vary, so their names are explicitly listed
        cols = old_cursor.column_names
        insert = (f"INSERT INTO {new_table} ({','.join(cols)})"
                  f" VALUES ({','.join(['%s'] * len(cols))})")
        print('   ', insert)

        BATCH_SIZE = 20000
        while True:
            data = old_cursor.fetchmany(size=BATCH_SIZE)
            if not data:
                break

            try:
                new_cursor.executemany(insert, data)
            except mysql.connector.errors.InterfaceError as ex:
                print(ex)

                for row in data:
                    print(row)
                    new_cursor.execute(insert, row)

            print(f'    {new_cursor.rowcount} rows inserted')

            if len(data) < BATCH_SIZE:
                break

    new_cursor.close()
    old_cursor.close()


if __name__ == '__main__':
    main()
