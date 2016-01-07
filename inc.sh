#! /bin/bash


function generate_c_file(){
	rm -f $1 &> /dev/null
	echo "#include <stdio.h>" >> $1
	echo "#include <string.h>" >> $1
	echo "#include <stdlib.h>" >> $1
	echo "int main(int argc, char* argv[]) {" >> $1
	cat ./temp >> $1
	echo "return 0;" >> $1
	echo "}" >> $1
}

function replace(){
	echo "what = $what"
	echo "with = $with"
	sed -i -e 's/$what/$with/g' ./test_code.c
}

rm -f ./temp.bak
touch temp.bak
rm -f ./temp
touch temp
while :
do
	read -e input
	case "$input" in
		"");;
		"run")
			gcc ./test_code.c
			./a.out
			echo ""
			;;
		 *)
				echo $input >> temp
				generate_c_file "test_code.c"
				rm -f ./a.out
				gcc ./test_code.c
				if [ $? -eq 0 ]; then
					count=`grep -c "printf(" ./test_code.c`
					if [ $count -gt 0 ]; then
						echo "Output ***********************"
						./a.out
						echo ""
						echo "******************************"
						echo ""
					fi
					echo $input >> temp.bak
				else
					echo ""
					echo ""
					cp -f ./temp.bak ./temp	
					generate_c_file "test_code.c"
				fi
			;;
	esac
done
