#!/bin/bash

# arguments of the form
# <token> <value 1> <value 2> ... <value N>
# the template file is passed in through standard in
# template file should have token <token>

function usage {
    cat <<EOF
Usage: replace_many.sh TOKEN VALUE...

  Creates N copies of standard input, each having replaced
  all instances of TOKEN with each VALUE given.

  For example:

    replace_many.sh XXX foo bar<<< "XXX is the value"

  produces the output:

    foo is the value
    bar is the value
EOF

    exit 1
}

function die {
    echo $@ >&2
    exit 1
}

token=$1

[[ $token == "" ]] \
    && usage

shift

rm -f "$ior_gen"

tempfile=$(mktemp)

cat > $tempfile 

for value in $@ ; do
    sed "s!$token!$value!g" $tempfile
done

rm $tempfile
