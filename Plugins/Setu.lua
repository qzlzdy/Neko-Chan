local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	if data.MsgType == 'TextMsg' and string.find(data.Content, '来点黄色') == 1 then
		keyword = data.Content:gsub('来点黄色 ', '')
		keyword = keyword:gsub(' ', '')
		os.execute('python /home/pi/qqbot/PythonPlugins/Setu.py 1 ' .. data.FromUin .. ' ' .. keyword)
		return 2
	end
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgType == 'TextMsg' and string.find(data.Content, '来点黄色') == 1 then
		keyword = data.Content:gsub('来点黄色 ', '')
		keyword = keyword:gsub(' ', '')
		os.execute('python /home/pi/qqbot/PythonPlugins/Setu.py 2 ' .. data.fromGroupId .. ' ' .. keyword)
		return 2
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
