 #!/usr/bin/astra
     
     
    log.set({ debug = true, stdout = true, filename = "/var/log/astra.log"})
     
    pidfile("/var/run/astra.pid")
     
    cam_1 = newcamd({
            name = "Reader",
            host = "х.х.х.х",
            port = "ххххх",
            username = "ххххх",
            password = "ххх",
            key = "010...21314",
    })
     
     
    dvb_1 = {
        adapter = 0, type = "S2",
        tp = "12034:h:27500",
        lnb = "10750:10750:10750"
    }
     
    s1 = make_stream({ name = "Stream 1", dvb = dvb_1 }, {
        { name = "Channel 1", pnr = 3120, cam = cam_1, addr = "239.255.1.1", analyze = true },
    })