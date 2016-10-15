from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django import forms

from .models import Events, Images

from random import randint
import os
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
		if "description" in request.POST:
			event.description = request.POST.get("description")
		event.save()

		returnContent["statusCode"] = 200
		returnContent["eventId"] = event.external_id
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "Event name not provided"

	return JsonResponse(returnContent, status=returnContent["statusCode"])


def uploadImage(request):
	acceptedExtensions = [".jpeg", ".jpg", ".png", ".img"]
	returnContent = {}

	if "eventId" in request.GET:
		try:
			eventId = request.GET.get("eventId")
			event = Events.objects.get(external_id=eventId)
			if request.method == "POST":
				uploaded_file = request.FILES['picture']
				uploadedFileName = uploaded_file.name
				filename, fileExtension = os.path.splitext(uploadedFileName)

				if not fileExtension.lower() in acceptedExtensions:
					returnContent["statusCode"] = 400
					returnContent["reason"] = "Incorrect filetype"

				else:
					baseDir = "/tmp/"
					fileId = hhc(randint(0, 66**8))
					filePath = baseDir + fileId + uploaded_file.name

					with open(filePath, 'wb+') as destination:
						for chunk in uploaded_file.chunks():
							destination.write(chunk)

					s3Key = ImageHandler().uploadFile(eventId, fileId + fileExtension, filePath)
					image = Images(s3Key=s3Key, event=event)

					if "forEventImage" in request.GET and request.GET.get("forEventImage") == "true":
						event.image = getImageDataAsDict(image).url
						event.save()
					else:
						image.save()

					os.remove(filePath)

					returnContent["statusCode"] = 200
					returnContent["imageData"] = getImageDataAsDict(image)
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

def getEventInfo(request):
	returnContent = {}

	if "eventId" in request.GET:
		eventId = request.GET.get("eventId")
		try:
			event = Events.objects.get(external_id=eventId)
			
			returnContent["name"] = event.name
			returnContent["statusCode"] = 200
			returnContent["eventId"] = eventId
			returnContent["description"] = event.description
			returnContent["eventImage"] = event.eventImage

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
			images = Images.objects.filter(event=event).order_by("created")

			returnedImages = []
			for image in images:
				imageData = getImageDataAsDict(image)
				returnedImages.append(imageData)

			returnContent["images"] = returnedImages
			returnContent["statusCode"] = 200
			returnContent["eventId"] = eventId

		except Events.DoesNotExist:
			returnContent["statusCode"] = 400
			returnContent["reason"] = "EventId does not exist"
	else:
		returnContent["statusCode"] = 400
		returnContent["reason"] = "EventId not provided"

	return JsonResponse(returnContent, status=returnContent["statusCode"])

def getImageDataAsDict(image):
	data = {"url":"https://s3.amazonaws.com/dejaview/" + image.s3Key}
	if image.created != None:
		data["added"] = image.created
	return data
