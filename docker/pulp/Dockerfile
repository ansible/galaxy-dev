FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    PULP_CODE=/code \
    PULP_VENV=/venv \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings

RUN yum -y install epel-release \
    && yum -y install \
        git \
        python36 \
        python36-devel \
    && yum -y clean all

RUN mkdir -p /var/run/pulp

COPY docker/pulp/requirements.txt /tmp/pulp/

RUN python3.6 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip --no-cache-dir install -U pip wheel \
    && cd /tmp/pulp \
    && pip install -r requirements.txt

WORKDIR /code/

ENV PATH="/venv/bin:$PATH"

COPY docker/pulp/entrypoint.sh /entrypoint
ENTRYPOINT [ "/entrypoint" ]
