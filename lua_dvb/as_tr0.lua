package.path = "/etc/astra/lua/?.lua"
log.set({ filename = "/var/log/astra/astra.log", stdout = false })

require("analyze")
require("femon")
require("websocket")
require("dvbls")
require("base")
require("stream")
--require("xproxyv2")
--require("file_server")
--require("relay")

adapter_1 = dvb_tune({
	    adapter = 1,
            device = 0,
            name = "A1:0_Eutelsat_10815H",
            type = "S",
            enable = true,
            polarization = "H",
            symbolrate = "27500",
            fec = "5/6",
            id = "a002",
            frequency = "10815"
})

make_channel({
	type = "spts",
	id = "a00i",
	http_keep_active = "-1",
	input = {
		"dvb://a002#pnr=17315"
	},
	name = "Fashion ONE",
	enable = "true",
	output = {
		"http://208.49.220.249:20033/Fashionone"
	}
})
