# Python script to complement the bash script
# This will analyze emojis used in the conversation
# This script is put together from a lot of soruces in stackoverflow, i own nothing of it.
# Ali Alghamdi, 2018

# Importing needed
import emoji
import re
import collections
import operator 
import sys

# Opening files
chat_file = sys.argv[1]
source = open(chat_file)
output_file = open("emojis.txt","w")
emoji_count = collections.defaultdict(int)

for line in source:
    for emoji in re.findall(u'[\U0001f300-\U0001f650]|[\u2000-\u3000]', line):
        emoji_count[emoji] += 1

output_file.write(str(emoji_count))
output_file.close
