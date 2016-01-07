#! /bin/bash

hold=0
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

rm -f ./temp.bak
touch temp.bak
rm -f ./temp
touch temp

while :
do
	read -p "C-In# " -e input 
	case "$input" in
		"");;
	"exit")
		exit 0
		;;
	"close")
		exit 0
		;;
	"quit")
		exit 0
		;;
	"hold")
		hold=1
		;;
	"hold-")
		hold=0
		;;
	"new")
		# open new context
		rm -f ./temp
		rm -f ./temp.bak
		rm -f ./test_code.c
		touch ./temp
		touch ./temp.bak
		chmod 666 ./temp
		chmod 666 ./temp.bak
		reset
		;;
	"run")
		./a.out
		echo ""
		;;
	*)
		echo $input >> temp
		generate_c_file "test_code.c"
		rm -f ./a.out
		gcc ./test_code.c
		if [ $? -eq 0 ]; then
			echo $input >> temp.bak
			count=`grep -c "printf(" ./test_code.c`
			if [ $count -gt 0 ]; then
				echo "printf(\"\\n\");" >> temp.bak
				echo "printf(\"\\n\");" >> temp
				if [ $hold -eq 0 ]; then
					./a.out
					echo ""
					echo ""
				fi
			fi
		else
			echo ""
			echo ""
			cp -f ./temp.bak ./temp	
			generate_c_file "test_code.c"
			gcc ./test_code.c
		fi
		;;
esac
done
