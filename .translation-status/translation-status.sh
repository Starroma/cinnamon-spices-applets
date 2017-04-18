#!/bin/bash

# Convert Language IDs to Language Names
language_id_to_name () {
	case $1 in
		"ar") echo "Arabic ($1)";;
		"bg") echo "Bulgarian ($1)";;
		"ca") echo "Catalan ($1)";;
		"cs") echo "Czech ($1)";;
		"cs_CZ") echo "Czech (Czech Republic) ($1)";;
		"da") echo "Danish ($1)";;
		"de") echo "German ($1)";;
		"el") echo "Greek ($1)";;
		"en_GB") echo "English (United Kingdom) ($1)";;
		"es") echo "Spanish ($1)";;
		"es_ES") echo "Spanish (Spain) ($1)";;
		"eu") echo "Basque ($1)";;
		"fi") echo "Finnish ($1)";;
		"fr") echo "French ($1)";;
		"fr_FR") echo "French (France) ($1)";;
		"he") echo "Hebrew ($1)";;
		"hr") echo "Croatian ($1)";;
		"hu") echo "Hungarian ($1)";;
		"is") echo "Icelandic ($1)";;
		"it") echo "Italian ($1)";;
		"it_IT") echo "Italian (Italy) ($1)";;
		"ja") echo "Japanese ($1)";;
		"ja_JP") echo "Japanese (Japan) ($1)";;
		"ko") echo "Korean ($1)";;
		"ku") echo "Kurdish ($1)";;
		"lt") echo "Lithuanian ($1)";;
		"lv") echo "Latvian ($1)";;
		"nb") echo "Norwegian Bokmal ($1)";;
		"nl") echo "Dutch ($1)";;
		"pl") echo "Polish ($1)";;
		"pt") echo "Portuguese ($1)";;
		"pt_BR") echo "Portuguese (Brazil) ($1)";;
		"pt_PT") echo "Portuguese (Portugal) ($1)";;
		"ro") echo "Romanian ($1)";;
		"ru") echo "Russian ($1)";;
		"ru_RU") echo "Russian (Russia) ($1)";;
		"sk") echo "Slovak ($1)";;
		"sl") echo "Slovenian ($1)";;
		"sr") echo "Serbian ($1)";;
		"sv") echo "Swedish ($1)";;
		"tr") echo "Turkish ($1)";;
		"uk") echo "Ukrainian ($1)";;
		"vi") echo "Vietnamese ($1)";;
		"zh_CN") echo "Chinese (Simplified) ($1)";;
		"zh_TW") echo "Chinese (Traditional) ($1)";;
		*) echo "UNKNOWN ($1)";;
	esac
}

