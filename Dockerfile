FROM rocker/verse
MAINTAINER Zhenmin Li <zhenmin@live.unc.edu>
ARG linux_user_pwd
RUN echo Hello World
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "rstudio:$linux_user_pwd" | chpasswd
RUN adduser rstudio sudo
RUN R -e "install.packages('shiny')"
RUN R -e "install.packages('plotly')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('lubridate')"

