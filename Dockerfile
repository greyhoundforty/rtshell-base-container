FROM ubuntu:22.04 as builder

COPY install.sh install.sh

RUN chmod +x ./install.sh
RUN ./install.sh && rm install.sh

FROM scratch
COPY --from=builder / /