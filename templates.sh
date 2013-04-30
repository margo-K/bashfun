#!/bin/bash

template_folder=~/Dropbox/templates/
function bug(){
	commit=`git log -1 | head -n 1 | cut -d ' ' -f 2`
	template='bug.md'
	bug_id=$1
	fname=bug$bug_id.md

	if [[ -a $fname ]]; then 
		echo 'File already exists. Please retry'
	else
		echo -n 'Gimme a title: ' # -n suppresses newline prompt will be on same line
		read title # -s suppresses echoing of input
		title=`echo -n $title | tr ' ' '\ '`
		

		cat $template_folder$template > ./$fname
		sed -i '' -e s/\$NAMEVAR/"$title"/ -e s/\$COMMITVAR/$commit/ $fname # search & replace, in place

		subl ./$fname
	fi
}

function readme(){
	template='README.md'

	fname=README.md

	if [[ ! -a $fname ]]; then
		echo -n 'Project name: ' # -n suppresses newline prompt will be on same line
		read title # reads input
		title=`echo -n $title | tr ' ' '\ '` # escaping spaces

		contents=`git ls-files | cut -d '/' -f 1 | uniq`

		lnum=`grep -n '$CONTENTVAR' $template_folder$template | cut -d ':' -f 1`
		head -n $(($lnum-1)) $template_folder$template > ./$fname
		echo "$contents" >> ./$fname
		tail +$(($lnum+1)) $template_folder$template >> $fname

		sed -i '' s/\$NAMEVAR/"$title"/ $fname
	fi

	subl ./$fname

}


