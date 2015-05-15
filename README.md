# django-tutoriral

I created this project as a log of following the [Django tutorial](https://docs.djangoproject.com/en/1.8/) at the Django project website. I worked with version 1.8. 

Contents:

* [virtualenv](virtualenv): For sanity, we use virtualenv. (It is automatically installed by ansible on ubuntu 15.04)
* [mysite](mysite): This is the application which gets created during the tutorial
* [deployment](deployment): This folder contains an [ansible](http://docs.ansible.com) playbook which deploys the tutorial application in an nginx-gunicorn-postgresql environment. It also auto-deploys the local [virtualenv](virtualenv).

## nginx

```
upstream app_server_djangoapp {
    server localhost:8002 fail_timeout=0; 
}

server {
    listen 80;
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;

        if (!-f $request_filename) {
            proxy_pass http://app_server_djangoapp;
            break;
        }
    }
}
```

## gunicorn

```
CONFIG = {
    'mode': 'wsgi',
    'working_dir': '/var/www/mysite',
    'python': '/usr/bin/python',
    'args': (
        '--bind=127.0.0.1:8002',
        '--workers=16',
        '--timeout=60',
        'mysite.wsgi:application',
    ),
}
```

### django