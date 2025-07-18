#!/bin/sh

# Railway provides PORT environment variable
# Always bind to all interfaces to support both public and private networking
if [ -n "$PORT" ]; then
    # Bind to all interfaces (::) to support both IPv4 and IPv6
    # This allows connections from both public and private networks
    export MEILI_HTTP_ADDR="[::]:$PORT"
    echo "Railway environment detected"
    echo "Binding to [::]:$PORT (all interfaces - public and private)"
    
    # Show available access points if private networking is available
    if [ -n "$RAILWAY_PRIVATE_DOMAIN" ]; then
        echo "Service accessible at:"
        echo "  - Public: via your Railway public domain"
        echo "  - Private: http://$RAILWAY_PRIVATE_DOMAIN:$PORT"
        echo ""
        echo "IMPORTANT: Always include :$PORT when connecting via private networking!"
    fi
else
    # Fallback for local development
    export MEILI_HTTP_ADDR="[::]:7700"
    echo "Using MEILI_HTTP_ADDR: $MEILI_HTTP_ADDR"
fi

# Pass all arguments to meilisearch
exec meilisearch "$@"