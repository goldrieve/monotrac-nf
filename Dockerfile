FROM condaforge/mambaforge:latest

COPY monotrac.yml /tmp/monotrac.yml

RUN mamba env create -f /tmp/monotrac.yml && \
    mamba clean -afy

ENV PATH=/opt/conda/envs/monotrac-env/bin:$PATH

WORKDIR /data

CMD ["bash"]