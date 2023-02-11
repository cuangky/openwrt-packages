-------------------------------------------------------------
-- Traccar Client use this protocol to report GPS data to the server side. 
-- OsmAnd Live Tracking web address format:
-- http://demo.traccar.org:5055/?id=123456&lat={0}&lon={1}&timestamp={2}&hdop={3}&altitude={4}&speed={5}
-------------------------------------------------------------
-- Copyright 2021-2022 Vladislav Kadulin <spanky@yandex.ru>
-- Licensed to the GNU General Public License v3.0

local http = require("socket.http")

local trackcar = {}

local function OsmAnd(GnssData, serverConfig)
    local unix = GnssData.warning.rmc[1] and os.time() or GnssData.gp.unix
	return string.format("http://%s:%s/?id=%s&lat=%s&lon=%s&timestamp=%s&hdop=%s&altitude=%s&speed=%s&satellites=%s",
			serverConfig.address, serverConfig.port, serverConfig.login,
			GnssData.gp.latitude  or '-', GnssData.gp.longitude or '-',
			unix                  or '-', GnssData.gp.hdop      or '-',
			GnssData.gp.altitude  or '-', GnssData.gp.spkm      or '-',
			GnssData.gp.nsat      or '-')
end

-- Send data to server side
function trackcar.sendData(GnssData, serverConfig)
	local data = OsmAnd(GnssData, serverConfig)
	http.TIMEOUT = 0.5
	http.request{ method = "POST", url = data}
	return {false, "OK"}
end

return trackcar