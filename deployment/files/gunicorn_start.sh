#!/bin/bash
 
NAME="hello_app"                                  # Name of the application
DJANGODIR=/webapps/hello_django/mysite            # Django project directory
SOCKFILE=/webapps/hello_django/run/gunicorn.sock  # we will communicte using this unix socket
USER=hello                                        # the user to run as
GROUP=webapps                                     # the group to run as
NUM_WORKERS=1                                     # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=mysite.settings            # which settings file should Django use
DJANGO_WSGI_MODULE=mysite.wsgi                    # WSGI module name
 
echo "Starting $NAME as `whoami`"
 
# Activate the virtual environment
cd $DJANGODIR
source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
 
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
 
# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=info \
  --log-file=-


# CONFIG = {
#   'mode': 'wsgi',
#   'working_dir': '/var/www/mysite',
#   'python': '/usr/bin/python',
#   'args': (
#       '--bind=127.0.0.1:8002',
#       '--workers=16',
#       '--timeout=60',
#       'mysite.wsgi:application',
#   ),
# }
