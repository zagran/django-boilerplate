#
# Reference https://sourcery.ai/blog/python-docker/
#
# Global arguments
ARG USER=api
ARG GROUP=api
ARG APP_HOME=/app
ARG BUILD_COMMIT_SHA

# Use "fat" python image to build deps.
FROM python:3.12.1 AS python-deps
# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV BUILD_COMMIT_SHA ${BUILD_COMMIT_SHA:-}
ENV POETRY_VERSION=1.7.1

RUN pip install "poetry==$POETRY_VERSION"
RUN apt-get update && apt-get install -y --no-install-recommends gcc curl

# Install python dependencies in /.venv
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock

# Installing "standard" dependencies only, without dev. Done before getting commit sha to cache this layer
RUN poetry config virtualenvs.in-project true && poetry install --only=main --no-interaction --no-ansi
# Installing dev dependencies. Triggered only for test image.
RUN if [ "$BUILD_COMMIT_SHA" = "local" ]; then \
    poetry install --only=dev --no-interaction --no-ansi; \
    fi

# Final worker image
FROM python:3.12.2-slim AS runtime
ARG USER
ARG GROUP
ARG BUILD_COMMIT_SHA
ARG APP_HOME

COPY --from=python-deps /.venv /.venv
ENV PATH="/.venv/bin:$PATH"

# Install additional packages
RUN apt-get update && apt-get install -y --no-install-recommends vim curl libpq5

# Clean cache and remove unnecessary files
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -f pyproject.toml poetry.lock

# Copy the repository to the directory /app
RUN addgroup ${GROUP}
RUN useradd --create-home --gid ${GROUP} --shell /sbin/nologin --home-dir ${APP_HOME} ${USER}
RUN chown -R ${USER}:${GROUP} /.venv

# change workdir
WORKDIR $APP_HOME

ENTRYPOINT ["./docker-entrypoint.sh"]

# gunicorn
CMD ["gunicorn", "--config", "gunicorn_config.py", "config.wsgi"]
