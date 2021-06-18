local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

IgnoreList = {3620447366, 647547729}

function ReceiveFriendMsg(CurrentQQ, data)
    if data.MsgType == "TextMsg" then

	luaRes =
	    Api.Api_SendMsg(
	    CurrentQQ,
	    {
		    toUser = data.FromUin,
		    sendToType = 1,
		    sendMsgType = "TextMsg",
		    groupid = 0,
		    content = data.Content,
		    atUser = 0
	    }
	)
	log.notice("From Lua SendMsg Ret-->%d", luaRes.Ret)
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    -- Second Filter
    for i = 1, #IgnoreList do
        if data.FromUserId == IgnoreList[i] then
	    return 2
        end
    end
    if data.FromGroupId == 531592946 then
	    return 2
    end
    if string.find(data.Content, "/") == 1 then
	    return 1
    end
    -- Text
    if data.MsgType == "TextMsg" then

        luaRes =
            Api.Api_SendMsg(
            CurrentQQ,
            {
                toUser = data.FromGroupId,
                sendToType = 2,
                sendMsgType = "TextMsg",
                groupid = 0,
                content = data.Content,
                atUser = 0
            }
        )
        log.notice("From Lua SendText Ret-->%d", luaRes.Ret)
	return 1
    end 
    -- Picture
    if data.MsgType == "PicMsg" then
	jData = json.decode(data.Content)
	text = ""
	if jData.Content then
	    text = jData.Content
	end
	-- TODO multiple picture
	luaRes =
	    Api.Api_SendMsg(
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
		    picUrl = jData.GroupPic[1].Url,
		    picBase64Buf = "",
		    forwordBuf = "",
		    forwordField = "",
		    fileMd5 = "",
		    flashPic = false
	    }
	)
	log.notice("From Lua SendPic Ret-->%d", luaRes.Ret)
	return 1
    end
    -- Voice
    if data.MsgType == "VoiceMsg" then
	jData = json.decode(data.Content)
	luaRes = Api.Api_SendMsg(
	    CurrentQQ,
	    {
		toUser = data.FromGroupId,
		sendToType = 2,
		sendMsgType = "VoiceMsg",
		content = "",
		groupid = 0,
		atUser = 0,
		voiceUrl = jData.Url,
		voiceBase64Buf = '',
		picUrl = '',
		picBase64Buf = '',
		forwordBuf = '',
		forwordField = '',
		fileMd5 = '',
		flashPic = false
	    })
	log.notice("From Lua SendVoice Ret-->%d", luaRes.Ret)
	return 1
    end
    -- [@]at
    if data.MsgType == "AtMsg" then
	jData = json.decode(data.Content)

	print(data.FromGroupId, jData.Content, jData.UserID[1])

	luaRes =
	    Api.Api_SendMsg(
	    CurrentQQ,
	    {
		    toUser = data.FromGroupId,
		    sendToType = 2,
		    sendMsgType = "TextMsg",
		    groupid = 0,
		    -- TODO ^@*' '# -> ''
		    content = jData.Content,
		    atUser = jData.UserID[1]
	    }
	)

	log.notice("From Lua SendAt Ret-->%d", luaRes.Ret)
        return 1
    end
    -- Replay
    if data.MsgType == "ReplayMsg" then
	jData = json.decode(data.Content)

	luaRet = 
	    Api.Api_SendMsg(
	    CurrentQQ,
	    {
		    toUser = data.FromGroupId,
		    sendToType = 2,
		    sendMsgType = "ReplayMsg",
		    groupid = 0,
		    content = jData.Content,
		    atUser = 0,
		    replayInfo = {
			MsgSeq = jData.MsgSeq,
			MsgTime = data.MsgTime,
			UserID = jData.UserID,
			RawContent = jData.Content
		    }
	    }
	)

	log.notice("From Lua SendReplay Ret-->%d", luaRes.Ret)
	return 1
    end

    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
