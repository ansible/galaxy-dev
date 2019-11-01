FROM centos:7

ENV PYTHONUNBUFFERED=1 \
    LANG=en_US.UTF-8 \
    PULP_CODE=/code \
    PULP_VENV=/venv \
    PULP_SETTINGS=/etc/pulp/settings.py \
    DJANGO_SETTINGS_MODULE=pulpcore.app.settings \
    ANSIBLE_TEST_VENV=/venv_ansible_test

RUN yum -y install epel-release \
    && yum -y install \
        git \
        python36 \
        python36-devel \
    && yum -y clean all

RUN mkdir -p /var/run/pulp \
    /var/lib/pulp/tmp \
    "${ANSIBLE_TEST_VENV}"

COPY docker/pulp/requirements.txt /tmp/pulp/
COPY docker/pulp/requirements_ansible_test.txt /tmp/ansible_test/

RUN python3.6 -m venv "${ANSIBLE_TEST_VENV}" \
    && source "${ANSIBLE_TEST_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        'pip<19.0' \
        wheel \
    && cd /tmp/ansible_test \
    && pip install --default-timeout 100 -r requirements_ansible_test.txt \
    && chmod -R a+rwX "${ANSIBLE_TEST_VENV}"/lib64/python*

RUN python3.6 -m venv "${PULP_VENV}" \
    && source "${PULP_VENV}/bin/activate" \
    && pip --no-cache-dir install -U \
        'pip<19.0' \
        wheel \
    && cd /tmp/pulp \
    && pip install --default-timeout 100 -r requirements.txt

COPY docker/pulp/settings.py /etc/pulp/settings.py
COPY docker/pulp/ansible.cfg /etc/ansible/ansible.cfg

ENV PATH="/venv/bin:$PATH"

COPY docker/pulp/entrypoint.sh /entrypoint

VOLUME /data/

WORKDIR /code/

ENTRYPOINT [ "/entrypoint" ]
