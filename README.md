# TaxBuddy Gateway

Traefik API Gateway for TaxBuddy services, providing centralized routing and JWT authentication via forward auth.

## Architecture

```
Client → Traefik Gateway (:80) → taxbuddy-backend (:8080)
                ↓
      ForwardAuth (/auth/verify)
```

## Quick Start

### Prerequisites

- [Task](https://taskfile.dev/) - Task runner
- Backend running at `localhost:8080`

### Local Development

```bash
# Download Traefik binary (first time only)
task download

# Start gateway (assumes backend is running)
task run
```

### Docker Deployment

```bash
# Copy and configure environment
cp .env.example .env

# Start all services
docker-compose up -d
```

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `BACKEND_HOST` | Backend service address | `localhost:8080` |

## Endpoints

| Path | Auth | Description |
|------|------|-------------|
| `/health` | No | Health check |
| `/api/v1/auth/*` | No | Auth endpoints |
| `/api/*` | Yes | Protected API routes |

## Tasks

```bash
task --list              # Show all tasks
task run                 # Run gateway locally
task docker-up           # Start Docker Compose
task docker-down         # Stop Docker Compose
task clean               # Remove downloaded binaries
```
