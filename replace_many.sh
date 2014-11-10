#!/bin/bash

# arguments of the form
# <token> <value 1> <value 2> ... <value N>
# the template file is passed in through standard in
# template file should have token <token>

function usage {
    cat <<EOF
Usage: replace_many.sh TOKEN VALUE...

  Creates N copies of the IOR template passed in through
  standard input, each having replaced all instances of
  TOKEN with each VALUE given. 

  For example:

    ior.in:
      IOR START
        api=POSIX
        segmentCount=10
        blockSize=foo
        transferSize=foo
        testFile=temp.dat
        RUN
      IOR STOP

    replace_many.sh foo 8 16 32 < ior.in 

  produces the output:

    IOR START
      api=POSIX
      segmentCount=10
      blockSize=8
      transferSize=8
      testFile=temp.dat
      RUN
      api=POSIX
      segmentCount=10
      blockSize=16
      transferSize=16
      testFile=temp.dat
      RUN
      api=POSIX
      segmentCount=10
      blockSize=32
      transferSize=32
      testFile=temp.dat
      RUN
    IOR STOP
EOF

    exit 1
}

token=$1

[[ $token == "" ]] && usage

shift

[[ $1 == "" ]] && usage

tempfile=$(mktemp)

cat | sed -r "/IOR *(START|STOP)/ d" > $tempfile

echo IOR START

for value in $@ ; do
    sed "s!$token!$value!g" $tempfile
done

echo IOR STOP

rm $tempfile
