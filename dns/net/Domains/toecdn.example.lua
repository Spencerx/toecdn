domains["soa"] = {
    domain_id = 42,
    hostmaster = "hostmaster.toecdn.example",
    nameserver = "ns.toecdn.example",
    serial = 2014010101,
    refresh = 28800,
    retry = 7200,
    expire = 604800,
    default_ttl = 86400,
    ttl = 3600
}

domains["r"] = {
    ["toecdn.example"] = {
        {name = "toecdn.example", type = "NS", ttl = 86400, content = "ns.toecdn.example"},
    }
}
