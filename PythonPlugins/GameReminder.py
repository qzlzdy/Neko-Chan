import requests
import json

url = 'http://127.0.0.1:8899/v1/LuaApiCaller'

params = {
    'qq': '3620447366',
    'funcname': 'SendMsg',
    'timeout': 10
}

headers = {
    'Content-Type': 'application/json'
}

data = {
    'toUser': 419286376,
    'sendToType': 1,
    'sendMsgType': 'TextMsg',
    'content': '今天你打卡了吗',
    'groupid': 0,
    'atUser': 0
}

requests.post(url, params=params, headers=headers, data=json.dumps(data))
