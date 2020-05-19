FROM debian:buster-slim

ARG NODE_VERSION=12.16.3
ENV NVM_DIR /usr/local/nvm

#============================
# Screen configuration
#============================
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV SCREEN_DPI 96
ENV DISPLAY :99.0
ENV START_XVFB true

USER root

#==============
# Xvfb
#==============
RUN apt-get update -qqy \
    && apt-get -qqy install \
        xvfb \
        libgtk-3-0 \
        libdbus-glib-1-2 \
        wget \
        bzip2 \
    &&  mkdir -p /usr/local/nvm

#================
# Fonts
#================
RUN apt-get -qqy update \
  && apt-get -qqy --no-install-recommends install \
    libfontconfig \
    libfreetype6 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-tlwg-loma-otf

#================
# Firefox install & configure
#================
ENV FIREFOX_DOWNLOAD_URL="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
ENV FIREFOX_TMP_SOURCE="/tmp/firefox.tar.bz2"
RUN wget --no-verbose -O ${FIREFOX_TMP_SOURCE} ${FIREFOX_DOWNLOAD_URL} \
    && rm -rf /opt/firefox \
    && tar -C /opt -xjf ${FIREFOX_TMP_SOURCE} \
    && rm ${FIREFOX_TMP_SOURCE} \
    && ln -s /opt/firefox/firefox /usr/local/bin/firefox

COPY src/start-xvfb.sh /usr/local/bin/start-xvfb

#================
# Cleanup
#================
RUN apt-get -qyy autoremove \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && apt-get -qyy clean


#================
# Configure node user
#================
RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

#================
# Install nvm
#================
RUN mkdir -p ${NVM_DIR} \
    && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
    && [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default

#================
# Configure node environment
#================
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install --global yarn

#RUN /usr/bin/env bash -c firefox --version

USER node
WORKDIR /home/node
CMD [ "start-xvfb" ]
