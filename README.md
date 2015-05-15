# django-tutoriral

I created this project as a log of following the [Django tutorial](https://docs.djangoproject.com/en/1.8/) at the Django project website. I worked with version 1.8. 

Contents:

* [virtualenv](virtualenv): For sanity, we use virtualenv. (It is automatically installed by ansible on ubuntu 15.04)
* [mysite](mysite): This is the application which gets created during the tutorial
* [deployment](deployment): This folder contains an [ansible](http://docs.ansible.com) playbook which deploys the tutorial application in an nginx-gunicorn-postgresql environment. It also auto-deploys the local [virtualenv](virtualenv).

## Production environment

The [deployment](deployment) directory encodes the installation of the tutorial application into a server environment with the following components:

* webserver running nginx
    - listens on port 80
    - serves static content from local directory, `/webapps/mysite/static`
    - proxies everything else to appserver, port 8002
* dbserver running postgresql
    - listens on port 5432 to the local intranet (10.15.20.0/24)
    - database `mydatabase`, accessible to `mydatabaseuser:mypassword`
* appserver
    - runs supervisord to supervise gunicorn
    - runs gunicorn
    - contains django app within gunicorn