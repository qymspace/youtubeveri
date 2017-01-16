#!/bin/bash
echo "Beggining verification of youtube links"
echo "START!!"


#set a few variables to work with
var='' #link of youtube page
filename=$1 #first argument, a file containing all the links

fileforoutput="youtubeoutput.txt" #file to output link contents for processing
> $fileforoutput		#clear the file 

final=$2 #second argument, a file to output link results from $filename
# > $final #clear the file
touch $final
vf="verifile.txt"
> $vf


threshSubs=100;  #the number of subcribers to determine if fake or not
threshViewsPerVid=100;	#the number of views per video to determine if fake or not
threshNoofVid=15;	#the number of videos to determine if fake or not. This is based on the videos on the front page.




#Store the result of a previous check to determine if to proceed with the next check
touch result.txt
echo "false" > result.txt
echo "" > testfinal.txt






#check using verified title by youtube

function byIsVerified(){
	 grep -C 5 "branded-page-header-title" $fileforoutput > $vf
	 grep -q "Verified" $vf
	 
	 if [ $? -eq 0 ]; then
		
	 printf $var >> $final	
	 printf "	Real" >> $final
	 printf "	Verified by youtube\n" >> $final
	 echo "true" > result.txt
	 
fi
}

function bySubscribers(){
	subscribers=$(grep  "yt-subscription-button-subscriber-count-branded-horizontal" $fileforoutput | egrep -o 'aria-label="[0-9]+,?[0-9]+\ssubscribers"' | egrep -o '[0-9]+,?[0-9]+'| tr -d ,)
	echo $var >> testfinal.txt
	echo $subscribers >> testfinal.txt
	# if [[ $subscribers =~ '^[0-9]+$' ]]; then
		# echo "subscribers is a digit" >> testfinal.txt
	if [ "$subscribers" -gt "$threshSubs" ]; then
		echo "subscribers are many" >> testfinal.txt
		printf $var >>$final;
		printf "	Real" >> $final;
		printf "	Subscibers more than "$threshSubs"\n" >> $final
		echo "true" > result.txt
	# fi
	fi
}

function byNoOfVideos(){
	videos=$(grep -o 'Duration:' $fileforoutput | wc -l)
	# if [[ $videos =~ '^[0-9]+$' ]]; then
	if [ "$videos" -gt "$threshNoofVid" ]; then
		printf $var >>$final;
		printf "	Real" >> $final;
		printf "	Number of videos more than "$threshNoofVid"\n" >> $final
		echo "true" > result.txt
# fi
fi
}

function ByViewsPerVideo(){
	views=$(grep "yt-lockup-meta-info" $fileforoutput | egrep -o '<li>.*views' |tr -d , | egrep -o '[0-9]+' | awk '{ SUM += $1} END { print SUM }')
	videos=$(grep "yt-lockup-meta-info" $fileforoutput | egrep -o '<li>.*views' |tr -d , | egrep -o '[0-9]+' | wc -l)
	# if [[ $views =~ '^[0-9]+$' ]]; then
	if [ "$views" -gt "$threshViewsPerVid" ]; then
		echo $var >> $final
		echo "Real" >> $final
		echo "Number of views per video more than "$threshViewsPerVid"\n" >> $final
		echo "true" > result.txt
	# fi
	fi
}


cat $filename | while IFS= read -r var 
do
	curl $var > $fileforoutput
	if [ $? -ne 0 ]; then
		printf $var >> $final
		printf "	Error occured\n" >> $final
		sed -i '1 d' "$filename"
		continue;
	fi

	byIsVerified	
	exec 3< result.txt
	read -u  3 aaresult
	exec 3>&-
	if [ "$aaresult" == "true" ]; then
		echo "false" > result.txt
		sed -i '1 d' "$filename"
		continue
	fi
	bySubscribers

		exec 3< result.txt
		read -u  3 aaresult
		exec 3>&-

	if [ "$aaresult" == "true" ]; then
		echo "false" > result.txt
		sed -i '1 d' "$filename"
		continue
	fi
	byNoOfVideos

		exec 3< result.txt
	read -u  3 aaresult
	exec 3>&-

		if [ "$aaresult" == "true" ]; then
			echo "false" > result.txt
			sed -i '1 d' "$filename"
			continue
	else
		printf $var >> $final
		printf "	Fake" >> $final
		printf "	Videos less then "$threshNoofVid"\n" >> $final

		sed -i '1 d' "$filename"
		continue
	fi
	ByViewsPerVideo
	
		exec 3< result.txt
	read -u  3 aaresult
	exec 3>&-

	if [ "$aaresult" == "true" ]; then
		echo "false" > result.txt
		sed -i '1 d' $filename
		continue
	fi
	

	printf $var >> $final
	printf "	Fake" >> $final
	printf "Not verified by youtube, very few subscribers, very few videos, very few view per video\n">> $final
	sed -i '1 d' "$filename"
	# echo "false" > result.txt
done 
