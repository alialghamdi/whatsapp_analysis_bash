#	#	#	#	#	#	#	#	#	#	#	#
#					 						#
# Whatsapp Analyzer									#
# Ali Alghamdi, 2018									#
# v0.1											#
#											#
# Buy me tea										#
#											#
# alialghamdi.com									#
#											#
#	#	#	#	#	#	#	#	#	#	#	#

##### Pass the conversation file as a parameter
##### Make sure the script running user has permissions to create files

source="$1"

# Make a directory for this operation
dir=$RANDOM
mkdir $dir
cd $dir

# to differentiate between ios and android
first_char=$(head -n 1 ../$source | cut -c1)

# Media lines has all the line that have <media omitted>
medialines=()

# A word counter of each user
wcounter=()

# Words to omit from top 10 words
common='[[:<:]]i[[:>:]]|[[:<:]]you[[:>:]]|[[:<:]]to[[:>:]]|[[:<:]]the[[:>:]]|[[:<:]]and[[:>:]]|[[:<:]]or[[:>:]]|[[:<:]]am[[:>:]]|[[:<:]]a[[:>:]]|[[:<:]]it[[:>:]]|[[:<:]]my[[:>:]]|[[:<:]]is[[:>:]]|[[:<:]]so[[:>:]]|[[:<:]]for[[:>:]]|[[:<:]]im[[:>:]]|[[:<:]]its[[:>:]]|[[:<:]]are[[:>:]]|[[:<:]]of[[:>:]]|[[:<:]]for[[:>:]]|[[:<:]]that[[:>:]]|[[:<:]]omitted[[:>:]]|[[:<:]]media[[:>:]]|[[:<:]]audio[[:>:]]|[[:<:]]video[[:>:]]|[[:<:]]this[[:>:]]|[[:<:]]in[[:>:]]|[[:<:]]your[[:>:]]|[[:<:]]was[[:>:]]|[[:<:]]were[[:>:]]|[[:<:]]not[[:>:]]|[[:<:]]be[[:>:]]|[[:<:]]on[[:>:]]|[[:<:]]am[[:>:]]|[[:<:]]has[[:>:]]|[[:<:]]all[[:>:]]|[[:<:]]ill[[:>:]]|[[:<:]]with[[:>:]]|[[:<:]]have[[:>:]]|[[:<:]]me[[:>:]]|[[:<:]]like[[:>:]]|[[:<:]]but[[:>:]]|[[:<:]]if[[:>:]]|[[:<:]]do[[:>:]]|[[:<:]]youre[[:>:]]|[[:<:]]they[[:>:]]|[[:<:]]image[[:>:]]|[[:<:]]s[[:>:]]'

