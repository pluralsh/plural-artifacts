FROM node:14

RUN apt-get update && apt-get install -y jq

RUN useradd --create-home --shell /bin/bash cal

USER cal

WORKDIR /home/cal

RUN git clone https://github.com/calendso/calendso.git

WORKDIR /home/cal/calendso
RUN git checkout 11e7779a585a0fcded5a02619332333a85d2cdc4

RUN yarn install

RUN NEXT_PUBLIC_APP_URL=APP_NEXT_PUBLIC_APP_URL_VAR \
    NEXT_PUBLIC_LICENSE_CONSENT=agree \
    yarn build

USER root

COPY docker-entrypoint.sh docker-entrypoint.sh

RUN chmod +x docker-entrypoint.sh

USER cal

ENTRYPOINT ["./docker-entrypoint.sh"]