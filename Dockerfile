# Use the official Meilisearch image with version flexibility
ARG MEILISEARCH_VERSION=latest
FROM getmeili/meilisearch:${MEILISEARCH_VERSION}

# Create data directory for persistence
RUN mkdir -p /meili_data/snapshots /meili_data/dumps

# Set working directory
WORKDIR /meili_data

# Expose the default Meilisearch port
EXPOSE 7700

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:7700/health || exit 1

# Use the default Meilisearch entrypoint
ENTRYPOINT ["meilisearch"]