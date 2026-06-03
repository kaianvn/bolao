FROM ruby:2.1.10

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    PATH=/bundle/bin:$PATH

RUN printf 'deb http://archive.debian.org/debian jessie main contrib non-free\ndeb http://archive.debian.org/debian-security jessie/updates main\n' > /etc/apt/sources.list \
  && printf 'Acquire::Check-Valid-Until "false";\nAcquire::AllowInsecureRepositories "true";\nAcquire::AllowDowngradeToInsecureRepositories "true";\n' > /etc/apt/apt.conf.d/99archive \
  && rm -f /etc/apt/sources.list.d/*

RUN apt-get update -qq && apt-get install -y \
  --allow-unauthenticated \
    build-essential \
    git \
    libsqlite3-dev \
    nodejs \
    sqlite3 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN gem install bundler -v 1.17.3

COPY Gemfile Gemfile.lock* ./
RUN bundle _1.17.3_ install

COPY . .

RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["bash", "/app/docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]