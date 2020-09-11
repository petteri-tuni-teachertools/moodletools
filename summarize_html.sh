# -------------------------------------------------------
# Take all the HTML files and put them to new file - xxx

# Example:
# sh summarize.sh "summary/sub_all.html"
# -------------------------------------------------------

newfile=$1
echo Summarize and put to file: $newfile
sleep 5

touch $newfile
ls *.html | while IFS= read -r line; do echo "<p><hr />------ START NEW ---------</p>" >> $newfile; echo "" >> $newfile;   cat "$line" >> $newfile; echo "" >> $newfile; done

# -------------------------------------------------------
