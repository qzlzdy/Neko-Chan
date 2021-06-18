local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

IgnoreList = {3620447366, 647547729}

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	for i = 1, #IgnoreList do
		if data.FromUserId == IgnoreList[i] then
			log.notice("From Lua Filter: ignored")
			return 2
		end
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
