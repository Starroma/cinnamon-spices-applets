#!/bin/bash


# known language IDs and language names
knownLanguageIDs=Language-IDs.txt

appletStatusDir=applet-status

for appletUUIDdir in $appletStatusDir/*
do

	# if untranslatedDir is not empty
	untranslatedDir=$appletUUIDdir/untranslated-po
	if [ "$(ls -A $untranslatedDir)" ]; then
		for poFile in $untranslatedDir/*.po
		do
			# get languageID
			languageID=$(echo "$poFile" | cut -f4 -d '/' | cut -f1 -d '.')
			(msgattrib --no-wrap $poFile | grep "msgid" | nl -v 0 -n rn -w 8 -b p"msgid ") > $untranslatedDir/$languageID.md
			sed -i '/msgid ""/d' $untranslatedDir/$languageID.md 
			sed -i 's/msgid //g' $untranslatedDir/$languageID.md
			sed -i 's/"//g' $untranslatedDir/$languageID.md
			sed -i 's/msgid_plural/  /g' $untranslatedDir/$languageID.md
			
			# add HEADER
			appletUUID=$(echo "$appletUUIDdir" | cut -f2 -d '/')
			languageNAME=$(grep "$languageID:" $knownLanguageIDs | cut -f2 -d ':')
			sed -i "1s/^/\# Untranslated Items\n\[Applets\](..\/..\/..\/README.md) \&\#187; \[$appletUUID\](..\/README.md) \&\#187; $languageNAME ($languageID)\n\n/" $untranslatedDir/$languageID.md
			
			# delete untranslated-po files
			rm $untranslatedDir/$languageID.po
		done
	fi

done

echo "untranslated-po files converted to md files"
echo ""
