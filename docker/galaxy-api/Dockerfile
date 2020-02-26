# Stage 1: Build galaxy-pulp from openapi spec
FROM openapitools/openapi-generator-cli AS galaxy-pulp

COPY galaxy-api/bindings/openapi.yaml /local/openapi.yaml
RUN docker-entrypoint.sh generate \
    -i /local/openapi.yaml \
    -g python \
    -o /local/galaxy-pulp \
    --skip-validate-spec \
    --additional-properties=packageName=galaxy_pulp,projectName=galaxy-pulp

# Stage 2: Build galaxy image
FROM centos:8

ENV LANG=en_US.UTF-8 \
    PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=galaxy_api.settings \
    GALAXY_CODE=/code \
    GALAXY_VENV=/venv

RUN dnf install -y \
        glibc-langpack-en \
        git-core \
        python3 \
        python3-devel \
    && dnf -y clean all


COPY galaxy-api/Pipfile \
    galaxy-api/Pipfile.lock \
    /tmp/galaxy-api/

RUN python3 -m venv "${GALAXY_VENV}" \
    && source "${GALAXY_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        pip wheel pipenv \
    && cd /tmp/galaxy-api \
    && PIPENV_VERBOSITY=-1 pipenv install --ignore-pipfile

COPY --from=galaxy-pulp /local/galaxy-pulp /tmp/galaxy-pulp
RUN source "${GALAXY_VENV}/bin/activate" \
    && pip install /tmp/galaxy-pulp

WORKDIR /code/

# Activate virual env
ENV PATH="${GALAXY_VENV}/bin:${PATH}"

COPY docker/galaxy-api/entrypoint.sh /entrypoint
ENTRYPOINT [ "/entrypoint" ]
CMD [ "run" ]
