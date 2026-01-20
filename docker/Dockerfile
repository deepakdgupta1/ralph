FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    git \
    jq \
    gettext-base \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["bash"]