# (Current) Directory, where the translations stati are stored
transStatusDir=${PWD##*/}

# Directories for temporary files
TMPpoDirectories=po-directories.tmp
TMPuuidOfTranslatableApplets=uuid-of-translatable-applets.tmp
TMPpoFiles=po-files.tmp

# Markdown file, where the table with the translation status is stored
README=README.md
READMEtmp=README.tmp

# go to parent directory
cd ..

# create a list of all translatable applets
find . -not -path "./$transStatusDir*" -type d -name "po" | sort | cut -f2 -d '/' > $transStatusDir/$TMPuuidOfTranslatableApplets
# and a list with paths to those po directories
find . -not -path "./$transStatusDir*" -type d -name "po" | sort > $transStatusDir/$TMPpoDirectories

# create directories for every translatable applet in $transStatusDir and copy .po and .pot files to these directories
while read -r poDirs && read -r appletUUID <&3;     
do
	#echo -e "$poDirs -> $appletUUID"
	mkdir -p $transStatusDir/$appletUUID/po
	cp $poDirs/*.pot $transStatusDir/$appletUUID/po
	cp $poDirs/*.po $transStatusDir/$appletUUID/po
done < $transStatusDir/$TMPpoDirectories 3<$transStatusDir/$TMPuuidOfTranslatableApplets



##### variable to store UNKOWN language IDs
unknownLanguageIDs=""

# create README file with translation status table for every applet
cd $transStatusDir

while read appletUUID
do
	# create list with languageIDs, to which this applet was already translated to
	cd $appletUUID
	find ./po -type f -name "*.po" | sort | cut -f3 -d '/' > $TMPpoFiles
	
	# create folder for untranslated Strings
	untranslatedPO=untranslated-po
	mkdir -p $untranslatedPO
	
	# create folder for unfuzzy Strings
	unfuzzyPO=unfuzzy-po
	mkdir -p $unfuzzyPO
	
	# create HEADER in README file: title and markdown table
	echo "# Translation status of $appletUUID" > $README
	echo "" >> $README
	echo "Language | Status | Untranslated" >> $README
	echo "---------|:------:|:-----------:" >> $README
	numberOfLinesInHEADER=4
	
	# fill table with translations status infos
	while read languagePoFile
	do
		# update po file from pot file
		msgmerge --no-fuzzy-matching --update --backup=off po/$languagePoFile po/*.pot
		
		# remove fuzzy Strings (i.e. count fuzzy translated strings as untranslated) (NOTE: fails in LM <= 17.3)
		#!msgattrib --clear-fuzzy --empty po/$languagePoFile -o $unfuzzyPO/$languagePoFile
		
		# extract untranslated Strings
		if [ "$(ls -A $unfuzzyPO)" ]; then # check if last command failed, i.e. if $unfuzzyPO is empty
			msgattrib --untranslated $unfuzzyPO/$languagePoFile -o $untranslatedPO/$languagePoFile
		else # this is a backup if this script is used with LM <= 17.3 (fuzzy strings count as translated) 
			msgattrib --untranslated po/$languagePoFile -o $untranslatedPO/$languagePoFile
		fi
		
		# get language name from ID
		languageID=$(echo $languagePoFile | cut -f1 -d '.')
		languageNAME=$(language_id_to_name $languageID)
		
		##### Check for UNKOWN language IDs
		if [ "$languageNAME" == "UNKNOWN ($languageID)" ]
		then
			unknownLanguageIDs="$unknownLanguageIDs $languageID"
		fi
		
		# if no untranslated String exist
		if [ ! -f $untranslatedPO/$languagePoFile ]; then
    		echo "$languageNAME | ![100%](http://progressed.io/bar/100) | 0" >> $README
    	else
    		# count untranslated Strings
    		untranslatedNumber=$(grep "msgid " $untranslatedPO/$languagePoFile | wc -l)
    		untranslatedNumber=$[$untranslatedNumber-1]
    		# count translated String
    		translatedNumber=$(grep "msgid " po/$languagePoFile | wc -l)
    		translatedNumber=$[$translatedNumber-1]
    		# calculate percentage
			percentage=`echo "scale=2; ($translatedNumber - $untranslatedNumber) * 100 / $translatedNumber" | bc`
			percentage=$(python -c "zahl=round($percentage); print zahl" | cut -f1 -d '.')  
			# fill table with calculated infos
    		echo "$languageNAME | ![$percentage%](http://progressed.io/bar/$percentage) | $untranslatedNumber" >> $README
		fi
	done < $TMPpoFiles
	
	
	# sort README but not the HEADER of the README
	numberOfLinesInHEADERplus1=$[$numbersOfLinesInHEADER+1]
	(head -n $numberOfLinesInHEADER $README && tail -n +$numberOfLinesInHEADERplus1 $README | sort) > $READMEtmp
	mv $READMEtmp $README
	
	# remove tmp files and directories
	rm -r $unfuzzyPO
	rm *.tmp
	
	cd ..
done < $TMPuuidOfTranslatableApplets

##### print UNKNOWN language IDs
if [ "$unknownLanguageIDs" == "" ]
then
	echo "UNKNOWN Language IDs: NONE"
else
	echo "UNKNOWN Language IDs: $unknownLanguageIDs"
fi

# remove tmp files
rm *.tmp

#echo "THE END: Please press any button!"
#read waiting
