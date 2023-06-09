#!/bin/bash

{
usage="$(basename "$0") [-h] [-I <SRA_list_Illumina>] [-N <SRA_list_Nanopore>] [-g <reference_genome>] [-d <working_directory]
This program downloads the reference sequences that are being used to test read mapping to divergent genomes
    -h  show this help text
    -d  path to reference directory (where references will be saved)
    -l  path to list of ftp reference paths"
options=':h:d:l:'
while getopts $options option; do
  case "$option" in
    h) echo "$usage"; exit;;
    d) d=$OPTARG;;
    l) l=$OPTARG;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
  esac
done

echo ""
echo "Working directory:    " $d
echo "path to ref list:     " $l
echo ""

# mandatory arguments
if [ ! "$d" ] || [ ! "$l" ]; then
  echo "arguments -d and -l  must be provided"
  echo "$usage" >&2; exit 1
fi

# save wd
wd=$(pwd)

# download reference genomes
function download_refs {
	cd ${d}
	while read ref; do
	    id=$( echo "$ref" | cut -d '/' -f 7 )
	    genome_file="${id}_genomic.fna.gz"
	    if [ ! -f $genome_file  ]; then
		    echo "File "$ref" doesn't exist. Downloading now."
		    rsync --copy-links --times --verbose rsync://"$ref"/"$genome_file" .
		else
    		    echo "File exists"
		fi

	done<${wd}/${l}
}

download_refs

}
