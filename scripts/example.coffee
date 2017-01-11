# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /まぐろ|かつお|えさ|トロ|魚/i, (res) ->
    res.send "おなかすいたにゃー"

  robot.hear /(.+)から選べ/, (msg) ->
    items = msg.match[1].split(/[　・、\s]+/)
    item = msg.random items
    msg.reply "#{item}に決まりだにゃ！"

  robot.hear /(.*)のおいしいお店/, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('http://api.gnavi.co.jp/RestSearchAPI/20150630/?keyid=b2f39df5107e4f80423a086eb54d6148&format=json&freeword=' + keyword + '&pref=PREF13')
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json.rest[0].name)
      msg.send "『" + json.rest[0].name + "』で決まりだにゃ！"
      msg.send "お店情報はこれにゃ！ " + json.rest[0].url

  robot.hear /天気教えて｜天気を教えて|天気教えろ|天気は？/i, (msg) ->
    request = msg.http('http://weather.livedoor.com/forecast/webservice/json/v1?city=130010')
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json)
      msg.send "今日は" + json.forecasts[0].telop + "にゃ！"
      msg.send "明日は" + json.forecasts[1].telop + "にゃ！"
      #msg.send json.description.text

  robot.hear /気圧教えて｜気圧を教えて|気圧教えろ|気圧は？/i, (msg) ->
    request = msg.http('http://api.openweathermap.org/data/2.5/forecast/?q=atsugi,jp&APPID=67b919a67577e6bf698aba1c2a1a72d0')
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json)
      if json.list[0].main.pressure > 1030
        msg.send "今日は普通の気圧にゃ！"
      else if 1000 < json.list[0].main.pressure <= 1030
        msg.send "今日は低気圧にゃ！頭痛くなるかもにゃ！"
      else if json.list[0].main.pressure <= 1000
        msg.send "今日は超低気圧にゃ！奴隷は死んじゃうかも知れないにゃ！"

      if json.list[1].main.pressure > 1030
        msg.send "明日は普通の気圧にゃ！"
      else if 1000 < json.list[0].main.pressure <= 1030
        msg.send "明日は低気圧にゃ！頭痛くなるかもにゃ！"
      else if json.list[0].main.pressure <= 1000
        msg.send "明日は超低気圧にゃ！奴隷は死んじゃうかも知れないにゃ！"

  robot.hear /アンジュの好きなお菓子は？|アンジュの好きなおやつは？|おやつ/i, (msg) ->
    random = Math.floor(Math.random() * 1204) + 1
    request = msg.http('http://www.sysbird.jp/webapi/?apikey=guest&format=json&id=' + random)
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json)
      msg.send "アンジュは『" + json.item.name + "』が好きだにゃ！"

  robot.hear /今日のご飯は？|今日の夕飯は？|今日の晩御飯は？|アンジュは何が食べたい？|今日の晩ご飯は？|アンジュは今晩何が食べたい？|夕飯考えて|夕飯何が良い|晩飯どうする？/i, (msg) ->
    random1 = Math.floor(Math.random() * 54) + 1
    random2 = Math.floor(Math.random() * 3) + 1
    request = msg.http('https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121?applicationId=1091407890544628392&categoryId=' + random1)
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json.result[random2].recipeTitle)
      msg.send "アンジュは『" + json.result[random2].recipeTitle + "』が食べたいにゃ！"

  robot.hear /アンジュはどこに旅行するのが良いと思う？|旅行|アンジュはどこに行きたい？/i, (msg) ->
    random = Math.floor(Math.random() * 2)
    random1 = Math.floor(Math.random() * 46) + 1
    random2 = Math.floor(Math.random() * 184)
    request1 = msg.http('http://api.gnavi.co.jp/master/PrefSearchAPI/20150630/?keyid=b2f39df5107e4f80423a086eb54d6148&format=json')
                          .get()
    request2 = msg.http('https://webservice.recruit.co.jp/ab-road/country/v1/?key=3e2b4a21beb30b57&count=200&format=json')
                          .get()

    if(random == 0)
      request1 (err, res, body) ->
        json = JSON.parse body
        #console.log(json.pref[random].pref_name)
        msg.send "アンジュは" + json.pref[random1].pref_name + "に行くのが良いと思うにゃ！"
    else
      request2 (err, res, body) ->
        json = JSON.parse body
        #console.log(json.results.country[random].name)
        msg.send "アンジュは" + json.results.country[random2].name + "に行くのが良いと思うにゃ！"

  robot.hear /アンジュの今日のお昼ね場所は？|アンジュの今日のお昼寝場所は？/i, (msg) ->
    random = Math.floor(Math.random() * 184)
    request = msg.http('https://webservice.recruit.co.jp/ab-road/country/v1/?key=3e2b4a21beb30b57&count=200&format=json')
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json.results.country[random].name)
      msg.send "アンジュは今日は" + json.results.country[random].name + "でお昼寝するにゃ！"

  robot.hear /ちんこ|うんこ/i, (msg) ->
    msg.send "卑猥だにゃ！"

  robot.hear /(.*)が欲しい/, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('https://app.rakuten.co.jp/services/api/IchibaItem/Search/20140222?applicationId=1091407890544628392&format=json&keyword=' + keyword)
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json.Items[0])
      msg.send "『" + json.Items[0].Item.itemName + "』なんかどうかにゃ？"
      msg.send "詳細はこちらにゃ！ " + json.Items[0].Item.itemUrl

  robot.hear /アンジュー…/i, (msg) ->
    random = Math.floor(Math.random() * 5)
    switch random
      when 0
        msg.send "@yuccco おい、奴隷！みっちゃんを無視するんじゃないにゃ！"
      when 1
        msg.send "@yuccco 奴隷のくせにみっちゃんを無視するなんて生意気にゃ！"
      when 2
        msg.send "@yuccco みっちゃんを無視するなんて身の程知らずにゃ！今日は晩御飯抜きにゃ！"
      when 3
        msg.send "@yuccco 奴隷！みっちゃんが話しかけてるだろにゃ！"
      when 4
        msg.send "@yuccco 奴隷が生意気だからジュノと一緒に家出するにゃ！"

  robot.hear /(.*)の今日の運勢/i, (msg) ->
    item = msg.match[1]
    d = new Date
    year  = d.getFullYear()     # 年（西暦）
    month = d.getMonth() + 1    # 月
    date  = d.getDate()         # 日
    request = msg.http("http://api.jugemkey.jp/api/horoscope/free/#{year}/#{month}/#{date}").get()

    if month < 10
      month = "0" + month

    request (err, res, body) ->
      json = JSON.parse body
      #console.log("#{year}/#{month}/#{date}")
      #console.log(json.horoscope["#{year}/#{month}/#{date}"])
      result = json.horoscope["#{year}/#{month}/#{date}"]
      flag = false
      for key, value of result
