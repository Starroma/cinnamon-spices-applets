#!/bin/bash

# check if applet-status directory exists
if [ ! -d applet-status ]; then
	echo "" >> ScriptPROBLEMS.txt
	echo "Execute applet-status.sh first" >> ScriptPROBLEMS.txt
	exit
fi

# directory where to store the language stati
languageStatusDir=language-status
mkdir -p $languageStatusDir

# load UUIDs of translatable applets in tmp file
appletStatusDir=applet-status
TMPuuidOfTranslatableApplets=uuid-of-translatable-applets.tmp
ls $appletStatusDir > $TMPuuidOfTranslatableApplets

# filename where the translation status of applets is stored
appletStatusREADME=README.md

# known language IDs and language names
knownLanguageIDs=Language-IDs.txt

# sort language IDs by Name and save in a tmp file
#TMPsortedLanguageIDs=sorted-Language-IDs.tmp
#sort -t\: -k2 $knownLanguageIDs > $TMPsortedLanguageIDs


echo "Create translation status for:"
while read languageIDName
do

	languageID=$(echo $languageIDName | cut -f1 -d ':')
	languageNAME=$(echo $languageIDName | cut -f2 -d ':')
	
	echo "...$languageNAME ($languageID)"
	# create HEADER in markdown table for each language
	echo "# Translation status of $languageNAME ($languageID)" > $languageStatusDir/$languageID.md
	echo "" >> $languageStatusDir/$languageID.md
	echo "Applet UUID | Length | Status | Untranslated" >> $languageStatusDir/$languageID.md
	echo "------------|:------:|:------:|:-----------:" >> $languageStatusDir/$languageID.md

	untranslatedSum=0
	translatableSum=0
	while read appletUUID     
	do
		# look in appletStatusREADME file for number of untranslated Strings
		untranslated=$(grep " $languageID " $appletStatusDir/$appletUUID/$appletStatusREADME | cut -f4 -d '|')
		# count number of translatable Strings
		translatableLength=$(grep "msgid " $appletStatusDir/$appletUUID/po/*.pot | wc -l)
		translatableLength=$[$translatableLength-1]
		translatableSum=$[$translatableSum+$translatableLength]
		
		# if language does not exists in appletStatusREADME, it is not translated at all
		if [ "$untranslated" == "" ]; then
			untranslated=$translatableLength
		fi
	
		# Sum of untranslated Strings
		untranslatedSum=$[$untranslatedSum + $untranslated]
		
		# calculate percentage translated
		percentageTranslated=`echo "scale=2; ($translatableLength - $untranslated) * 100 / $translatableLength" | bc`
		percentageTranslated=$(python -c "zahl=round($percentageTranslated); print zahl" | cut -f1 -d '.')  
	
		# write calculated infos in markdown table
		echo "$appletUUID | $translatableLength | ![$percentageTranslated%](http://progressed.io/bar/$percentageTranslated) | $untranslated" >> $languageStatusDir/$languageID.md
	done < $TMPuuidOfTranslatableApplets
	
	# calculate percentage translated
	percentageTranslatedSum=`echo "scale=2; ($translatableSum - $untranslatedSum) * 100 / $translatableSum" | bc`
	percentageTranslatedSum=$(python -c "zahl=round($percentageTranslatedSum); print zahl" | cut -f1 -d '.')  

	# Overall Statistics at the end of markdown table
	echo "**Overall statistics:** | **$translatableSum** | ![$percentageTranslatedSum%](http://progressed.io/bar/$percentageTranslatedSum) | **$untranslatedSum**" >> $languageStatusDir/$languageID.md 

done < $knownLanguageIDs


rm $TMPuuidOfTranslatableApplets

#echo ""
#echo "THE END: Please press any button!"
#read waiting
