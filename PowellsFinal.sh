#!/bin/bash
# Brooks, Erika
# IS301 - WOU Fall'23

# this script takes data scraped from a Powell's City of Books website found at
# https://www.powells.com/used?category=Young-Adult&mpp=50
# and extracts title, author, category, and pricing (both new and used) and
# reformats the data into CSV format

# create the header row
echo "Title,Author,Category,PriceNew,PriceUsed"

# loop through all the lines in the input file and ignore or assign to a variable
while IFS= read line; do lineNum=$(( $lineNum + 1 ))
        [[ "$( grep -E '^ *Sort By' <<<"$line" )" ]] && continue  # skip nnecessary header
        [[ "$( grep -E '^ *Grid List' <<<"$line" )" ]] && continue # skip nnecessary header
        line=$(sed 's/^ *//;s/ *$//' <<<"$line" ) # head/tail whitespace removed

        [[ ! "$title" ]] &&  title="$line" && continue # if no title yet exists, use this line
        [[ ! "$title2" ]] && title2="$line" && continue
        if [[ ! "$author" && "$( grep -E '^by ' <<<"$line" )" ]]; then author="$line" && continue; fi
        if [[ ! "$category" ]]; then category="$line" && continue; fi
        if [[ ! "$priceNew" && "$( grep '^\$' <<<"$line" )" ]]; then priceNew="$line" && continue; fi
        if [[ ! "$priceUsed" && "$( grep '^\$' <<<"$line")" ]]; then priceUsed="$line"; else priceUsed="n/a";fi

        author="${author//,/\;}" # change any commas in author to semicolons
        author="${author/by /}" # remove initial 'by ' from the author line
        printf '%s\n' "${title},${author},${category},${priceNew},${priceUsed}"; # print the results
       # reset the variables for the next pass
       title=""; title2="";  author=""; category=""; priceNew=""; priceUsed=""

done