if [ "$first_char" == "[" ]
then
	#iphone users conversation
	awk '$1 ~ /\// {print}' ../$source | sed '/\[/!d' | awk -F '[-:]' '{print $3}' | sed -e 's/^[0-9][0-9]] //'| awk '!/Messages|left|group|added|changed/' | sort | uniq > users.txt
    
	# iphone busiest 10 days
	awk '{print $1}' ../$source | sed -e '/\[/!d' | cut -c 2- | sort | uniq -c | sort -nr | sed -e 's/,//' | head -10 	 
    
	echo "Users are:\n"
	IFS=$'\n' read -d '' -r -a users < users.txt
	cat users.txt
	
	#iphone time freq
	awk '{print $2}' ../$source | sed '/[0-9][0-9]:[0-9][0-9]/!d' | cut -c 1-2 | sort | uniq -c > times.txt

	# first and last day texting
	sed -n -e '1p;$p' ../$source | sed '/\[/!d' | sed 's/\[//g' | sed 's/,.*//'

	# An array of the users count for the for loop
	arraylength=$(wc -l < users.txt)
    
    if [ ${arraylength} -gt 2 ]
    then
    #Top 10 used by group
    
        cat ../$source | cut -d ":" -f 4- | sed 's/ //' | sed 's'/`printf "\xe2\x80\x8e"`'//g' | sed -e 's/http[^ ]*//g' | tr '[:upper:]' '[:lower:]' | sed 's/[:.!?,'\''/\\"()^*’”…☀“]//g' | sed '/^[[:space:]]*$/d' > temp.txt
        
        #Top 10 words used
            echo "Top 10 words used"
            cat temp.txt | sed -e 's/\.//g'  -e 's/\,//g' -e 's/ /\
/g' | tr 'A-Z' 'a-z' | grep '..' | sed -E "s/$common//g" | sed '/^[[:space:]]*$/d' | sort | uniq -c | sort -nr | head -10
        
         python3 ../emoji.py temp.txt
         echo "Emojis"
         cat emojis.txt | tr -d "[a-z]\{}()<>'" | tr ',' $'\n' | tr ':' $'\t' | sed -e '/\\200/d' -e '/\\202/d' -e '/\\2069/d' -e '/\\2066/d' -e '/\\3000/d' -e '/\\2067/d' -e '/\\2068/d' | sort -nurd | head -10
    fi
    
	# Loop around users
	for (( i=0; i<${arraylength}; i++ ));
	do

	# deletes everything but the texts
	   grep "${users[i]}" ../$source | cut -d ":" -f 4- | sed 's/ //' | sed 's'/`printf "\xe2\x80\x8e"`'//g' | sed -e 's/http[^ ]*//g' | tr '[:upper:]' '[:lower:]' | sed 's/[:.!?,'\''/\\"()^*’”…☀“]//g' | sed '/^[[:space:]]*$/d' > "${users[i]}".txt
    
    #Count the lines
        echo "Lines counter"
        wcounter[i]= wc -l "${users[i]}".txt | awk '{print $1}'
        echo ${wcounter[i]}

        #doesn't run if it's a group
        if [ ${arraylength} -lt 3 ]
        then
            #Top 10 words used
            echo "Top 10 words used"
            cat "${users[i]}".txt | sed -e 's/\.//g'  -e 's/\,//g' -e 's/ /\
/g' | tr 'A-Z' 'a-z' | grep '..' | sed -E "s/$common//g" | sed '/^[[:space:]]*$/d' | sort | uniq -c | sort -nr | head -10

            # Emoji stats
               python3 ../emoji.py "${users[i]}".txt
               echo "Emojis"
               cat emojis.txt | tr -d "[a-z]\{}()<>'" | tr ',' $'\n' | tr ':' $'\t' | sed -e '/\\200/d' -e '/\\202/d' -e '/\\2069/d' -e '/\\2066/d' -e '/\\3000/d' -e '/\\2067/d' -e '/\\2068/d' | sort -nurd | head -10
             
        fi 
        
     #Media omitted i.e. media share by this person
        echo "Omitted media lines counter"
        medialines[i]= grep -e "omitted" "${users[i]}".txt | sed 's/^.*omitted/omitted/' | uniq -c | awk '{print $1}'
        echo ${medialines[i]}
        done
        
