FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    GALAXY_CODE=/code \
    GALAXY_VENV=/venv \
    DJANGO_SETTINGS_MODULE=galaxy_api.settings

RUN yum -y install epel-release \
    && yum -y install \
        git \
        python36 \
        python36-devel \
    && yum -y clean all

COPY galaxy-api/Pipfile \
    galaxy-api/Pipfile.lock \
    /tmp/galaxy-api/

RUN python3.6 -m venv "${GALAXY_VENV}" \
    && source "${GALAXY_VENV}/bin/activate" \
    && pip --no-cache-dir install -U pip wheel pipenv \
    && cd /tmp/galaxy-api \
    && PIPENV_VERBOSITY=-1 pipenv install --ignore-pipfile

WORKDIR /code/

ENV PATH="/venv/bin:$PATH"

COPY docker/galaxy-api/entrypoint.sh /entrypoint
ENTRYPOINT [ "/entrypoint" ]
CMD [ "run" ]
