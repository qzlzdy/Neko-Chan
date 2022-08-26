import base64
import requests
import json
import sys
import random
from math import floor
import io
import time

#print(sys.argv)
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
    'toUser': int(sys.argv[2]),
    'sendToType': int(sys.argv[1]),
    'sendMsgType': 'PicMsg',
    'content': '',
    'groupid': 0,
    'atUser': 0,
    'picUrl': '',
    'picBase64Buf': '',
    'voiceUrl': '',
    'voiceBase64Buf': '',
    'forwordBuf': '',
    'forwordField': '',
    'fileMd5': '',
    'flashPic': False
}

def sendSetu():
    num = random.randint(32001, 48000)
    inFile = open('/home/pi/qqbot/Assets/setu/H{}.jpg'.format(num), 'rb').read()
    buf = base64.b64encode(inFile)
    data['content'] = str(num)
    data['picBase64Buf'] = str(buf, 'utf-8')
    requests.post(url, params=params, headers=headers, data=json.dumps(data))

for i in range(10):
    sendSetu()
    time.sleep(2)
