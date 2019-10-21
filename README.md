# Automation Hub Backend

Backend API for Automation Hub. The frontend project is [ansible-hub-ui](https://github.com/ansible/ansible-hub-ui).

## OpenAPI Spec

View the latest version of the spec by [clicking here](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/ansible/galaxy-api/master/openapi/openapi.yaml).

## Creating a Local DEV environment

To configure and run the API locally follow these steps: 

1. Clone `galaxy-dev` repository

   ```
   $ git clone git@github.com:ansible/galaxy-dev.git
   ```

2. Clone submodule

   ```
   $ cd galaxy-dev/

   $ git submodule update --init --remote
   ```

3. (Workaround) Checkout pulp_ansible version 0.2.0b3

   ```
   $ cd pulp-ansible/

   $ git checkout 0.2.0b3
   ```

4. Build development docker image

   ```
   $ make docker/build
   ```

5. Run migrations

   ```
   $ make docker/run-migrations
   ```

6. Run development environment

   ```
   $ make docker/up
   ```

7. Create galaxy admin user

   ```
   $ docker-compose run --rm galaxy-api manage createsuperuser

   Username: admin
   Password: admin
   ```

8. Create pulp admin user

   **Note** If you want to use different user credentials, make sure pulp credentials
   are updated in `galaxy-api/galaxy_api/settings.py`.

   ```
   $ docker-compose run --rm pulp-api manage createsuperuser

   Username: admin
   Password: admin
   ```

9. Create pulp repository and distribution

   ```
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
   ```

**Note** If the API is running without a UI, authorization can be disabled for testing
purposes by commenting default permission classes in `galaxy-api/galaxy_api/settings.py`

```
REST_FRAMEWORK = {
    # ...
    'DEFAULT_PERMISSION_CLASSES': [
        # 'rest_framework.permissions.IsAuthenticated',
        # 'galaxy_api.auth.auth.RHEntitlementRequired',
    ],
    # ...
}
```

- Galaxy API URL: http://localhost:5001/api/automation-hub/v3/
- Galaxy admin site URL: http://localhost:5001/admin/
- Pulp API URL: http://localhost:5002/

For instructions on setting up and running the Automation Hub frontend, visit the [ansible-hub-ui project](https://github.com/ansible/ansible-hub-ui).
