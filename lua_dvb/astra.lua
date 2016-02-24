package.path = "/etc/astra/lua/?.lua"
log.set({ filename = "/var/log/astra/astra.log", stdout = false })

function requireDirectory( dir )
   dir = dir or ""
   local entities = love.filesystem.getDirectoryItems(dir)
   for k, ents in ipairs(entities) do
      trim = string.gsub( ents, ".lua", "")
	log.info("Files " .. dir)
--      require(dir .. "/" .. trim)
   end
end



--require("analyze")
--require("base")
--require("femon")
--require("dvbls")
--require("stream")
--require("websocket")

nod = requireDirectory( package.path )

