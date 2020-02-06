FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    PULP_CODE=/code \
    PULP_VENV=/venv \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings \
    ANSIBLE_TEST_VENV=/venv_ansible_test \
    ENABLED_COLLECTIONS="rh-python36 rh-postgresql12"


RUN yum -y install centos-release-scl-rh \
    && yum -y install \
        gcc \
        git \
        rh-python36 \
        rh-postgresql12-postgresql-libs \
        rh-postgresql12-postgresql-devel \
    && yum -y clean all

RUN mkdir -p /var/run/pulp \
    /var/lib/pulp/tmp \
    "${ANSIBLE_TEST_VENV}"

COPY docker/pulp/constraints.txt /tmp/constraints.txt
COPY docker/pulp/requirements_ansible_test.txt /tmp/ansible_test/
COPY pulp_ansible/ "${PULP_CODE}/pulp_ansible"

RUN source scl_source enable ${ENABLED_COLLECTIONS} \
    && python3.6 -m venv "${ANSIBLE_TEST_VENV}" \
    && source "${ANSIBLE_TEST_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        pip \
        wheel \
    && cd /tmp/ansible_test \
    && pip install \
        --no-cache-dir \
        --default-timeout 100 \
        -r requirements_ansible_test.txt \
    && chmod -R a+rwX "${ANSIBLE_TEST_VENV}"/lib64/python*

RUN source scl_source enable ${ENABLED_COLLECTIONS} \
    && python3.6 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        pip \
        wheel \
    && pip --no-cache-dir install \
        -c /tmp/constraints.txt \
        -e "${PULP_CODE}/pulp_ansible"

COPY docker/pulp/settings.py /etc/pulp/settings.py
COPY docker/pulp/ansible.cfg /etc/ansible/ansible.cfg

ENV PATH="/venv/bin:$PATH"

COPY docker/pulp/entrypoint.sh /entrypoint

VOLUME /data/

WORKDIR /code/

ENTRYPOINT [ "/entrypoint" ]
