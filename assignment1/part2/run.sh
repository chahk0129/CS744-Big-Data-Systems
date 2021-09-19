echo -n "Enter the input path and press [ENTER]:"
read input_path
echo -n "Enter the output path and press [ENTER]:"
read output_path

spark-submit part2_simple.py $input_path $output_path
