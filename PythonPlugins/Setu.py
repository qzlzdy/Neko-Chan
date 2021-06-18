import base64
import requests
import json
import sys
import random
from math import floor

num = random.randint(1, 16000)

inFile = open('/home/pi/qqbot/Assets/setu/H{}.jpg'.format(num), 'rb').read()
buf = base64.b64encode(inFile)

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
    #'toUser': 827350866,
    'toUser': int(sys.argv[1]),
    'sendToType': 2,
    'sendMsgType': 'PicMsg',
    'content': str(num),
    'groupid': 0,
    'atUser': 0,
    'picUrl': '',
    'picBase64Buf': str(buf, 'utf-8'),
    'voiceUrl': '',
    'voiceBase64Buf': '',
    'forwordBuf': '',
    'forwordField': '',
    'fileMd5': '',
    'flashPic': False
}

requests.post(url, params=params, headers=headers, data=json.dumps(data))
