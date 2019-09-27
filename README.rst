========================
Galaxy development tools
========================

Getting started
===============

#. Clone ``galaxy-dev`` repository::

    $ git clone git@github.com:ansible/galaxy-dev.git

#. Clone submodule::

    $ cd galaxy-dev/

    $ git submodule update --init --remote

#. (Workaround) Checkout pulp_ansible version 0.2.0b3::

    $ cd pulp_ansible/

    $ git checkout 0.2.0b3

#. Build development docker image::

    $ make docker/build

#. Run migrations::

    $ make docker/run-migrations

#. Run development environment::

    $ make docker/up

#. Create galaxy admin user::

    $ docker-compose run --rm galaxy-api manage createsuperuser

    Username: admin
    Password: admin

#. Create pulp admin user::

    $ docker-compose run --rm pulp-api manage createsuperuser

    Username: admin
    Password: admin

  .. note:: If you want to use different user credentials, make sure pulp credentials
        are updated in ``galaxy-api/galaxy_api/settings.py``.

#. Create pulp repository and distribution::

    $ docker-compose run --rm pulp-api manage shell

    Python 3.6.8 (default, Aug  7 2019, 17:28:10)
    [GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    (InteractiveConsole)

    >>> from pulpcore.app.models import Repository
    >>> from pulp_ansible.app.models import AnsibleDistribution

    >>> repo = Repository.objects.create(name='automation-hub')

    >>> AnsibleDistribution.objects.create(name='automation-hub', base_path='automation-hub', repository=repo)
    <AnsibleDistribution: automation-hub>

    >>> # Press <CTRL+D> to exit.

.. note:: If API is running without UI, authorization can be disabled for testing
          purposes but commenting default permission classes
          in ``galaxy-api/galaxy_api/settings.py``::

                REST_FRAMEWORK = {
                    # ...
                    'DEFAULT_PERMISSION_CLASSES': [
                        # 'rest_framework.permissions.IsAuthenticated',
                        # 'galaxy_api.auth.auth.RHEntitlementRequired',
                    ],
                    # ...
                }


* Galaxy API URL:  http://localhost:5001/api/automation-hub/v3/
* Galaxy admin site URL: http://localhost:5001/admin/
* Pulp API URL: http://localhost:5002/
