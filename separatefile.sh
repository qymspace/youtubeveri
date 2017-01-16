#!/bin/bash
counter=1;
>"file1.txt"
>"file2.txt"
>"file3.txt"
>"file4.txt"
>"file5.txt"
>"file6.txt"
>"file7.txt"
>"file8.txt"
>"file9.txt"
>"file10.txt"


while IFS= read -r var
  do
	  if [ $counter -lt 5001 ]; then
		  
 echo $var >>"file1.txt"
 elif [ $counter -gt 5001 ] && [ $counter -lt 10001 ];then 
echo $var >>"file2.txt" 
        elif [ $counter -gt 10001 ] && [ $counter -lt 15001 ];then 
echo $var >>"file3.txt" 
elif [ $counter -gt 15001 ] && [ $counter -lt 20001 ]; then 
echo $var >>"file4.txt"
 elif [ $counter -gt 20001 ] && [ $counter -lt 25001 ]; then 
echo $var >>"file5.txt"
 elif [ $counter -gt 25001 ] && [ $counter -lt 30001 ]; then 
echo $var >>"file6.txt"
 elif [ $counter -gt 30001 ] && [ $counter -lt 35001 ]; then 
echo $var >>"file7.txt"
 elif [ $counter -gt 35001 ] && [ $counter -lt 40001 ]; then 
echo $var >>"file8.txt" 
elif [ $counter -gt 40001 ] && [ $counter -lt 45001 ]; then 
echo $var >>"file9.txt"
 else 
echo $var >>"file10.txt" 
 fi
 
counter=$((counter + 1))
 done < "ybtest2"
		     
