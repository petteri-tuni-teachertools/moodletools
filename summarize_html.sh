# -------------------------------------------------------
# Take all the HTML files and put them to new file - xxx

# Example:
# sh summarize.sh report_dir
# -------------------------------------------------------

newdir=$1
newfile=$1/TMPFILE
echo Summarize and put to file: $1/all.html
sleep 5
export x=0
touch $newfile
ls $1/*.html | while IFS= read -r line; do export x=`expr $x + 1` ; echo "<p><hr />------ START NEW ($line) ---------</p>" >> $newfile; echo "" >> $newfile;   cat "$line" >> $newfile; echo "" >> $newfile; done

mv $newfile $1/all_$1.html

# -------------------------------------------------------
