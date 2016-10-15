from django.conf.urls import url
from . import views

app_name = 'api'
urlpatterns = [
    url(r'^$', views.index, name="index"),
    # ex: /api/createNewUser/
    url(r'^createEvent$', views.createEvent, name="createEvent"),
    url(r'^uploadImage/(?P<eventId>[a-zA-Z0-9_-.~]+)/$', views.uploadImage, name="uploadImage")
    #url(r'^createNewPoll/(?P<userKey>[0-9a-f]+)/$', views.createNewPoll, name="createNewPoll"),
]
