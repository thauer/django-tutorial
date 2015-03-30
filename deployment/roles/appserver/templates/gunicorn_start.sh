#!/bin/bash
 
NAME="django_tutorial"
DJANGODIR={{ project_home }}/mysite
SOCKFILE={{ project_home }}/run/gunicorn.sock
USER={{ webapp_user }}
GROUP={{ webapp_user }}
NUM_WORKERS=1
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
