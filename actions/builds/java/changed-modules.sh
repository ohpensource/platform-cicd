#!/bin/bash
set -e
set +x

while getopts p:a:i: flag
do
    case "${flag}" in
    	p) previous_commit=${OPTARG};;
        a) actual_commit=${OPTARG};;
        i) always_included_modules=${OPTARG};;
    esac
done

echo "- Changes between $previous_commit <> $actual_commit commits"
changed_modules=$always_included_modules
for chanted_file in $(git diff --name-only $previous_commit $actual_commit); do
	echo "-- Changed file $chanted_file"
 	if [[ "$chanted_file" == *"/pom.xml" ]]; then
 		changed_modules=$changed_modules,./${chanted_file::-7}
 	else
 		parent_dir=$chanted_file
 		while [[ "$parent_dir" != "/" ]]; do
           	parent_dir="$(dirname "$parent_dir")"
           	echo "--- Check parent directory $parent_dir"
			if [[ -f "$parent_dir/pom.xml" ]]; then
				changed_modules=$changed_modules,./$parent_dir
				break
			fi
        done
 	fi
done

changed_modules=${changed_modules:1}
echo "::set-output name=changed_modules::${changed_modules}"
echo "- Changed modules: ${changed_modules}"
