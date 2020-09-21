#! /bin/bash

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

function printBranches {
	limit=${#branches[@]}
	if [ $# -gt 0 ]; then
		if [ $1 -lt $limit ]; then
			limit=$1
		fi
	fi
	colorfulEcho y "showing $limit branches from head..."
	for (( i = 0 ; i < $limit ; i++ )); do
		echo "${branches[$i]}"
	done
}

if [ $# -lt 1 ]; then
	colorfulEcho r "Useage: ${0##/*/} [word-to-filter]"
	exit 1
fi
colorfulEcho p "remote update ? (y/n)"
printf ">> "
read updateYn
if [ "$updateYn" == "y" ]; then
	git remote update
fi

branches=(`git branch -r | grep $1`)

while [ "${#branches[@]}" -gt 1 ]
do
	clear
	colorfulEcho g "filtered ${#branches[@]} branches."
	printBranches 20
	printf "\x1b[1;32mNext filter\x1b[0m >> "
	read branchFilter
	branches=(`printBranches | grep $branchFilter`)
done

if [ "${#branches[@]}" -lt 1 ]; then
	colorfulEcho r "Branch is not exist!!"
	exit 1
else	
	targetBranch=${branches[0]#origin/}
fi

colorfulEcho g "checkout branch: $targetBranch ? (y/n)"
printf ">> "
read pullYn
if [ "$pullYn" == "y" ]; then
	git checkout $targetBranch
fi
