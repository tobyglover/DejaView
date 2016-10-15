from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django import forms

from .models import Events

from random import randint
import os.path
from hexahexacontadecimal import hhc
from ImageHandler import ImageHandler

# Create your views here.
def index(request):
	return HttpResponse("You are at the api index.")

def createEvent(request):
	returnContent = {}

	if "name" in request.GET:
		event = Events(name=request.GET.get("name"))
		while True:
			external_id = hhc(randint(0, 66**4))
			if Events.objects.filter(external_id=external_id).count() == 0:
				break

		event.external_id = external_id
		if "description" in request.GET:
			event.description = request.GET.get("description")
		event.save()

		returnContent["statusCode"] = 200
		returnContent["eventId"] = event.external_id
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "Event name not provided"

	return JsonResponse(returnContent, status=returnContent["statusCode"])


def uploadImage(request):
	returnContent = {}

	if "eventId" in request.GET:
		eventId = request.GET.get("eventId")
		# TODO:check if this is real eventId

		if request.method == "POST":
			uploaded_file = request.FILES['file']
			baseDir = "/tmp/"
			fileId = hhc(randint(0, 66**8))
			filePath = baseDir + fileId + uploaded_file.name
			return HttpResponse("ok")
			with open(filePath, 'wb+') as destination:
				for chunk in uploaded_file.chunks():
					destination.write(chunk)

			ImageHandler().uploadFile(eventId, fileId, filePath)
		else:
			returnContent["statusCode"] = 400
			returnContent["reason"] = "Incorrect method or data"
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "EventId not provided"

	return JsonResponse(returnContent, status=returnContent["statusCode"])