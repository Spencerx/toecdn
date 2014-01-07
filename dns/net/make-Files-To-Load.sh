#!/usr/bin/env bash

echo "user_files_to_reload = { 
    \"Domains/toecdn.example.lua\"
}

user_files_to_rediscover = {
    \"prefix_countries.lua\",
    \"prefix_isps.lua\"," >powerdns-Files-To-Load.lua

l=$(ls -1 Prefixes/prefix*.lua)
for f in ${l} ; do
    echo  "    \"${f}\"," >>powerdns-Files-To-Load.lua
done

echo "}" >>powerdns-Files-To-Load.lua
