FROM traefik:v3.2

# Copy configuration files
COPY config/traefik.yaml /etc/traefik/traefik.yaml
COPY config/dynamic.yaml /etc/traefik/dynamic.yaml

# Expose ports
EXPOSE 80 443 8080

# Entrypoint is already set by base image
