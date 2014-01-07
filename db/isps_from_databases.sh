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


function unpack_4() {

dbs=`ls db/*.db.gz 2>/dev/null| awk '{ printf "%s ",$1 }'`
dbs="${dbs}db/ripe.db.route.gz"

gzip -d -c ${dbs} \
  | gawk '{  { if ($1 == "route:") r = tolower($2) }  { if ($1 == "remarks:" && $2 == "ToEcDn:" && match($3,"/") == 0) { print $3"/"r } } }' >>Prefixes/prefixes_all_isps.txt
}

function unpack_6() {

dbs=`ls db/*.db.gz 2>/dev/null| awk '{ printf "%s ",$1 }'`
dbs="${dbs}db/ripe.db.route6.gz"

gzip -d -c ${dbs} \
  | gawk '{  { if ($1 == "route6:") r = tolower($2) }  { if ($1 == "remarks:" && $2 == "ToEcDn:" && match($3,"/") == 0) { print $3"/"r } } }' >>Prefixes/prefixes_all_isps.txt
}

rm -f Prefixes/prefixes_all_isps.txt

echo -n "Unpacking all isps for ip4... "
unpack_4
echo " done!"

echo -n "Unpacking all isps for ip6... "
unpack_6
echo " done!"

echo -n "Makeing isps... "
echo "if isps == nil then isps = prefixes.new() else isps:deleteall() end" >prefix_isps.lua
echo "isps:add(\"::\", 64, {content = \"tc.isp.example\", type = \"I\"})" >>prefix_isps.lua

gawk -F / ' { print "isps:add(\""$2"\", "$3", {content = \""$1"\", type = \"I\"})" }' Prefixes/prefixes_all_isps.txt >>Prefixes/prefix_all_isps.lua

echo -n "Spliting files... "
split -l250000 --additional-suffix=.lua Prefixes/prefix_all_isps.lua Prefixes/prefixes_isps_
echo " done!"

echo -n "Precompiling: "
l=$(ls -1 Prefixes/prefixes_isps_*.lua)
for f in ${l} ; do
    c=${f:24:2}
    echo -n "${c} "
    luac -s -o ${f} ${f}
done
echo " "
