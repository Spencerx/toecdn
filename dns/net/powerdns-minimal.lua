local domains = domains

local logging = logging
local logger = logger
local log_info = log_info

local dnspacket = dnspacket
local remote_ip, remote_port, local_ip, realremote_ip

local res = {}
local counter = 0
local nofr = 0

function list(target, domain_id)
    if logging then logger(log_info, "(l_list)", "target: ", target, " domain_id: ", domain_id) end
end

function lookup(qtype, qname, domain_id)
    if logging then logger(log_info, "(l_lookup) BEGIN qtype:", qtype, " qname:", qname," domain_id:", domain_id) end

    res = {}
    counter = 0
    nofr = 0

    if qname:sub(1, 2) ~= "*." then 
        if (qtype == "NS" or qtype == "ANY") and qname == "toecdn.example" then
            res = domains["r"]["toecdn.example"]
        else
            if (qtype == "ANY" or qtype == "CNAME") then
                remote_ip, remote_port, local_ip, realremote_ip = dnspacket()
                if logging then logger(log_info, "(l_lookup) dnspacket - remote:", remote_ip, " port:", remote_port, " local:", local_ip, " realremote:", realremote_ip) end

                local isp = isps:find(remote_ip)
                if isp ~= nil then 
                    if isp[1]["type"] == "I" then
                        local isp_name = isp[1]["content"]
                        if logging then logger(log_info, "(l_lookup) found ISP in prefix:", isp_name) end
                        res = { {type = "CNAME", ttl = 86400, content = qname:sub(1, qname:len() - 14) .. isp_name, name = qname} }
                    end
                end
                if #res == 0 then
                    local country = "xx."
                    local value = countries:find(remote_ip)
                    if value ~= nil then 
                        if value[1]["type"] == "C" then
                            country = value[1]["content"] .. "."
                            if logging then logger(log_info, "(l_lookup) found country in prefix:", value[1]["content"]) end
                        end
                    end

                    if qname:sub(1, country:len()) ~= country then
                        res = { {type = "CNAME", ttl = 86400, content = country .. qname:sub(1, qname:len() - 15), name = qname} }
                    end
                end
            end
        end
    end

    if res ~= nil then
        nofr = #res
    end

    if logging then logger(log_info, "(l_lookup) END - Number of records found:", nofr) end
end

function get()
    if logging then logger(log_info, "(l_get) BEGIN") end

    while counter < nofr do
        counter = counter + 1

        if res[counter] ~= nil then return res[counter] end
    end

    if logging then logger(log_info, "(l_get) END") end
    return false
end

function getsoa(name)
    if logging then logger(log_info, "(l_getsoa) BEGIN name:", name) end

    if name:sub(name:len() - 13) == "toecdn.example" then 
        if logging then logger(log_info, "(l_getsoa) END with soa") end
        return domains["soa"]
    end

    if logging then logger(log_info, "(l_getsoa) END with NO soa") end
end