else

	# Defines who are the people in the conversation and create users files
	awk '$1 ~ /\// {print}' ../$source | awk -F '[-:]' '{print $3}' | sed -e '/^\s/p' | grep -v '^\w' | sort | awk 'NF' | uniq | sed 's/ //' | sed '/[a-zA-Z0-9]/!d' | awk '!/Messages|left|group|added|changed/'  > users.txt

	echo "Users are:\n"
	IFS=$'\n' read -d '' -r -a users < users.txt
	cat users.txt
	#Over

	# Get the busiest top 10 days with number of texts
	awk '{print $1}' ../$source | sed -e '/^,/p' | sort | uniq -c | sort -nr | sed -e 's/,//' | head -10 > days.txt
	#Over

	# Get text freq to plot
	awk '{ print $2 }' ../$source | sed '/[0-9][0-9]:[0-9][0-9]/!d' | cut -c 1-2 | sort | uniq -c > times.txt
	#Over

	# Get first texting and last texting day
	echo "First and Last texting days"
	sed -E '/[0-9][0-9]\/|[0-9]\//!d' ../$source | sed -n -e '1p;$p' | sed 's/,.*//'
	#Over

	#An array of the users count for the for
	arraylength=$(wc -l < users.txt)
	
    if [ ${arraylength} -gt 2 ]
    then
        
        cat ../$source | cut -d ":" -f 3 | sed -e 's/ //' | sed -e 's/http[^ ]*//g' | tr '[:upper:]' '[:lower:]' | sed 's/[:.!?,'\''/\\"()^*’”…☀“]//g' > temp.txt
    
        # top 10 words used by this group.
        echo "Top 10 words used"
        cat temp.txt | cut -d ":" -f 3 | sed -e 's/http[^ ]*//g' | grep -v "<media omitted>" | sed -e 's/\.//g'  -e 's/\,//g' -e 's/ /\
/g' | tr 'A-Z' 'a-z' | grep '..' |  sed 's/[:.!?,'\''/\\"()^*’”…☀<>]//g' | sed -E "s/$common//g" | sed '/^[[:space:]]*$/d' | sort | uniq -c | sort -nr | head -10

        python3 ../emoji.py temp.txt
        echo "Emojis"
        cat emojis.txt | tr -d "[a-z]\{}()<>'" | tr ',' $'\n' | tr ':' $'\t' | sed -e '/\\200/d' -e '/\\202/d' -e '/\\2069/d' -e '/\\2066/d' -e '/\\3000/d' -e '/\\2067/d' -e '/\\2068/d' | sort -nurd | head -10
    fi
	# A loop to process each user's texts before sending them to R
	# Outcomes of this loop:
	# 1- All text lines in $user.txt
	# 2- User's lines count in wcounter[$user]
	# 3- Media omitted lines in medialines[$user]

	for (( i=0; i<${arraylength}; i++ ));
	do
    
        echo "##############################################"
	#Get the lines
        echo "Recording the file for ${users[i]}"
        grep "${users[i]}" ../$source | cut -d ":" -f 3 | sed -e 's/ //' | sed -e 's/http[^ ]*//g' | tr '[:upper:]' '[:lower:]' | sed 's/[:.!?,'\''/\\"()^*’”…☀“]//g' > "${users[i]}".txt
	
	#Count the lines
        echo "Lines counter"
        wcounter[i]= wc -l "${users[i]}".txt | awk '{print $1}'
        echo ${wcounter[i]}
	
        #doesn't run if it is a group
        if [ ${arraylength} -lt 3 ]
        then
	       #Top 10 words used
           echo "Top 10 words used"
           cat "${users[i]}".txt | grep -v "<media omitted>" | sed -e 's/\.//g'  -e 's/\,//g' -e 's/ /\
/g' | tr 'A-Z' 'a-z' | grep '..' | sed -E "s/$common//g" | sed '/^[[:space:]]*$/d' | sort | uniq -c | sort -nr | head -10

            python3 ../emoji.py "${users[i]}".txt
            echo "Emojis"
            cat emojis.txt | tr -d "[a-z]\{}()<>'" | tr ',' $'\n' | tr ':' $'\t' | sed -e '/\\200/d' -e '/\\202/d' -e '/\\2069/d' -e '/\\2066/d' -e '/\\3000/d' -e '/\\2067/d' -e '/\\2068/d' | sort -nurd | head -10
	    fi 
        
	#Media omitted i.e. media shared by this person
        echo "Omitted media lines counter"
        medialines[i]= grep -e "<media omitted>" "${users[i]}".txt | uniq -c | awk '{print $1}'
        echo ${medialines[i]}		
	done
fi

# Delete all of the files and the directory
rm -rf ../$dir