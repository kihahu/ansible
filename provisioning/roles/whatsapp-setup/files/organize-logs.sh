#!/bin/bash

# get first and last .gz

first_file=$(ls *gz|head -1)
last_file=$(ls *gz |tail -1)

echo "first file: "$first_file
echo "last file: "$last_file

extract_date_from_filename(){
    echo "$1" |cut -d '-' -f2 | cut -d '.' -f1
}

advance_date(){
    echo $(date +%Y%m%d -d "$1 + 1 day")
}

mv_file(){
    # check if month folder exists
    month=$(date --date="$1" +%b)
    year=$(date --date="$1" +%Y)
    dest_dir="$year-$month"
    if [ ! -d "$dest_dir" ]; then
        mkdir -v $dest_dir
    fi
    mv -v *$1*gz $dest_dir
}

start_date=$(extract_date_from_filename $first_file)
end_date=$(extract_date_from_filename $last_file)
echo "start date: "$start_date
echo "stop date: "$end_date
curr_date=$start_date
date_diff=$(echo $(( ($(date --date="$end_date" +%s) - $(date --date="$start_date" +%s) )/(60*60*24) )))
for i in `seq 0 $date_diff`;
do
    echo $curr_date
    month=$(date --date="$curr_date" +%m)
    echo "month: "$month
    mv_file $curr_date
    curr_date=$(advance_date $curr_date)
done
