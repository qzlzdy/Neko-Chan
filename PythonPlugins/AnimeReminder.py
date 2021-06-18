import requests
import json
import time
import sys

# 全局变量
WeekName = ['月', '火', '水', '木', '金', '土', '日']

GroupId = [855524548, 1161079807]
#GroupId = [827350866]

# IOTBOT API
QQurl = 'http://127.0.0.1:8899/v1/LuaApiCaller'

QQparams = {
    'qq': '3620447366',
    'funcname': 'SendMsg',
    'timeout': 10
}

QQheaders = {
    'Content-Type': 'application/json'
}
    
QQdata = {
    "toUser": 0,
    "sendToType": 2,
    "sendMsgType": "TextMsg",
    "content": "",
    "groupid": 0,
    "atUser": 0
}

content = '今天是{date}  {day}\n今天更新的番剧有{total}部：'

# AniList API
ALurl = 'https://graphql.anilist.co'

query = '''
query ($page: Int, $seasonYear: Int, $season: MediaSeason) {
  Page(page: $page, perPage: 20){
    pageInfo {
      total
      currentPage
      lastPage
    }
    media(seasonYear: $seasonYear, season: $season, type: ANIME) {
      title{
        native
      }
      nextAiringEpisode {
        timeUntilAiring
        episode
      }
    }
  }
}
'''

variables = {
    'page': 1,
    'season': '',
    'seasonYear': ''
}

now = time.localtime(time.time())
date = time.strftime('%Y年%m月%d日', now)
day = '{}曜日'.format(WeekName[now.tm_wday])

def initTime():
    variables['seasonYear'] = now.tm_year
    month = now.tm_mon
    if month in [10, 11, 12]:
        season = 'FALL'
    elif month in [1, 2, 3]:
        season = 'WINTER'
    elif month in [4, 5, 6]:
        season = 'SPRING'
    elif month in [7, 8, 9]:
        season = 'SUMMER'
    variables['season'] = season

def getAniList():
    total = 0
    AniList = []
    while True:
        response = requests.post(ALurl, json={'query': query, 'variables': variables})
        page = json.loads(response.text)['data']['Page']
        pageInfo = page['pageInfo']
        media = page['media']
        for item in media:
            if item['nextAiringEpisode'] == None:
                continue
            restTime = item['nextAiringEpisode']['timeUntilAiring']
            if restTime <= 86400:
                title = item['title']['native']
                episode = item['nextAiringEpisode']['episode']
                AniList.append("\n[{no}] {title} #{episode}".format(no=total, title=title, episode=episode))
                total = total + 1
        if pageInfo['currentPage'] == pageInfo['lastPage']:
            break
        variables['page'] = pageInfo['currentPage'] + 1
    QQdata['content'] = content.format(date=date, day=day, total=total)
    for anime in AniList:
        QQdata['content'] = QQdata['content'] + anime


def sendMsg(groupId):
    QQdata['toUser'] = groupId
    requests.post(QQurl, params=QQparams, headers=QQheaders, data=json.dumps(QQdata))

def main():
    for groupId in GroupId:
        sendMsg(groupId)
        time.sleep(2)

if __name__ == '__main__':
    initTime()
    getAniList()
    if len(sys.argv) == 1:
        main()
    else:
        sendMsg(int(sys.argv[1]))
    print(QQdata['content'])
