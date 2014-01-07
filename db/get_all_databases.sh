#!/usr/bin/env bash

#    Copyright (C) 2011-2014 Fredrik Danerklint
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

mkdir -p db

function get_db() {

cd db
wget -nd --timestamping -r -l 1 --quiet "ftp://ftp.radb.net/radb/dbase/" 
wget --quiet --timestamping "ftp://ftp.ripe.net/ripe/dbase/split/ripe.db.inetnum.gz"
wget --quiet --timestamping "ftp://ftp.ripe.net/ripe/dbase/split/ripe.db.inet6num.gz"
wget --quiet --timestamping "ftp://ftp.ripe.net/ripe/dbase/split/ripe.db.route.gz"
wget --quiet --timestamping "ftp://ftp.ripe.net/ripe/dbase/split/ripe.db.route6.gz"
cd ..

}

echo -n "Downloading all databases..."
get_db
echo " done!"
