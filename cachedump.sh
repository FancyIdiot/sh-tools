#!/bin/bash 

# author yangjh
# cachedump all keys,sorted by the value's size 

#usage: sh cachedump -h host -p port -n num

host="127.0.0.1"
port="3306"
num=10

#extract args
while getopts 'h:p:n:' arg; do
	case $arg in
		h)
		host=$OPTARG
		;;
		p)
		port=$OPTARG		
		;;
		n)
		num=$OPTARG		
	esac
done 

#get slabs info
echo "stats slabs" | nc $host $port|\
   	grep '^STAT [0-9]\{1,\}'|\
   		awk -F ':' '{print substr($1,6)}' |\
			sort | uniq |\
				awk -F ':' '{print "stats cachedump "$1" 0"}'|\
					 nc $host $port |\
						grep "ITEM" |\
							awk -F ' ' '{print $2,substr($3,2)}' |\
								sort -n -r -k 2 -t ' ' |\
									head -n $num
									
			   	  

