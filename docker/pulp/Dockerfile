FROM centos:8

ENV LANG=en_US.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PULP_CODE=/code \
    PULP_VENV=/venv \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings \
    ANSIBLE_TEST_VENV=/venv_ansible_test

RUN dnf install -y \
        glibc-langpack-en \
        git-core \
        gcc \
        python3 \
        python3-devel \
        libpq \
        libpq-devel \
    && dnf -y clean all

RUN mkdir -p /var/run/pulp \
    /var/lib/pulp/tmp \
    "${ANSIBLE_TEST_VENV}"

COPY docker/pulp/constraints.txt /tmp/constraints.txt
COPY docker/pulp/requirements_ansible_test.txt /tmp/ansible_test/
COPY pulp_ansible/ "${PULP_CODE}/pulp_ansible"

RUN python3 -m venv "${ANSIBLE_TEST_VENV}" \
    && source "${ANSIBLE_TEST_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        'pip>=20.0,<21.0' \
    && cd /tmp/ansible_test \
    && pip install \
        --no-cache-dir \
        --default-timeout 100 \
        -r requirements_ansible_test.txt \
    && chmod -R a+rwX "${ANSIBLE_TEST_VENV}"/lib64/python*

RUN python3 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip install --no-cache-dir -U \
        'pip>=20.0,<21.0' \
    && pip --no-cache-dir install \
        -c /tmp/constraints.txt \
        -e "${PULP_CODE}/pulp_ansible"

ENV PATH="${PULP_VENV}/bin:${PATH}"

COPY docker/pulp/settings.py /etc/pulp/settings.py
COPY docker/pulp/ansible.cfg /etc/ansible/ansible.cfg
COPY docker/pulp/entrypoint.sh /entrypoint


VOLUME /data/
WORKDIR /code/
ENTRYPOINT [ "/entrypoint" ]
