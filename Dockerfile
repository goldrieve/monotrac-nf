FROM mambaorg/micromamba:latest

COPY monotrac.yml /tmp/monotrac.yml

RUN micromamba create -n monotrac-env -f /tmp/monotrac.yml && \
    micromamba clean -a --yes && \
    rm -rf /opt/conda/pkgs/*

ENV PATH=/opt/conda/envs/monotrac-env/bin:$PATH

WORKDIR /data

CMD ["bash"]