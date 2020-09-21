#! /bin/bash
CURRENT_COMPONENT=`pwd | awk -F '/' '{print $NF}'`
PULL=false;
function colorfulEcho {
    case $1 in
    g)    printf "\x1b[1;32m";;
    r)    printf "\x1b[1;31m";;
    y)    printf "\x1b[1;33m";;
    b)    printf "\x1b[1;34m";;
    p)    printf "\x1b[1;35m";;
    esac
    echo $2
    printf "\x1b[0m"
}

function gitpull() {
	colorfulEcho g "--- [$CURRENT_COMPONENT] Branch "$targetBranch" started pulling ---"
	git pull
	colorfulEcho g "--- [$CURRENT_COMPONENT] Branch "$targetBranch" finished pulling ---"
}
if [ $# -eq 0 ]; then
	git status
	echo ""
	echo "/**** Branches ****/"
	echo ""
	git branch
	exit 0;
else
	if [ $# -eq 1 ]; then
		targetBrRaw=$1
	elif [ $# -eq 2 ]; then
		case $1 in
		-pull)
			PULL=true
			;;
		*) 
			echo Unknown option "$1"
			;;
		esac
		targetBrRaw=$2
	fi
	currentBr=`git branch | grep '*' |awk '{print $NF}'`
	colorfulEcho y "Current branch >>> $currentBr"
	targetBranch=`git branch | grep $targetBrRaw `
	targetNum=`git branch | grep $targetBrRaw | wc -l`
fi

if [[ $targetBranch =~ "*" ]]; then
	colorfulEcho r "Already in $currentBr!"
	exit 1;
fi
if [ -z "$targetBranch" ]; then
	colorfulEcho r "Not exist target branch!"
	echo "show all branches:"
	branches=(`git branch | grep -v '*'`)
elif [ $targetNum -ne 1 ]; then
	colorfulEcho r "Too many target branch!"
	echo "show candidates:"
	branches=(`git branch | grep -v '*' | grep $targetBrRaw`)
	targetBranch="";
fi
if [ -z "$targetBranch" ]; then
	for (( i = 0 ; i < ${#branches[@]} ; i++ )); do
		echo "$i. ${branches[$i]}"
	done
	read brIdx
	targetBranch=${branches[$brIdx]}
fi
colorfulEcho g "git checkout $targetBranch ..."
git checkout $targetBranch
if [ $PULL == true ]; then
	gitpull
fi


