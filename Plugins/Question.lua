local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	if data.MsgType == "TextMsg" and string.len(data.Content) <= 20 then
		keywords = {"什么", "怎么", "在哪"}
		for i = 1, #keywords do
			if string.find(data.Content, keywords[i]) then
				redirect2Baidu(CurrentQQ, data)
				return 2
			end
		end

		if string.find(data.Content, "吗") then
			predicates = {"是", "有", "要", "去"}
			for i = 1, #predicates do
				if string.find(data.Content, predicates[i]) then
					redirect2Baidu(CurrentQQ, data)
					return 2
				end
			end
		end
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
function redirect2Baidu(CurrentQQ, data)
	url = "https://www.baidu.com/s?wd=%s"
	wd = urlEncode(data.Content)
	luaRet = Api.Api_SendMsg(
		CurrentQQ,
		{
			toUser = data.FromGroupId,
			sendToType = 2,
			sendMsgType = "TextMsg",
			groupid = 0,
			content = string.format(url, wd),
			atUser = data.FromUserId
		})
	log.notice("From Lua Question Ret-->%d", luaRet.Ret)
end
function urlEncode(s)
	s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
	return string.gsub(s, " ", "+")
end
