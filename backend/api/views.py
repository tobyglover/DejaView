from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django import forms

from .models import Events, Images

from random import randint
import os.path
from hexahexacontadecimal import hhc
from .ImageHandler import ImageHandler

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
		try:
			eventId = request.GET.get("eventId")
			event = Events.objects.get(external_id=eventId)
			if request.method == "POST":
				uploaded_file = request.FILES['file']
				baseDir = "/tmp/"
				fileId = hhc(randint(0, 66**8))
				filePath = baseDir + fileId + uploaded_file.name

				with open(filePath, 'wb+') as destination:
					for chunk in uploaded_file.chunks():
						destination.write(chunk)

				s3Key = ImageHandler().uploadFile(eventId, fileId, filePath)
				image = Images(s3Key=s3Key, event=event)
				image.save()

				returnContent["statusCode"] = 200
				returnContent["reason"] = "all good"
			else:
				returnContent["statusCode"] = 400
				returnContent["reason"] = "Incorrect method or data"
		except Events.DoesNotExist:
			returnContent["statusCode"] = 400
			returnContent["reason"] = "EventId does not exist"
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "EventId not provided"

	return JsonResponse(returnContent, status=returnContent["statusCode"])

def getImages(request):
	returnContent = {}

	if "eventId" in request.GET:
		eventId = request.GET.get("eventId")
		try:
			event = Events.objects.get(external_id=eventId)
			images = Images.objects.filter(event=event)

			returnedImages = []
			for image in images:
				imageData = {added:image.created, url:"https://s3.amazonaws.com/dejaview/" + image.s3Key}
				returnedImages.append(imageData)

			returnContent["images"] = returnedImages
			returnContent["statusCode"] = 200
			returnContent["eventId"] = eventID

		except Events.DoesNotExist:
			returnContent["statusCode"] = 400
			returnContent["reason"] = "EventId does not exist"
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "EventId not provided"

	return JsonResponse(returnContent, status=returnContent["statusCode"])