#        console.log(key)
#        console.log(result[key].sign)
#        console.log(item)
        if item == result[key].sign
          msg.send "#{item}の今日の運勢は『" + result[key].content + "』にゃ！"
          msg.send "#{item}の今日のラッキーアイテムは『" + result[key].item + "』にゃ！"
          msg.send "#{item}の今日のラッキーカラーは『" + result[key].color + "』にゃ！"
          flag = true
          break

      if flag == false
        msg.send "#{item}なんて星座は無いにゃ！お前は馬鹿かにゃ！"

  robot.hear /今週何しようかな|今週どこ行こうかな/, (msg) ->
    random = Math.floor(Math.random() * 4)
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://evenear.com/rss/event/&num=100')
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      #console.log(json.responseData.feed.entries)
      msg.send "『" + json.responseData.feed.entries[random].title + "』なんかどうかにゃ？"
      msg.send "詳細はこちらにゃ！ " + json.responseData.feed.entries[random].link

  robot.hear /いまホットなワード|今ホットなワード/, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('http://sorasora.php.xdomain.jp/xml2json/xml2.json?url=http://searchranking.yahoo.co.jp/rss/burst_ranking-rss.xml')
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      feeds = json.channel.item
      #console.log(feeds)
      msg.send "いまホットなワードは『"
      for key, value of feeds
        msg.send feeds[key].title
        if key >= 10
          break
      msg.send "』にゃ！"
      #msg.send "詳細はこちらにゃ！ " + json.responseData.feed.entries[random].link

  robot.hear /(.*)を短縮/, (msg) ->
    keyword = encodeURIComponent msg.match[1]
    request = msg.http('https://api-ssl.bitly.com/v3/shorten?access_token=61eca9a52067305499cba55694cdaff2a10733ef&longUrl=' + keyword)
                          .get()
    request (err, res, body) ->
      json = JSON.parse body
      console.log(json.data.url)
      msg.send json.data.url

  robot.hear /おはよう|おはよー/, (msg) ->
    random = Math.floor(Math.random() * 5)
    switch random
      when 0
        msg.send "おはようにゃ！"
      when 1
        msg.send "まだ眠いにゃー。"
      when 2
        msg.send "おはようにゃ。今日も張り切って働くにゃ！"
      when 3
        msg.send "おはようにゃ。ジュノはまだ寝てるにゃ。"
      when 4
        msg.send "おはようにゃ。早く帰ってきておやつをよこすにゃ！"

  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
