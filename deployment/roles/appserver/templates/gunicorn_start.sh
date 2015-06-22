#!/bin/bash
 
NAME="django-tutorial"
DJANGODIR={{ webapp.root }}
SOCKFILE={{ webapp.root }}/gunicorn.sock
USER={{ webapp.user }}
GROUP={{ webapp.group }}
NUM_WORKERS=1
DJANGO_SETTINGS_MODULE=mysite.settings_production    # which settings file should Django use
DJANGO_WSGI_MODULE=mysite.wsgi                       # WSGI module name
 
echo "Starting $NAME as `whoami`"
 
# Activate the virtual environment
cd $DJANGODIR
source {{ webapp.virtualenv }}/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
 
# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR
 
# Start your Django Unicorn - (do not use --daemon under supervisor)
exec {{ webapp.virtualenv }}/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=0.0.0.0:8002 \
  --log-level=info \
  --log-file=-
