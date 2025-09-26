FROM condaforge/mambaforge:latest

# Copy environment file
COPY monotrac.yml /tmp/monotrac.yml

# Install dependencies using mamba
RUN mamba env create -f /tmp/monotrac.yml && \
    mamba clean -afy

# Add conda environment to PATH
ENV PATH /opt/conda/envs/monotrac-env/bin:$PATH

# Set working directory
WORKDIR /data

# Default command
CMD ["bash"]
