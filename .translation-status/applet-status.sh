#!/bin/bash

# known language IDs and language names
knownLanguageIDs=Language-IDs.txt

# Convert Language IDs to Language Names
language_id_to_name () {
	case $1 in
		"ar") echo "Arabic";;
		"bg") echo "Bulgarian";;
		"ca") echo "Catalan";;
		"cs") echo "Czech";;
		"cs_CZ") echo "Czech (Czech Republic)";;
		"da") echo "Danish";;
		"de") echo "German";;
		"el") echo "Greek";;
		"en_GB") echo "English (United Kingdom)";;
		"es") echo "Spanish";;
		"es_ES") echo "Spanish (Spain)";;
		"eu") echo "Basque";;
		"fi") echo "Finnish";;
		"fr") echo "French";;
		"fr_FR") echo "French (France)";;
		"he") echo "Hebrew";;
		"hr") echo "Croatian";;
		"hu") echo "Hungarian";;
		"is") echo "Icelandic";;
		"it") echo "Italian";;
		"it_IT") echo "Italian (Italy)";;
		"ja") echo "Japanese";;
		"ja_JP") echo "Japanese (Japan)";;
		"ko") echo "Korean";;
		"ku") echo "Kurdish";;
		"lt") echo "Lithuanian";;
		"lv") echo "Latvian";;
		"nb") echo "Norwegian Bokmal";;
		"nl") echo "Dutch";;
		"pl") echo "Polish";;
		"pt") echo "Portuguese";;
		"pt_BR") echo "Portuguese (Brazil)";;
		"pt_PT") echo "Portuguese (Portugal)";;
		"ro") echo "Romanian";;
		"ru") echo "Russian";;
		"ru_RU") echo "Russian (Russia)";;
		"sk") echo "Slovak";;
		"sl") echo "Slovenian";;
		"sr") echo "Serbian";;
		"sv") echo "Swedish";;
		"tr") echo "Turkish";;
		"uk") echo "Ukrainian";;
		"vi") echo "Vietnamese";;
		"zh_CN") echo "Chinese (Simplified)";;
		"zh_TW") echo "Chinese (Traditional)";;
		*) echo "UNKNOWN";;
	esac
}

# (Current) Directory, where the translations stati are stored
transStatusDir=${PWD##*/}

# create directory for applet status
appletStatusDir=applet-status
mkdir -p $appletStatusDir
appletStatusDir=$transStatusDir/$appletStatusDir

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
find . -not -path "./$appletStatusDir*" -type d -name "po" | sort | cut -f2 -d '/' > $appletStatusDir/$TMPuuidOfTranslatableApplets
# and a list with paths to those po directories
find . -not -path "./$appletStatusDir*" -type d -name "po" | sort > $appletStatusDir/$TMPpoDirectories

# create directories for every translatable applet in $appletStatusDir and copy .po and .pot files to these directories
while read -r poDirs && read -r appletUUID <&3;     
do
	#echo -e "$poDirs -> $appletUUID"
	mkdir -p $appletStatusDir/$appletUUID/po
	cp $poDirs/*.pot $appletStatusDir/$appletUUID/po
	cp $poDirs/*.po $appletStatusDir/$appletUUID/po
done < $appletStatusDir/$TMPpoDirectories 3<$appletStatusDir/$TMPuuidOfTranslatableApplets



##### variable to store UNKOWN language IDs
#unknownLanguageIDs=""

# create README file with translation status table for every applet
cd $appletStatusDir

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
	echo "Language | ID | Status | Untranslated" >> $README
	echo "---------|:--:|:------:|:-----------:" >> $README
	numberOfLinesInHEADER=$(wc -l README.md | cut -f1 -d " ")
	
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
		#languageNAME=$(language_id_to_name $languageID)
		languageNAME=$(grep "$languageID:" ../../$knownLanguageIDs | cut -f2 -d ':')
		
		##### Check for UNKOWN language IDs
		if [ "$languageNAME" == "" ]
		then
			languageNAME="UNKNOWN"
			unknownLanguageIDs="$unknownLanguageIDs"$'\n'"$appletUUID: $languageID"
		fi
		
		# if no untranslated String exist
		if [ ! -f $untranslatedPO/$languagePoFile ]; then
    		echo "$languageNAME | $languageID | ![100%](http://progressed.io/bar/100) | 0" >> $README
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
    		echo "$languageNAME | $languageID | ![$percentage%](http://progressed.io/bar/$percentage) | $untranslatedNumber" >> $README
		fi
	done < $TMPpoFiles
	
	
	# sort README but not the HEADER of the README
	numberOfLinesInHEADERplus1=$[$numberOfLinesInHEADER+1]
	(head -n $numberOfLinesInHEADER $README && tail -n +$numberOfLinesInHEADERplus1 $README | sort) > $READMEtmp
	mv $READMEtmp $README
	
	# remove tmp files and directories
	rm -r $unfuzzyPO
	rm *.tmp
	
	cd ..
done < $TMPuuidOfTranslatableApplets

##### print UNKNOWN language IDs
echo ""
if [ "$unknownLanguageIDs" == "" ]
then
	echo "UNKNOWN Language IDs: NONE"
else
	echo "UNKNOWN Language IDs: $unknownLanguageIDs"
	echo "UNKNOWN Language IDs: $unknownLanguageIDs" > ../ScriptPROBLEMS.txt
fi

# remove tmp files
rm *.tmp

#echo ""
#echo "THE END: Please press any button!"
#read waiting
