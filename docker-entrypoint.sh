#!/bin/bash
set -e

BOOTSTRAP_STAMP="tmp/.docker_bootstrapped"

if [ ! -f config/database.yml ] && [ -f config/database.example.yml ]; then
  cp config/database.example.yml config/database.yml
fi

if [ ! -f config/application.yml ] && [ -f config/application.example.yml ]; then
  cp config/application.example.yml config/application.yml
fi

mkdir -p tmp

if [ "${APP_ROLE}" = "web" ]; then
  if bundle exec rails runner 'puts(!ActiveRecord::Base.connection.table_exists?("teams"))' | grep -q true; then
    bundle exec rake db:schema:load
  else
    bundle exec rake db:migrate
  fi

  if bundle exec rails runner 'puts(Group.count.zero? && Team.count.zero?)' | grep -q true; then
    bundle exec rake db:seed
  fi

  touch "${BOOTSTRAP_STAMP}"
fi

if [ "${APP_ROLE}" = "sync" ]; then
  while [ ! -f "${BOOTSTRAP_STAMP}" ]; do
    sleep 2
  done
fi

exec "$@"