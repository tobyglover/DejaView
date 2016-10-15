from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django import forms

from .models import Events

from random import randint
import os.path
from hexahexacontadecimal import hhc

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

def uploadImage(request, eventId):
	returnContent = {}

	if request.method == "POST" and "image" in request.POST:
		baseDir = "/tmp/imgs/"
		while True:
			fileId = hhc(randint(0, 66**8))
			filePath = baseDir + fileId
			if not os.path.isfile(filePath):
				break

		with open(filePath, "wb") as fh:
			fh.write(request.POST.get("image").decode('base64'))

		ImageHandler().uploadFile(eventId, fileId, filePath)
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "Incorrect method or data"

	return JsonResponse(returnContent, status=returnContent["statusCode"])
