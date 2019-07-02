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

#. Build development docker image::

    $ make docker/build

#. Run migrations::

    $ make docker/run-migrations

#. Run development environment::

    $ make docker/up


Installing local dependencies\*
===============================

`optional`

#. Go to ``galaxy-dev`` directory.

#. Create and activate virtual environment::

    $ python3 -m venv .venv

    $ source .venv/bin/activate

#. Install pipenv::

    $ pip install pipenv

#. Install galaxy-api dependencies::

    $ cd galaxy-api
    $ pipenv install
    $ pip install -e .

Configuring local management script\*
=====================================

`optional`

#. Copy `.env.example` to `.env`. `.env.example` contains defaults for local environment, so normally it should work
   without customizations.

#. Set `SECRET_KEY` parameter.

#. Now you can run `galaxy-api-manage` command from local environment.
