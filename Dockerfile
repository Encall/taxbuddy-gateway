FROM traefik:v3.6

LABEL org.opencontainers.image.source="https://github.com/Encall/taxbuddy-gateway"

# Copy configuration files (for production)
# In development, volume mounts will override these
COPY config/traefik.yaml /config/traefik.yaml
COPY config/dynamic.yaml /config/dynamic.yaml

# Expose ports
EXPOSE 80 443 8080

# Entrypoint is already set by base image
CMD ["--configFile=/config/traefik.yaml"]
