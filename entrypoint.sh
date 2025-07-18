#!/bin/sh

# Railway provides PORT environment variable
# We need to bind Meilisearch to 0.0.0.0:$PORT for Railway to route traffic properly
if [ -n "$PORT" ]; then
    export MEILI_HTTP_ADDR="0.0.0.0:$PORT"
    echo "Railway environment detected. Binding to 0.0.0.0:$PORT"
else
    # Fallback for local development
    export MEILI_HTTP_ADDR="${MEILI_HTTP_ADDR:-0.0.0.0:7700}"
    echo "Using MEILI_HTTP_ADDR: $MEILI_HTTP_ADDR"
fi

# Pass all arguments to meilisearch
exec meilisearch "$@"