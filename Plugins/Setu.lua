local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgType == 'TextMsg' and data.Content == '来点黄色' then
		os.execute('python /home/pi/qqbot/PythonPlugins/Setu.py ' .. data.fromGroupId)
		return 2
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
