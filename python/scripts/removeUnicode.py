# The purpose of this code is to transform 
import json
import re
import string

with open('lyincomey_18_04_12_11_30_02.txt') as json_data:
    tweetData = json.load(json_data)
    tweetList = tweetData['statuses']

# Supercollider cannot read a JSON file if it has unicode (i.e. \uXXXX). Make a function that will
# get rid of it.
def removeUnicode (stringWithEmojis):
    stringNoEmojis = ''.join(filter(lambda x:x in string.printable, stringWithEmojis))
    return stringNoEmojis

for idx, status in enumerate(tweetList):

    print(idx)
    tweetList[idx]['text'] = removeEmojis(status['text'])
    tweetList[idx]['user']['description'] = removeEmojis(status['user']['description'])
    tweetList[idx]['user']['name'] = removeEmojis(status['user']['name'])
    tweetList[idx]['user']['location'] = removeEmojis(status['user']['location'])

    if 'url' in status['user']['entities']:
        urls = status['user']['entities']['url']['urls']
        for x in range(len(urls)):
            tweetList[idx]['user']['entities']['url']['urls'][x]['display_url'] = removeEmojis(urls[x]['display_url'])


    if 'entities' in status:
        entities = status['entities']
        if 'user_mentions' in entities:
            for x in range(len(status['entities']['user_mentions'])):
                tweetList[idx]['entities']['user_mentions'][x]['name'] = removeEmojis(status['entities']['user_mentions'][x]['name'])
        if 'urls' in entities:
            urls = status['entities']['urls']
            for x in range(len(urls)):
                tweetList[idx]['entities']['urls'][x]['display_url'] = removeEmojis(urls[x]['display_url'])


    if 'retweeted_status' in status:
        retweeted_status = status['retweeted_status']
        tweetList[idx]['retweeted_status']['text'] = removeEmojis(retweeted_status['text'])
        tweetList[idx]['retweeted_status']['user']['description'] = removeEmojis(retweeted_status['user']['description'])
        tweetList[idx]['retweeted_status']['user']['name'] = removeEmojis(retweeted_status['user']['name'])

        if 'user_mentions' in retweeted_status['entities']:
            user_mentions = retweeted_status['entities']['user_mentions']
            for x in range(len(user_mentions)):
                tweetList[idx]['retweeted_status']['entities']['user_mentions'][x]['name'] = removeEmojis(user_mentions[x]['name'])
        # Remove ... from displayed urls
        if 'url' in tweetList[idx]['retweeted_status']['user']['entities']:
            urls = tweetList[idx]['retweeted_status']['user']['entities']['url']['urls']
            for x in range(len(urls)):
                tweetList[idx]['retweeted_status']['user']['entities']['url']['urls'][x]['display_url'] = removeEmojis(urls[x]['display_url'])

        urls = tweetList[idx]['retweeted_status']['entities']['urls']
        for x in range(len(urls)):
            tweetList[idx]['retweeted_status']['entities']['urls'][x]['display_url'] = (removeEmojis(urls[x]['display_url']) + '...')

        if 'quoted_status' in retweeted_status:
            quoted_status = status['retweeted_status']['quoted_status']
            tweetList[idx]['retweeted_status']['quoted_status']['text'] = removeEmojis(quoted_status['text'])
            tweetList[idx]['retweeted_status']['quoted_status']['user']['description'] = removeEmojis(quoted_status['user']['description'])
            tweetList[idx]['retweeted_status']['quoted_status']['user']['name'] = removeEmojis(quoted_status['user']['name'])

            if 'urls' in quoted_status['entities']:
                urls = quoted_status['entities']['urls']
                for x in range(len(urls)):
                    tweetList[idx]['retweeted_status']['quoted_status']['entities']['urls'][x]['display_url'] = removeEmojis(urls[x]['display_url'])

    if 'quoted_status' in status:
        quoted_status = status['quoted_status']
        tweetList[idx]['quoted_status']['text'] = removeEmojis(quoted_status['text'])
        tweetList[idx]['quoted_status']['user']['description'] = removeEmojis(quoted_status['user']['description'])
        tweetList[idx]['quoted_status']['user']['name'] = removeEmojis(quoted_status['user']['name'])  

        if 'urls' in quoted_status['entities']:
            urls = quoted_status['entities']['urls']
            for x in range(len(urls)):
                tweetList[idx]['quoted_status']['entities']['urls'][x]['display_url'] = removeEmojis(urls[x]['display_url'])

with open('dataNoEmojis.json', 'w') as f:
	json.dump(tweetList, f, sort_keys=True, indent=4, separators=(',', ': '))