# ---------------------------------------------------------------------------
# Find all the HTML files under directory ARG1 and copy them to directory ARG2
# Directory ARG1 can contain subdirectories ... the program will "flatten" the placement of the HTML files
# Directory ARG2 have to exist
# Example:
# sh flatten_pdf.sh projects dest_proj
# -------------------------------------------------------

shfile=run`date '+%FT%h%m%s.sh'`
export x=0
touch $2/report.txt
find $1 -name "*.html"  | while IFS= read -r line; do export x=`expr $x + 1` ; export y=$(printf "%02d" $x); echo "cp \"$line\" $2/$y.html"; echo "$y ### $line" >> $2/report_$2.txt; done > runthis.sh
sh runthis.sh
cp runthis.sh $2/.

