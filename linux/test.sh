set +e

# All commands return an exit status of 1 when run like this

./ruleset_converter > /dev/null 2>&1
retVal=$?
if [ $retVal -ne 1 ]; then
    echo "Error: Expected ruleset_converter exit code to be 1, but got $retVal"
    exit 1
fi

./subresource_indexing_tool > /dev/null 2>&1
retVal=$?
if [ $retVal -ne 1 ]; then
    echo "Error: Expected subresource_indexing_tool exit code to be 1, but got $retVal"
    exit 1
fi

./subresource_filter_tool > /dev/null 2>&1
retVal=$?
if [ $retVal -ne 1 ]; then
    echo "Error: Expected subresource_filter_tool exit code to be 1, but got $retVal"
    exit 1
fi

echo "All tools behave as expected."
