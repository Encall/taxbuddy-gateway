# TaxBuddy Gateway

Traefik-based API gateway for TaxBuddy services. It routes public health and auth endpoints directly to the backend, and protects application routes with forward auth.

## What It Does

This gateway sits in front of two upstream services:

- Backend service for auth and user-facing API routes
- Retriever service for document, ingest, conversation, and response APIs

Forward auth is handled by the backend at `/auth/verify`.

## Architecture

```text
Client -> Traefik Gateway (:80/:443) -> backend
                                 |-> retriever
                                 `-> /auth/verify forward auth
```

## Requirements

- Docker
- [Task](https://taskfile.dev/)
- A running backend service
- A running retriever service

## Configuration

Create a local `.env` file from the example:

```bash
cp .env.example .env
```

Environment variables:

| Variable         | Description                              | Default          |
| ---------------- | ---------------------------------------- | ---------------- |
| `BACKEND_HOST`   | Backend host and port used by Traefik    | `localhost:8080` |
| `RETRIEVER_HOST` | Retriever host and port used by Traefik  | `100.x.x.x:8001` |
| `DOMAIN`         | Domain used by the gateway when deployed | unset            |

## Running Locally

Start the gateway with the Taskfile:

```bash
task run
```

This runs the official Traefik image in Docker, mounts the `config/` directory, and reads the hosts from `.env`.

## Production Image

Build the gateway image:

```bash
task build
```

Run the built image:

```bash
task prod
```

## Routes

| Path                  | Auth     | Upstream  | Notes                     |
| --------------------- | -------- | --------- | ------------------------- |
| `/health`             | No       | Backend   | Health check              |
| `/api/v1/auth/*`      | No       | Backend   | Public auth routes        |
| `/auth/verify`        | No       | Backend   | Forward auth endpoint     |
| `/api/v1/user/*`      | Yes      | Backend   | Protected backend routes  |
| `/api/v1/documents/*` | Yes      | Retriever | Protected document routes |
| `/api/v1/ingest/*`    | Yes      | Retriever | Protected ingest routes   |
| `/api/v1/users/*`     | Yes      | Retriever | Protected user routes     |
| `/api/v2/responses`   | Optional | Retriever | Guest access supported    |
| `/api/v2/*`           | Yes      | Retriever | Other v2 routes           |

## Tasks

List available tasks:

```bash
task --list
```

Available project tasks:

- `task run` - Start Traefik locally in Docker
- `task build` - Build the gateway image
- `task prod` - Run the built image in detached mode

## Notes

- The gateway configuration lives in `config/traefik.yaml` and `config/dynamic.yaml`.
- Development mode volume-mounts the config directory so changes are picked up without rebuilding.
- The Docker image copies the config into the image for production use.
