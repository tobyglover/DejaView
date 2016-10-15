from django.conf.urls import url
from . import views

app_name = 'api'
urlpatterns = [
    url(r'^$', views.index, name="index"),
    # ex: /api/createNewUser/
    url(r'^createEvent$', views.createEvent, name="createEvent"),
    url(r'^uploadImage$', views.uploadImage, name="uploadImage"),
    url(r'^joel/(?P<filename>[^/]+)$', joel.as_view())
    #url(r'^createNewPoll/(?P<userKey>[0-9a-f]+)/$', views.createNewPoll, name="createNewPoll"),
]
