# The purpose of this code is to transform 
import json
import re
import string

with open('lyincomey_18_04_12_11_30_02.txt') as json_data:
    string = json_data.read()
    tweets = json.loads(string)


# A means to loop through all keys in a dictionary
def loopOverValue (key, possibleDictOrList):
    if isinstance(possibleDictOrList, list):

        print('\n' + key + ' is list with length: ' + str(len(possibleDictOrList)))
        for x in range(len(possibleDictOrList)):
            loopOverValue(key, possibleDictOrList[x])

    elif isinstance(possibleDictOrList, dict):

        print('\n' + key + ' is dict with length: ' + str(len(possibleDictOrList)))
        for k, v in possibleDictOrList.items():
            loopOverValue(k, v)
    else:

        print(key + ': ' + str(possibleDictOrList))

for idx, status in enumerate(tweets['statuses']):

    if idx == 0:
        for k1, v1 in status.items():
            loopOverValue(k1, v1)
                

# 	# if idx != 45:
# 	# 	continue
# 	####### REMOVE EMOJIS ######
#  	# Emojis need to be converted to a description for accessibility purposes
#  	# Without the lookup table, I am simply removing them all together.
#  	tweetText = status['text']
#  	userDescription = status['user']['description']
#  	 # Remove emojis using regular expressions
#  	tweetText = emojis.sub(r'', tweetText)
#  	userDescription = emojis.sub(r'', userDescription)
 	
# 	tweetList[idx]['MSR']['text'] = tweetText
# 	tweetList[idx]['text'] = tweetText
# 	tweetList[idx]['user']['entities']['description'] = userDescription

#  	if 'retweeted_status' in status:
#  		retweetText = status["retweeted_status"]["text"]
#  		retweetUserDescription = status['retweeted_status']['user']['description']
 		
#  		retweetText = emojis.sub(r'',retweetText)
#  		retweetUserDescription = emojis.sub(r'',retweetUserDescription)
#  		tweetList[idx]["retweeted_status"]["text"] = retweetText
# 		tweetList[idx]['retweeted_status']['user']['description'] = retweetUserDescription

# with open('dataNoEmojis.json', 'w') as f:
# 	json.dump(tweetList, f, sort_keys=True, indent=4, separators=(',', ': '))