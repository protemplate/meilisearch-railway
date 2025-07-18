# Use the official Meilisearch image with version flexibility
ARG MEILISEARCH_VERSION=latest
FROM getmeili/meilisearch:${MEILISEARCH_VERSION}

# Create data directory for persistence
RUN mkdir -p /meili_data/snapshots /meili_data/dumps

# Copy custom entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set working directory
WORKDIR /meili_data

# Expose the default Meilisearch port
EXPOSE 7700

# Use custom entrypoint that handles Railway's PORT
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]