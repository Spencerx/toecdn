if countries == nil then countries = prefixes.new() else countries:deleteall() end
countries:add("127.0.0.1", 8, {content = "ZYX", type = "C"})
