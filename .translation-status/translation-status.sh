#!/bin/bash


# language abbreviation to language name function
get_language () {
	case $1 in
		"ar") echo "Arabic ($1)";;
		"bg") echo "Bulgarian ($1)";;
		"ca") echo "Catalan ($1)";;
		"cs") echo "Czech ($1)";;
		"cs_CZ") echo "Czech (Czech Republic) ($1)";;
		"da") echo "Danish ($1)";;
		"de") echo "German ($1)";;
		"el") echo "Greek ($1)";;
		"es") echo "Spanish ($1)";;
		"eu") echo "Basque ($1)";;
		"fr") echo "French ($1)";;
		"hr") echo "Croatian ($1)";;
		"ku") echo "Kurdish ($1)";;
		"pt") echo "Portuguese ($1)";;
		"ru") echo "Russian ($1)";;
		"sr") echo "Serbian ($1)";;
		"zh_CN") echo "Chinese (Simplified) ($1)";;
		"zh_TW") echo "Chinese (Traditional) ($1)";;
		*) echo "UNKNOWN ($1)";;
	esac
}

# directories
transStatusDir=${PWD##*/}
newTranslations=$transStatusDir/new-translations.tmp
poDirectories=$transStatusDir/po-directories.tmp
namesOfTranslatableApplets=names-of-translatable-applets.tmp
README=README.md
READMEtmp=README.tmp

poFiles=po-files.tmp
poFilesLanguage=po-files-language.tmp

# go to parent directory
cd ..

# create a list of all translatable applets
find . -not -path "./$transStatusDir*" -type d -name "po" | sort | cut -f2 -d '/' > $transStatusDir/$namesOfTranslatableApplets
# and a path-list to their po directories
find . -not -path "./$transStatusDir*" -type d -name "po" | sort > $poDirectories

#  create directory for every translatable applet
while read appletName
do
	mkdir -p $transStatusDir/$appletName/po
done < $transStatusDir/$namesOfTranslatableApplets

# copy pot files these directories
while read -r poDirs && read -r appletName <&3;     
do
	#echo -e "$poDirs -> $appletName"
	cp $poDirs/*.pot $transStatusDir/$appletName/po
	cp $poDirs/*.po $transStatusDir/$appletName/po
done < $poDirectories 3<$transStatusDir/$namesOfTranslatableApplets




# create README files with translation status
cd $transStatusDir

while read appletName
do
	# create list of available languages
	cd $appletName
	find ./po -type f -name "*.po" | sort | cut -f3 -d '/' > $poFiles
	
	# create folder for untranslated Strings
	mkdir -p untranslated
	
	# create HEADER and a table in a README file
	echo "# Translation status of $appletName" > $README
	echo "" >> $README
	echo "Language | Status | Untranslated" >> $README
	echo "---------|:------:|:-----------:" >> $README
	
	# fill table with translations status infos
	while read languageFile
	do
		# update po file from pot file
		msgmerge --no-fuzzy-matching --update --backup=off po/$languageFile po/*.pot
		
		# extract untranslated Strings
		msgattrib --untranslated po/$languageFile -o untranslated/$languageFile
		
		# get language name
		languageName=$(echo $languageFile | cut -f1 -d '.')
		language=$(get_language $languageName)
		
		# if no untranslated String exist
		if [ ! -f untranslated/$languageFile ]; then
    		echo "$language | ![100%](http://progressed.io/bar/100) | 0" >> $README
    	else
    		# count untranslated Strings
    		untranslatedNumber=$(grep "msgid " untranslated/$languageFile | wc -l)
    		untranslatedNumber=$[$untranslatedNumber-1]
    		# count translated String
    		translatedNumber=$(grep "msgid " po/$languageFile | wc -l)
    		translatedNumber=$[$translatedNumber-1]
    		# calculate percentage
			percentage=`echo "scale=2; ($translatedNumber - $untranslatedNumber) * 100 / $translatedNumber" | bc`
			percentage=$(python -c "zahl=round($percentage); print zahl" | cut -f1 -d '.')  
			# fill table with calculated infos
    		echo "$language | ![$percentage%](http://progressed.io/bar/$percentage) | $untranslatedNumber" >> $README
		fi
	done < $poFiles
	
	# sort README
	(head -n 4 $README && tail -n +5 $README | sort) > $READMEtmp
	mv $READMEtmp $README
	
	rm *.tmp
	
	cd ..
done < $namesOfTranslatableApplets

rm *.tmp
