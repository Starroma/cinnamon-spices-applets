#!/bin/bash

rm -r applet-status
rm -r language-status
rm README.md

# first execute applet-status script
./applet-status.sh

# next execute language-status script, because it depends on outputs of applet-status script
./language-status.sh

# next execute translation-status script, because it depends on outputs of language-status script
./translation-status.sh
