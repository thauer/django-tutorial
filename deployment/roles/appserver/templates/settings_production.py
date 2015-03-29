try:
    from settings import *
except ImportError:
    pass

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ database }}',
        'USER': '{{ dbuser }}',
        'PASSWORD': '{{ dbpass }}',
        'HOST': '10.15.20.83',
        'PORT': '5432',
    }
}
