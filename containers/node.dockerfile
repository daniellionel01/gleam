FROM node:latest

ARG TARGETARCH
COPY gleam-${TARGETARCH} /bin/gleam
COPY gleam-${TARGETARCH}.sbom.spdx.json /opt/sbom/

CMD ["gleam"]
