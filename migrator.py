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

    # TODO

    new_db.commit()

    new_db.close()
    old_db.close()


if __name__ == '__main__':
    main()
