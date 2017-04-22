#!/bin/bash

# directory where the language stati are stored
languageStatusDir=language-status

# check if language-status directory exists
if [ ! -d $languageStatusDir ]; then
	echo "" >> ScriptPROBLEMS.txt
	echo "Execute language-status.sh first" >> ScriptPROBLEMS.txt
	exit
fi


# known language IDs and language names
knownLanguageIDs=Language-IDs.txt
# sort language IDs by Name and save in a tmp file
TMPsortedLanguageIDs=sorted-Language-IDs.tmp
sort -t\: -k2 $knownLanguageIDs > $TMPsortedLanguageIDs

# file where to store the translation status
README=README.md

# create HEADER of markdown table
echo "# Translation status by language" > $README
echo "**Applets**" >> $README
echo "" >> $README
echo "Language | ID | Status | Untranslated" >> $README
echo "---------|:--:|:------:|:-----------:" >> $README

while read languageIDName
do
	# get known language IDs and names
	languageID=$(echo $languageIDName | cut -f1 -d ':')
	languageNAME=$(echo $languageIDName | cut -f2 -d ':')
	
	languageStatistic=$(grep "Overall statistics:" $languageStatusDir/$languageID.md)
	# remove stars *
	languageStatistic=$(echo "${languageStatistic//\*}")
	languageStatistic=$(echo "$languageStatistic" | cut -f3,4 -d '|')
	
	echo "[$languageNAME]($languageStatusDir/$languageID.md) | $languageID | $languageStatistic" >> $README
	
done < $TMPsortedLanguageIDs

# remove tmp files
rm $TMPsortedLanguageIDs

#echo "THE END: Please press any button!"
#read waiting
