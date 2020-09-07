#!/bin/bash
### Recent files window- by PPC, 13/1/2020, for use with antiX and MX-fluxbox
#GPL licence- do what you want with this, but please keep lines about the author, date and licence
# works on any system with yad and xdg-open installed, optionally: exo-open (see exceptions to the general rule, when launching files, near the end.
# https://pastebin.com/fSDPR9E1
#Parse the file that stores the recent used files, send output to recent0.txt
awk -F"file://|\" " '/file:\/\// {print $2}' ~/.local/share/recently-used.xbel > ~/.recent0.txt
#reverse contents order, so last file comes first, and so on...
tac ~/.recent0.txt > ~/.recent.txt
#function to decode file name (from %20 instead of spaces, etc, from https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
# Use a undecorated Yad window to select file to be executed
EXEC=$(yad --title="Recent files" --undecorated --width=450 --height=400 --center --separator=" " --list  --column=" Recent Files:"  < ~/.recent.txt)
#do decoding on the file name, just in case it has spaces or special characters that come up as %xx
decoded=$(urldecode $EXEC)
# general rule: open selected file with the aplication used for its file type
openwith=xdg-open 
###Exceptions to the general rule: LibreOffice Writer ".odt" files - check extension and  force it to open with lowriter; also more exceptions: like open ".sh" files for edition and run ".desktop" files instead of editing them
check=$(echo -n $EXEC | tail -c 3)
	if [ "$check" == "odt" ]; then openwith=lowriter ; fi  #this solves bug opening odt files with spaces
	if [ "$check" == ".sh" ]; then openwith=exo-open ; fi
	if [ "$check" == "top" ]; then openwith=exo-open ; fi
#add quotes to the file name, just in case it has spaces
EXEC2="'"$decoded"'"
#launch the selected file
run=$(echo $openwith $EXEC2)
eval $run
