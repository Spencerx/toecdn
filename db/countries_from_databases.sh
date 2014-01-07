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

mkdir -p Prefixes

function unpack_4() {

dbs=`ls db/*.db.gz 2>/dev/null | awk '{ printf "%s ",$1 }'`
dbs="${dbs}db/ripe.db.inetnum.gz"

gzip -d -c ${dbs} \
  | gawk '{ { if ($1 == "inetnum:"){ {is = tolower($2)} {ie = tolower($4)} } }  { if ($1 == "country:") { print toupper(substr($2,0,2))" "is" "ie} } }' \
  | gawk '{ { split($2, iss, /\./); } { split($3, ies, /\./); } { a=(strtonum(iss[1])*16777215)+(strtonum(iss[2])*65536)+(strtonum(iss[3])*256)+strtonum(iss[4]) } { b=(strtonum(ies[1])*16777215)+(strtonum(ies[2])*65536)+(strtonum(ies[3])*256)+strtonum(ies[4]) } { c = toupper($2) } { print $1" "$2" "$3" "(b-a)+1 } }' \
  | gawk '{ {n=0} {if ($4=="1") n=32} {if ($4=="2") n=31} {if ($4=="4") n=30} {if ($4=="8") n=29} {if ($4=="16") n=28} {if ($4=="32") n=27} {if ($4=="64") n=26} {if ($4=="128") n=25}{if ($4=="256") n=24} {if ($4=="512") n=23} {if ($4=="1024") n=22} {if ($4=="2048") n=21} {if ($4=="4096") n=20} {if ($4=="8192") n=19} {if ($4=="16384") n=18} {if ($4=="32768") n=17} {if ($4=="65536") n=16} {if ($4=="131072") n=15} {if ($4=="262144") n=14} {if ($4=="524288") n=13} {if ($4=="1048576") n=12} {if ($4=="2097152") n=11} {if ($4=="4194304") n=10} {if ($4=="8388608") n=9} {if ($4=="16777216") n=8} { if (n>0) print $2"/"n>>"c/"$1".4.txt"} }'
}

function unpack_6() {

dbs=`ls ../db/*.db.gz 2>/dev/null | awk '{ printf "%s ",$1 }'`
dbs="${dbs}db/ripe.db.inet6num.gz"

gzip -d -c ${dbs} \
  | gawk '{ { if ($1 == "inet6num:") i = tolower($2) }  { if ($1 == "country:") { { c = toupper($2) } { print i>>"c/"c".6.txt"} } } }' 
}

rm -r c
mkdir -p c

echo -n "Unpacking all countries for ip4..."
unpack_4
echo " done!"

echo -n "Unpacking all countries for ip6... "
unpack_6
echo " done!"

echo -n "Makeing prefixes4: "
echo "if countries == nil then countries = prefixes.new() else countries:deleteall() end" >prefix_countries.lua
echo "countries:add(\"127.0.0.1\", 8, {content = \"ZYX\", type = \"C\"})" >>prefix_countries.lua

rm -f Prefixes/prefixes_countries*.lua

rm -f Prefixes/prefix_all_countries4*.lua
l=$(ls -1 c/*.4.txt)
for f in ${l} ; do
    c=${f:2:2}
    d=${f:2:1}
    echo -n "${c} "
    gawk -v c=${c} -F / ' { print "countries:add(\""$1"\", "$2", {content = \""tolower(c)"\", type = \"C\"})" }' ${f} >>Prefixes/prefix_all_countries4.lua
done
echo " "

echo -n "Makeing prefixes6: "
rm -f Prefixes/prefix_all_countries6*.lua
l=$(ls -1 c/*.6.txt)
for f in ${l} ; do
    c=${f:2:2}
    d=${f:2:1}
    echo -n "${c} "
    gawk -v c=${c} -F / ' { print "countries:add(\""$1"\", "$2", {content = \""tolower(c)"\", type = \"C\"})" }' ${f} >>Prefixes/prefix_all_countries6.lua
done
echo " "

echo -n "Spliting files... "
split -l250000 --additional-suffix=.lua Prefixes/prefix_all_countries4*.lua Prefixes/prefixes_countries4_
split -l250000 --additional-suffix=.lua Prefixes/prefix_all_countries6*.lua Prefixes/prefixes_countries6_
echo " done!"

echo -n "Precompiling4: "
l=$(ls -1 Prefixes/prefixes_countries4_*.lua)
for f in ${l} ; do
    c=${f:29:2}
    echo -n "${c} "
    luac -s -o ${f} ${f}
done
echo " "

echo -n "Precompiling6: "
l=$(ls -1 Prefixes/prefixes_countries6_*.lua)
for f in ${l} ; do
    c=${f:29:2}
    echo -n "${c} "
    luac -s -o ${f} ${f}
done
echo " "
