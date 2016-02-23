package.path = "/opt/astra/scripts/?.lua;/opt/astra/lua/?.lua"
log.set({ filename = "/opt/astra/log/astra_0.log", stdout = false })

require("dvbls")
require("base")
require("stream")

adapter_4 = dvb_tune({
        type = "T",
        enable = true,
        t2 = true,
        frequency = "746",
        name = "A4_ORA_NEWS",
        bandwidth = "8MHZ",
        device = 0,
        id = "a01d",
        modulation = "QAM64",
        adapter = 4
})

make_channel({
	type = "spts",
	id = "a01e",
	http_keep_active = "-1",
	input = {
		"dvb://a01d#pnr=1"
	},
	name = "Ora NEWS HD",
	enable = "true",
	output = {
		"http://127.0.0.1:20033/Oranews"
	}
})
