# Defina a imagem base como a versão mais recente do Ruby
FROM ruby:3.1.3

# Crie o diretório de trabalho para o aplicativo
WORKDIR /app

# Copie os arquivos do aplicativo para o contêiner
COPY Gemfile /app
COPY Gemfile.lock /app
COPY /src /app
COPY /inputs /app/inputs

# Instale as dependências do Ruby necessárias para o aplicativo Rails
RUN gem install bundler
RUN bundle install --jobs 4
