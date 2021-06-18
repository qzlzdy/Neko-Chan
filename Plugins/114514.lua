local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgType == "TextMsg" then
		if string.find(data.Content, '恶臭') or string.find(data.Content, '啊啊啊啊') then
			os.execute('python /home/pi/qqbot/PythonPlugins/114514.py ' .. data.FromGroupId)
			return 2
		end
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
