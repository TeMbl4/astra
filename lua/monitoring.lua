#!/usr/local/bin/astra4bin/astra_5

logfile = "/var/log/astra_5.log"
os.remove(logfile)
log.set({ filename = logfile })
pidfile("/var/run/astra_5.pid")

channels = {
{ name = "Strana", input = {"dvb://rad_11665_5#pnr=6&no_analyze"}, output = {"udp://192.168.55.71@230.233.2.66:1234"}},
{ name = "Russkiy roman", input = {"dvb://rad_11665_5#pnr=3&no_analyze"}, output = {"udp://192.168.55.71@230.233.2.52:1234"}},
{ name = "Nauka 2.0", input = {"dvb://rad_11665_5#pnr=2&no_analyze"}, output = {"udp://192.168.55.71@230.233.2.57:1234"}},
{ name = "Moya planeta", input = {"dvb://rad_11665_5#pnr=1&no_analyze"}, output = {"udp://192.168.55.71@230.233.2.56:1234"}},
{ name = "Sarafan", input = {"dvb://rad_11665_5#pnr=5&no_analyze"}, output = {"udp://192.168.55.71@230.233.2.63:1234"}},
}

-- declare
_an = {}
local hostname = utils.hostname()
local content = ""
local _t = 10 -- timer start signal

-- settings tuner
local tune_conf = {
    name = "rad_11665_5",
    type = "S",
    adapter = 5,
    lnb_sharing = true,
    frequency = 11665,
    polarization = "V",
    symbolrate = 44922,
    lof1 = 9750,
    lof2 = 10600,
    slof = 11700,
    modulation = "QPSK",
    device = 0,
    budget = false,
    fec = "AUTO",
    enable = true,
    callback = function(data)
      _t = _t + 1
      if(_t == 15)then
        content = "type=dvb&stream=rad_11665_5&adapter=5&server=" .. hostname .. "&signal=" .. data.signal .. "&snr=" .. data.snr .. "&status=" .. data.status .. "&ber=" .. data.ber .. "&unc=" .. data.unc
        send_monitor(content)
        _t = 0
      end
    end
}

rad_11665_5 = dvb_input(tune_conf)

function send_monitor(content)
  http_request({
    host = "192.168.234.241",
    path = "/tv_monitor_stat.php",
    method = "POST",
    content = content,
    port = 80,
    headers = {
        "User-Agent: Astra v." .. astra.version,
        "Host: " .. hostname,
        "Content-Type: application/x-www-form-urlencoded",
        "Content-Length: " .. #content,
        "Connection: close",
    },
    callback = function(s,r)
    end
  })
end

for q,item in pairs(channels)do
  local output = item.output[1]
  make_channel(item)
  _an[q] = {i = {}, a = {}, t = 20}
  _an[q].i = udp_input(item.output[1])
  _an[q].a = analyze({
        upstream = _an[q].i:stream(),
        name = "_" .. item.name,
        callback = function(data)
          if(_an[q].t==30 and data.total)then
            local scram = 0
            local onair = 0
            if(data.total.scrambled==true) then
              scram = 1
            end
            if(data.on_air==true) then
              onair = 1
            end
            content = "type=channel&server=" .. hostname .. "&adapter=" .. tune_conf.adapter .. "&channel=" .. item.name .. "&stream=" .. tune_conf.name .. "&scrambled=" .. scram .. "&bitrate=" .. data.total.bitrate .. "&cc_error=" .. data.total.cc_errors .. "&pes_error=" .. data.total.pes_errors .. "&ready=" .. onair
            send_monitor(content)
            _an[q].t = 0
          end
          _an[q].t = _an[q].t + 1
        end
  })
end
