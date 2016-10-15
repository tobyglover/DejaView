from __future__ import unicode_literals

from django.db import models

class Events(models.Model):
	external_id = models.CharField(max_length=200, unique=True)
	name = models.CharField(max_length=200)
	description = models.CharField(max_length=200)
	eventImage = models.CharField(max_length=200)
	created = models.DateTimeField(auto_now=True)

class Images(models.Model):
	uri = models.CharField(max_length=200, unique=True)
	event = models.ForeignKey(Events, on_delete=models.DO_NOTHING)
	created = models.DateTimeField(auto_now=True)