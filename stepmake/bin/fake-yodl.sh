#!/bin/sh

IDENTIFICATION=fake-yodl.sh

OUTPUT='/dev/null'

while getopts ':d:o:' OPT;
do
case $OPT in
o)
    OUTPUT=$OPTARG
    ;;
*)
    ;;
    esac
done



shift `expr $OPTIND - 1`
#
# Input file name
#
if [ "$1" = "" ]
then
  echo "$IDENTIFICATION: No input file name given"
  exit 1
fi

echo Faking Yodl: copying $1 to $OUTPUT


echo THIS IS A SURROGATE. Please install YODL for a formatted document  > $OUTPUT
cat $1 >> $OUTPUT
