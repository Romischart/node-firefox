FROM selenium/node-firefox:latest
LABEL maintainer="info@romischart.de"

WORKDIR /home/seluser
USER seluser

ARG NODE_VERSION=14.17.3
ENV NVM_DIR /home/seluser/.nvm

#================
# Install nvm
#================
RUN mkdir -p ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
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

CMD [ "yarn" ]