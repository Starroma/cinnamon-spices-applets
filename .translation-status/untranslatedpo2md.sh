#!/bin/bash

# Which spices? Get spices name
parentDirName=$(basename -- "$(dirname -- "$(pwd)")")
spices=$(echo "$parentDirName" | cut -f3 -d '-')
Spices=( $spices )
Spices="${Spices[@]^}" # first letter uppercase

# known language IDs and language names
knownLanguageIDs=Language-IDs.txt

spicesStatusDir=$spices-status

for spicesUUIDdir in $spicesStatusDir/*
do

	# if untranslatedDir is not empty
	untranslatedDir=$spicesUUIDdir/untranslated-po
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
			spicesUUID=$(echo "$spicesUUIDdir" | cut -f2 -d '/')
			languageNAME=$(grep "$languageID:" $knownLanguageIDs | cut -f2 -d ':')
			sed -i "1s/^/\# Untranslated Items\n\[$Spices\](..\/..\/..\/README.md) \&\#187; \[$spicesUUID\](..\/README.md) \&\#187; \*\*$languageNAME ($languageID)\*\*\n\n/" $untranslatedDir/$languageID.md
			
			# delete untranslated-po files
			rm $untranslatedDir/$languageID.po
		done
	fi

done

echo "untranslated-po files converted to md files"
echo ""
