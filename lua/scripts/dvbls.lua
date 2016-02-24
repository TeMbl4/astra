#!/usr/bin/env astra-4.0

local dvb_list = dvbls()
mac = {}
atype = {}
for _,dvb_info in pairs(dvb_list) do
mac[dvb_info.adapter]=dvb_info.mac;

-- print(dvb_info.adapter .. "," .. dvb_info.mac);
--    log.info("adapter=" .. dvb_info.adapter .. ",mac=" .. dvb_info.mac .. ",device=" .. dvb_info.device)
--    if dvb_info.error then
--        log.error("    " .. dvb_info.error)
--    else
--        if dvb_info.busy == true then
--            log.info("    adapter in use")
--        end
--        log.info("    mac = " .. dvb_info.mac)
--        log.info("    frontend = " .. dvb_info.frontend)
--    end
	test_dvbs=string.gsub(dvb_info.frontend,"-","")
	if (string.find(test_dvbs,"DVBS")) then
		if string.find((dvb_info.frontend),"S2") then
			atype[dvb_info.adapter]="S2"
		else
			atype[dvb_info.adapter]="S"
		end
	end	
        if (string.find(test_dvbs,"DVBT")) then
                if string.find((dvb_info.frontend),"T2") then
                        atype[dvb_info.adapter]="T2"
                else
                        atype[dvb_info.adapter]="T"
                end
        end

end

cnt=0
for Index, Value in pairs( mac ) do
	cnt=cnt+1
end


for i=0,cnt-1,1 do
	print(i .. "," .. mac[i] .. "," .. atype[i])
end

astra.exit()
