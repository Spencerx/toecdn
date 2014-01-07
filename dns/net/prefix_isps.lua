if isps == nil then isps = prefixes.new() else isps:deleteall() end
isps:add("::", 64, {content = "tc.isp.example", type = "I"})
