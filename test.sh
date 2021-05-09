set +e

# All commands return an exit status of 1 when run like this

./ruleset_converter
retVal=$?
if [ $retVal -ne 1 ]; then
    echo "Error: Expected ruleset_converter exit code to be 1, but got $retVal"
fi

./subresource_indexing_tool
retVal=$?
if [ $retVal -ne 1 ]; then
    echo "Error: Expected subresource_indexing_tool exit code to be 1, but got $retVal"
fi

./subresource_filter_tool
retVal=$?
if [ $retVal -ne 1 ]; then
    echo "Error: Expected subresource_filter_tool exit code to be 1, but got $retVal"
fi

