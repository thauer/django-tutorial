#!/bin/bash
 
NAME="django_tutorial"                               # Name of the application
DJANGODIR=/webapps/django-tutorial/mysite            # Django project directory
SOCKFILE=/webapps/django-tutorial/run/gunicorn.sock  # we will communicte using this unix socket
USER=webapps                                         # the user to run as
GROUP=webapps                                        # the group to run as
NUM_WORKERS=1                                        # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=mysite.settings_production    # which settings file should Django use
DJANGO_WSGI_MODULE=mysite.wsgi                       # WSGI module name
 
echo "Starting $NAME as `whoami`"
 
# Activate the virtual environment
cd $DJANGODIR
source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
 
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
 
# Start your Django Unicorn - (do not use --daemon under supervisor)
exec ../bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=0.0.0.0:8002 \
  --log-level=info \
  --log-file=-
