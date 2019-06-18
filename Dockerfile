FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    GALAXY_CODE=/code \
    GALAXY_VENV=/venv

RUN yum -y install epel-release \
    && yum -y install \
        git \
        python36 \
        python36-devel \
    && yum -y clean all

WORKDIR /code/

COPY galaxy-common/Pipfile galaxy-common/Pipfile.lock \
     /tmp/galaxy-common/
COPY galaxy-importer/Pipfile galaxy-worker/Pipfile.lock \
     /tmp/galaxy-worker/
COPY galaxy-worker/Pipfile galaxy-worker/Pipfile.lock \
     /tmp/galaxy-worker/
COPY galaxy-api/Pipfile galaxy-api/Pipfile.lock \
     /tmp/galaxy-api/


RUN python3.6 -m venv "${GALAXY_VENV}" \
    && source "${GALAXY_VENV}/bin/activate" \
    && pip --no-cache-dir install -U pip wheel pipenv \
    && cd /tmp/galaxy-common && pipenv install \
    && cd /tmp/galaxy-importer && pipenv install \
    && cd /tmp/galaxy-worker && pipenv install \
    && cd /tmp/galaxy-api && pipenv install

COPY entrypoint.sh /entrypoint

ENTRYPOINT ["/entrypoint"]
