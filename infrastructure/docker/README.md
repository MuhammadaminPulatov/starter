# infrastructure/docker

Dockerfiles and docker-related helpers.

Suggested: one Dockerfile per service (`api-node.Dockerfile`,
`worker.Dockerfile`), multi-stage builds, and a `.dockerignore`.

Local orchestration lives in the root `docker-compose.yml`; see
`docker-compose.override.yml.example` for wiring app services in.
