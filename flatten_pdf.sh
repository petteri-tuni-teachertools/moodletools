# ---------------------------------------------------------------------------
# Find all the PDF files under directory ARG1 and copy them to directory ARG2
# Directory ARG1 can contain subdirectories ... the program will "flatten" the placement of the PDF files
# Directory ARG2 have to exist
# Example:
# sh flatten_pdf.sh projects dest_proj
# -------------------------------------------------------

shfile=run`date '+%FT%h%m%s.sh'`
export x=0
touch $2/report.txt
find $1 -name "*.pdf"  | while IFS= read -r line; do export x=`expr $x + 1` ; echo "cp \"$line\" $2/$x.pdf"; echo "$x ### $line" >> $2/report.txt;  done > runthis.sh
sh runthis.sh
cp runthis.sh $2/.

