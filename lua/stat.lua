function stat_cb(self, data)
    if type(data) == 'table' then
        local dvb_stat = s1.dvb:status()

        local html = "<html><head><title>Stat</title></head><body><pre>"
        html = html .. "<b>DVB</b> adapter:" .. s1.config.dvb.adapter ..
               " lock:" .. tostring(dvb_stat.lock) ..
               " signal:" .. tostring(dvb_stat.signal) .. "%" ..
               " snr:" .. tostring(dvb_stat.snr) .. "%\n"
        for _,ch in pairs(s1.channels) do
            local ch_stat = ch.analyze:status()
            html = html .. "    <b>" .. ch.config.name .. "</b>" ..
                   " ready:" .. tostring(ch_stat.ready) ..
                   " bitrate:" .. tostring(ch_stat.bitrate) ..
                   " scrambled:" .. tostring(ch_stat.scrambled) ..
                   "\n"
        end
        html = html .. "</pre></body></html>"

        self:send({
            code = 200,
            message = "OK",
            headers = {
                "Server: Astra " .. astra.version(),
                "Content-Type: text/html; charset=utf-8",
                "Content-Length: " .. #html,
                "Connection: close"
            },
            content = html
        })
    end
end

stat = http_server({ 
	port = 8000, 
	callback = stat_cb 
})