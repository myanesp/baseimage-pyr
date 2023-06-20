FROM debian:bullseye-20230612-slim

RUN apt-get clean all && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y \
        git \
        curl \
        wget \
		cron \
		libhdf5-dev \
		libcurl4-gnutls-dev \
		libssl-dev \
		libxml2-dev \
		libpng-dev \
		libxt-dev \
		zlib1g-dev \
		libbz2-dev \
		libgdal-dev \
		liblzma-dev \
		libglpk40 \
		libgit2-dev \
        python3 \
        python3-pip \
        r-base \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    git+https://github.com/JustAnotherArchivist/snscrape.git \
    pandas \
    requests \
    beautifulsoup4

RUN Rscript -e "install.packages(c('readr', 'shiny', 'shinydashboard', 'ggplot2', 'plotly', 'tidyr', 'dplyr', 'leaflet', 'tidytext', 'lubridate', 'stringr', 'stringi', 'stringdist'))"

# RUN touch /var/run/crond.pid && chmod 644 /var/run/crond.pid

COPY start.sh /app/start.sh

COPY crontab /etc/cron.d/my-crontab

RUN chmod +x /app/start.sh

RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log

EXPOSE 3838