# This Dockerfile based upon one in the SCTK repository at 
# https://github.com/compbiomed/singleCellTK/blob/master/Dockerfile
FROM rocker/shiny-verse:4.3.2

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libjpeg-dev \
    libv8-dev \
    libbz2-dev \
    liblzma-dev \
    libglpk-dev \
    libmagick++-6.q16-dev \
    git

# Clone the repo and checkout the commit corresponding to the proper version/release of SCTK
ENV COMMIT_ID="14c92130471e0b7acca579708ab3f32cba20dbca"
ENV SCTK_VERSION="2.12.2"
ENV PKG="singleCellTK_"$SCTK_VERSION

RUN git clone https://github.com/compbiomed/singleCellTK.git /sctk
RUN cd /sctk && git checkout $COMMIT_ID
RUN R -e "install.packages('devtools')" \
    && R -e "devtools::install_deps('/sctk', dependencies = TRUE)" \
    && R -e "devtools::build('/sctk')" \
    && R -e "install.packages('$PKG.tar.gz', repos = NULL, type = 'source')"
