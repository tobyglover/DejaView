from __future__ import unicode_literals

from django.db import models

class Events(models.Model):
	external_id = models.CharField(max_length=10, unique=True)
	name = models.CharField(max_length=200)
	description = models.CharField(max_length=200, blank=True)
	eventImage = models.CharField(max_length=200, blank=True)
	created = models.DateTimeField(auto_now=True)

class Images(models.Model)
	event = models.ForeignKey(Events, on_delete=models.DO_NOTHING)
	s3Key = models.CharField(max_length=200, blank=True)
	created = models.DateTimeField(auto_now=True)