#!/bin/bash
# Ensuring the shell is run in Bash


# Checking if exactly two filenames are provided as arguments
if (( $# != 2 )); then

    # $# returns the number of arguments sent to the bash script
    # If two file names are not shared to the script, we need to prompt the user to ensure format correctness
    echo "Invalid number of parameters"
    echo "Ensure the Format: $0 <input_file> <output_file>"
    exit 2  # exiting the script with code 2 (Invalid Inputs)
fi



# Declaring two variables to store the input file locations to the script
# $i is the i-th input to the script, $0 is the script itself


input_file="$1"
output_file="$2"


# Checking if input file exists
if [ ! -f "$input_file" ]; then
    echo "Input file '$input_file' not found."
    echo "Ensure the Format: $0 <input_file> <output_file>"
    exit 2  # exiting the script with code 2 (Invalid Inputs)
fi


# Building the structure of the output file as per the sample output.txt file
echo "---" >> "$output_file"
echo "Unique cities in the given data file:" >> "$output_file"

# If the output file does not exist a new one will get generated


# awk -F',' '!seen[$3]++ {print $3}' "$input_file" >> "$output_file"


# Finding unique cities from input file 
awk -F',' 'NR > 1 {print $3}' "$input_file" | sort -u >> "$output_file"

# -F',' sets the delimiter as comma which is needed for reading csv files
# print $3 selects the third column of the data base
# NR > 1 makes the script to skip the header (first row) row
# "$input_file" tells the script the file location where the reading is to be done
# "$output_file" tells the script the file location where the writing is to be done
# sort is the built in command for sorting data, sort -u is the sorting unique command which itself rejects all the duplicate city names


# Structure
echo "" >> "$output_file"       # New Line
echo "---" >> "$output_file"
echo "Details of top 3 individuals with the highest salary:" >> "$output_file"

# Finding top 3 individuals with highest pay
awk -F',' 'NR > 1 {print $0}' "$input_file" | sort -t',' -k4,4nr | awk 'NR<=3' >> "$output_file"
# print $0 selects all the contents of the data base
# -t',' breaks the data into entry fields on the basis of the delimiter comma and -k4,4 sets the key on which sorting is done which is the 4th column here (Salary)
# n specifier specifier numeric sorting while r specifies reverse order so that the top 3 entries are the richest individuals
# awk 'NR<=3' filters the top 3 individuals from the processed sorted data


# Structure
echo "" >> "$output_file"
echo "---" >> "$output_file"
echo "Details of average salary of each city:" >> "$output_file"

# Computing average salary for each city
awk -F',' 'NR>1{sum[$3]+=$4; count[$3]++} END{for(city in sum) print "City:" city ", Salary: " sum[city]/count[city]}' "$input_file" >> "$output_file"
# -F sets the delimiter, NR > 1 to skip the header
# Whenever awk encounters an row entry the value of count array element corresponding to the city increases as well as the corresponding element in the sum array is increased by the salary count
# After awk traverses the entire csv file, for each distinct city in sum array we return with the ratio of them will return the average salary for the city


# Structure
echo "" >> "$output_file"
echo "---" >> "$output_file"
echo "Details of individuals with a salary above the overall average salary:" >> "$output_file"

# Computing the overall average salary for the filtering process
avg_salary=$(awk -F',' 'NR>1{sum+=$4; count++} END{print sum/count}' "$input_file")
# -F sets the delimiter, NR > 1 to skip the header
# Whenever awk encounters an row entry the value of count variable increases and sum is increased by the salary count
# After awk traverses the entire csv file, we end with the ratio of them will return the average salary for the database

# Identifying individuals with salary above overall average salary
awk -F',' 'NR>1 && $4 > '"$avg_salary" "$input_file" >> "$output_file"
# -F sets the delimiter, NR > 1 to skip the header
# $4 > avg_salary adds the condition that the salary should be above the average salary of the database

# Structure
echo "---" >> "$output_file"