import base64
import requests
import json
import sys
import random
import sqlite3
from math import floor

db = sqlite3.connect('/home/pi/qqbot/Assets/Setu.db')

sql = '''
SELECT illust_id
FROM have
JOIN Categories
ON cate_id = id
WHERE name_en = ?
'''

#print(sys.argv)

if sys.argv[2] == '来点黄色':
    num = random.randint(1, 17500)
else:
    cur = db.execute(sql, (sys.argv[2],))
    ids = [x[0] for x in cur]
    num = ids[random.randint(0, len(ids) - 1)]

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
