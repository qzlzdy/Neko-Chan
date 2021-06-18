import requests
import json

sendUrl = 'http://127.0.0.1:8899/v1/LuaApiCaller'

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
    #'toUser': 332536767,
    'toUser': 1161079807,
    'sendToType': 2,
    'sendMsgType': 'TextMsg',
    'content': '',
    'groupid': 0,
    'atUser': 0
}

content = '每日汇报：\n在线时间：{oltim}\n接收消息：{recvcnt}\n发送消息：{sendcnt}\n接收流量：{totrecv}\n发送流量：{totsend}\n{level}'

def report():
    url = 'http://127.0.0.1:8899/v1/ClusterInfo'
    response = requests.get(url)
    neko = json.loads(response.text)['QQUsers'][0]
    
    data['content'] = content.format(
            oltim=neko['OnlieTime'],
            recvcnt=neko['ReceiveCount'],
            sendcnt=neko['SendCount'],
            totrecv=neko['TotalRecv'],
            totsend=neko['TotalSend'],
            level=neko['UserLevelInfo'])
    requests.post(sendUrl, params=params, headers=headers, data=json.dumps(data))

if __name__ == '__main__':
    report()
