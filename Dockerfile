FROM python:3.12

ARG APP_HOME=/app
WORKDIR ${APP_HOME}

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV POETRY_VERSION=1.7.1

RUN pip install "poetry==$POETRY_VERSION"

# Install python dependencies in /.venv
COPY pyproject.toml ${APP_HOME}
COPY poetry.lock ${APP_HOME}

# Installing "standard" dependencies only, without dev. Done before getting commit sha to cache this layer
RUN poetry config virtualenvs.in-project true && poetry install --only=main --no-interaction --no-ansi
# Installing dev dependencies. Triggered only for test image.
RUN if [ "$BUILD_COMMIT_SHA" = "local" ]; then \
    poetry install --only=dev --no-interaction --no-ansi; \
    fi

COPY . ${APP_HOME}

ENV PATH="${APP_HOME}/.venv/bin:$PATH"

ENTRYPOINT ["./docker-entrypoint.sh"]
# running migrations
RUN python manage.py migrate

# gunicorn
CMD ["gunicorn", "--config", "gunicorn-cfg.py", "config.wsgi"]
