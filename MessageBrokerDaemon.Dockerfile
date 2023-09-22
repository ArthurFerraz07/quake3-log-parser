# Defina a imagem base como a versão mais recente do Ruby
FROM ruby:3.1.3

# Crie o diretório de trabalho para o aplicativo
RUN mkdir -p /message_broker_daemon
WORKDIR /message_broker_daemon

# Copie os arquivos do aplicativo para o contêiner
COPY ./* /message_broker_daemon

# Instale as dependências do Ruby necessárias para o aplicativo Rails
RUN gem install bundler
RUN bundle install --jobs 4