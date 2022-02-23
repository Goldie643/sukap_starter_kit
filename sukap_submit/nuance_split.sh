# Converts a .nuance file into lots of little ones
# 1st arg is in_file to pull from

max_n_files=1000

n_in=$(grep -c "begin" $1)
begin_line=$(awk '/begin/{ print NR; exit }' $1)
end_line=$(awk '/end/{ print NR; exit }' $1)
n_lines_per_vtx=$(( $end_line - $begin_line + 1 ))

echo "Factors of N events in file (up to ${max_n_files}):"

# Print the factors of the events in file up to max_n_files
for i in $(seq 1 $n_in)
do
    if [ $(( n_in % i )) == 0 ]; then echo $i; fi
    if [ $i -gt $max_n_files ]; then break; fi
done

echo "Choose N files (must be a factor)"

read n_files

# N events in each file
n_per_file=$(( n_in / n_files ))
n_digits=`echo "${#n_files}"`

echo "Events per file: ${n_per_file}"

out_prefix=${1%.nuance}

for ((i=1; i <= $n_files; i++))
do
    echo -ne "Processing file $i of $n_files"\\r
    out_file=`printf "%0${n_digits}d" $i`
    out_file="${out_prefix}_${out_file}.nuance"

    # Setting the first and last line to pull from the file
    # The * 4 is because each event takes up 4 lines
    first_line=$(( ((i-1) * n_per_file * n_lines_per_vtx) + 1 ))
    last_line=$(( (i * n_per_file * n_lines_per_vtx) ))

    # Using sed to pull between first_line and last_line
    sed -n "${first_line},${last_line}p;${last_line}q" $1 > $out_file
    echo "stop" >> $out_file
done

echo ""
echo "Done"
