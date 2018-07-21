# Whatsapp Analysis using Bash

This is a weekend project, a bit more than a weekend. :)

The whole reason I started this was curiosity before finding there are many tools doing the same thing, but that doesn't stop me. 

I needed to grow my knowledge in text processing in BASH, although I believe I'm familiar enough with sed, awk, grep and tr I actually found out I'm not, and that I'm missing a lot. Therefore I didn't stop doing this project. 

I was bored of trying to work emojis in bash, so I used the help of the best language in the world (I mean maybe?) Python. So the script is referencing emoji.py, which is shamelessly something I pulled online... there are a lot of pipes in this code and I'm sorry if it's confusing it's just how my mind works. And I am not planning to optimize this code. 

I started with Android, then adapted the code to work with iOS, I'm expecting weird behavior, especially with big groups, more than 20 persons. 

There is a lot of bad practices in this code, it's a learning experience not a finalized product, so take it as that. 

# What does it do?
* Number of messages
* Time frequency in hours. 
* First and last day. 
* Top used emojis
* Top used words ...and more. 


# How can you run it?
1. Make sure script.sh and emoji.py are in the same directory. 
2. Export the Whatsapp conversation to .txt, if you don't know how to, google?
3. Make sure you have +x privileges. 
4. ./script.sh whatsapp_coversation.txt (it only works with a parameter, which in this case is the conversation exported)
5. If it doesn't work, especially with devices other than Mac OSX, I'm not sure how I can help, since I used only commands that work with Mac OSX, I'm sorry. 

So this is the end of the project, it was fun. 

If you need any help with anything related, hit me up on twitter @alialghamdi
