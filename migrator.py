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

    parser.add_argument('--old-host', '-oh', type=str, default='localhost',
                        help='Address of old DB (default: %(default)s).')
    parser.add_argument('--old-port', '-opo', type=int, default=3306,
                        help='Port old DB (default: %(default)s)')
    parser.add_argument('--old-user', '-ou', type=str, required=True,
                        help='User for old DB.')
    parser.add_argument('--old-passwd', '-opw', type=str,
                        help='Password for old DB.')
    parser.add_argument('--old-db', '-od', type=str,
                        help='Database name for old DB.')

    parser.add_argument('--new-host', '-nh', type=str, default='localhost',
                        help='Address of new DB. (default: %(default)s).')
    parser.add_argument('--new-port', '-npo', type=int, default=3306,
                        help='Port new DB (default: %(default)s).')
    parser.add_argument('--new-user', '-nu', type=str,
                        help='User for new DB.')
    parser.add_argument('--new-passwd', '-npw', type=str,
                        help='Password for new DB.')
    parser.add_argument('--new-db', '-nd', type=str,
                        help='Database name for new DB.')

    parser.add_argument('--old-prefix', type=str,
                        help='Old entitlement URI prefix to be replaced.')
    parser.add_argument('--new-prefix', type=str,
                        help='New entitlement URI prefix.')

    args = parser.parse_args(argv)

    old_conf = dict(
        host=args.old_host,
        port=args.old_port,
        user=args.old_user,
        passwd=args.old_passwd,
        database=args.old_db
    )
    new_conf = dict(
        host=args.new_host,
        port=args.new_port,
        user=args.new_user,
        passwd=args.new_passwd,
        database=args.new_db
    )

    old_db = mysql.connector.connect(**old_conf)
    new_db = mysql.connector.connect(**new_conf)

    try:
        migrate(old_db, new_db, args.old_prefix, args.new_prefix)
    except Exception as ex:
        print('Rolling back changes')
        new_db.rollback()
        raise ex
    else:
        print('Committing changes')
        new_db.commit()
    finally:
        new_db.close()
        old_db.close()


#: List of tables that are copied directly, first element is the old table name,
#: the second is the new (if changed)
EXACT_COPY = (
    ('attribute_spec', None),
    ('attribute_value_organization', None),
    ('attribute_value_principal', None),
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


def migrate(old_db, new_db, old_prefix=None, new_prefix=None):
    '''
    CHANGED:
        linker_token:
            In the old version, the token is used to connect to an
            entitlement_pack, in the new version it enables a link.

    OLD:
        consent
        consent_attribute_spec

        organization_entitlement_pack
    NEW:
        link
        link_entitlement
        link_entitlement_pack

    TODO:
        Ignore news about consents?
        select * from news where principal_id=975 and title like '%consent%';
    '''

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

    # ----------------------
    # replace entitlement URI prefixes

    print('\nentitlement  -->  entitlement')
    select = ('SELECT id, service_id, name, description, uri, created_at,'
              ' updated_at FROM entitlement')
    insert = ('INSERT INTO entitlement (id, service_id, name, description, uri,'
              ' created_at, updated_at) VALUES (%s, %s, %s, %s, %s, %s, %s)')

    print('   ', select)
    print('   ', insert)

    old_cursor.execute(select)
    data = old_cursor.fetchall()
    for row in data:
        uri = row[4]
        if old_prefix and uri.startswith(old_prefix):
            row = list(row)
            row[4] = uri.replace(old_prefix, new_prefix, 1)
        new_cursor.execute(insert, row)
    print(f'    {len(data)} rows transformed\n')

    # ----------------------
    # transform linked orgs and entitlement packs

    # notes:
    # - `accept_at` is discarded (there is no corresponding column for it in the
    #   new tables)
    # - the group of organization_entitlement_pack rows that connect the same
    #   service and org will be transformed into one Link and the same number of
    #   link_entitlement_pack connections
    print('organization_entitlement_pack  -->  link, link_entitlement_pack')

    # this will cause an error if there are linked entitlements between one
    # service and one org with different statuses (in the new version, only one
    # link is allowed)
    select = ('SELECT'
              '   MIN(org_pack.id), organization_id, status,'
              '   MAX(org_pack.updated_at), MIN(org_pack.created_at),'
              '   service_id'
              ' FROM organization_entitlement_pack AS org_pack'
              ' INNER JOIN entitlement_pack'
              '   ON entitlement_pack_id = entitlement_pack.id'
              ' GROUP BY organization_id, service_id, status')

    insert_link = ("INSERT INTO link"
                   " (id, organization_id, service_id, status, updatedAt,"
                   "  createdAt)"
                   " VALUES (%s, %s, %s, %s, %s, %s)")

    print('   ', select)
    print('   ', insert_link)

    old_cursor.execute(select)
    data = old_cursor.fetchall()
    for row in data:
        (lid, organization_id, status, updated_at,
         created_at, service_id) = row

        new_cursor.execute(insert_link, (lid, organization_id, service_id,
                                         status, updated_at, created_at))
    print(f'    {len(data)} rows transformed\n')

    select = ('SELECT'
              '   MIN(org_pack.id), entitlement_pack_id'
              ' FROM organization_entitlement_pack AS org_pack'
              ' INNER JOIN entitlement_pack'
              '   ON entitlement_pack_id = entitlement_pack.id'
              ' GROUP BY organization_id, service_id, entitlement_pack_id')
    insert_entitlementp = ("INSERT INTO link_entitlement_pack"
                           " (link_id, entitlement_pack_id)"
                           " VALUES (%s, %s)")
    print('   ', select)
    print('   ', insert_entitlementp)

    old_cursor.execute(select)
    data = old_cursor.fetchall()
    for row in data:
        (lid, entitlement_pack_id) = row
        new_cursor.execute(insert_entitlementp, (lid, entitlement_pack_id))
    print(f'    {len(data)} rows transformed')

    new_cursor.close()
    old_cursor.close()


if __name__ == '__main__':
    main()
