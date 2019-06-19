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

    $ docker-compose build

#. Run migrations::

    $ docker-compose run --rm galaxy-api manage migrate

#. Run development environment::

    $ docker-compose up


Installing local dependencies\*
===============================

`optional`

#. Go to ``galaxy-dev`` directory.

#. Create and activate virtual environment::

    $ python3 -m venv .venv

    $ source .venv/bin/activate

#. Install pipenv::

    $ pip install pipenv

#. Install projects dependencies::

    $ git submodule foreach pipenv install

#. Install projects in development mode::

    $ git submodule foreach pip install -e .


Configuring local management script\*
=====================================

`optional`

#. Copy `.env.example` to `.env`. `.env.example` contains defaults for local environment, so normally it should work
   without customizations.

#. Set `SECRET_KEY` parameter.

#. Now you can run `galaxy-manage` command from local environment.