local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgType == "TextMsg" then
		if string.find(data.Content, "炼铜") then
			redirect2Lawyer(CurrentQQ, data)
			return 2
		end
		if string.find(data.Content, "炼") and string.find(data.Content, "铜") then
			redirect2Lawyer(CurrentQQ, data)
			return 2
		end
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
function redirect2Lawyer(CurrentQQ, data)
	luaRet = Api.Api_SendMsg(
		CurrentQQ,
		{
			toUser = data.FromGroupId,
			sendToType = 2,
			sendMsgType = "TextMsg",
			groupid = 0,
			content = "https://www.66law.cn/zuiming/321.aspx",
			atUser = data.FromUserId
		})
	log.notice("From Lua CopperMaker Ret-->%d", luaRet.Ret)
end
