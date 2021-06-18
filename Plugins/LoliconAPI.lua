local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
	return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
	-- Second Filter
	if data.FromUserId == 3620447366 then
		return 2
	end
	if data.MsgType == "TextMsg" and string.find(data.Content, "来点色图") == 1 then
		keyword = data.Content:gsub("来点色图", "")
		keyword = keyword:gsub(" ", "")
		Qtext = "apikey=879151345edc87cb9de5f2&r18=2&size1200=true%s"
		--Qtext = "%s"
		if keyword == "" then
			Qtext = string.format(Qtext, "")
		else
			Qtext = string.format(Qtext, "&keyword=" .. keyword)
		end
		response, error_message = http.request(
			"GET",
			"https://api.lolicon.app/setu/",
			{
				query = Qtext
			})
		luaRet = Api.Api_SendMsg(
			CurrentQQ,
			{
				toUser = data.FromGroupId,
				sendToType = 2,
				sendMsgType = "TextMsg",
				groupid = 0,
				content = "少女脱衣中...",
				atUser = 0
			})
		log.notice("From Lua LoliconAPI Pre-->%d", luaRet.Ret)

		jData = json.decode(response.body)
		if jData.code ~= 0 then
			setuFail(CurrentQQ, data, jData.code)
			return 2
		end
		text = string.format(
			"id: %d\ntitle: %s\nauther: %s\n剩余社保次数：%d\n贤者时间：%d秒", 
			jData.data[1].pid, 
			jData.data[1].title,
			jData.data[1].author,
			jData.quota,
			jData.quota_min_ttl)
		flag = 1
		repeat
			luaRet = Api.Api_SendMsg(
				CurrentQQ,
				{
					toUser = data.FromGroupId,
					sendToType = 2,
					sendMsgType = "PicMsg",
					content = text,
					groupid = 0,
					atUser = 0,
					voiceUrl = "",
					voiceBase64Buf = "",
					picUrl = jData.data[1].url,
					picBase64Buf = "",
					forwordBuf = "",
					forwordField = "",
					fileMd5 = "",
					flashPic = false
				})
			log.notice("From Lua LoliconAPI Ret-->%d", luaRet.Ret)
			flag = luaRet.Ret
		until flag == 0
		return 2
	end
	return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
	return 1
end
function setuFail(CurrentQQ, data, code)
	luaRet = Api.Api_SendMsg(
		CurrentQQ,
		{
			toUser = data.FromGroupId,
			sendToType = 2,
			sendMsgType = "TextMsg",
			groupid = 0,
			content = string.format("已经不能再看了啦\nError Code: %d", code),
			atUser = 0
		})
	log.notice("From Lua LoliconAPI Ret-->%d", luaRet.Ret)
end
