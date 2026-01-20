# Docker Sandbox (P1)

This is an optional pattern for running Ralph in an isolated container when using dangerous permissions.

## Build

```bash
docker build -t ralph-sandbox -f docker/Dockerfile .
```

## Run

```bash
docker run --rm -it -v "$PWD:/workspace" -w /workspace ralph-sandbox ./ralph.sh 10
```

Notes:
- The container includes `git`, `jq`, and `envsubst`, but does NOT install the Amp CLI.
- Provide Amp credentials/binary in the container as appropriate for your environment.
