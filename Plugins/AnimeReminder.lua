local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    if data.MsgType == "TextMsg" and data.Content == "今日番剧" then
        ret = os.execute("python /home/pi/qqbot/PythonPlugins/AnimeReminder.py " .. data.FromGroupId)
	log.notice("From Python AnimeRemind ret-->%d", ret)
	return 2
    end
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end

