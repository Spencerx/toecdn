databases used in TOECDN
========================

First, run get_all_databases.sh. 

After that run countries_from_databases.sh. This will create a number of files in Prefixes/prefixes_countries_*.lua 

Third, run isps_from_databases.sh.


This will make the Lua files under the Prefixes directory which you can use with the Lua module "prefixes" (https://github.com/fredan/luabackend).
Don't forget to move the files from Prefixes/prefixes_countries*.lua to ../dns/net/Prefixes.



