from django.shortcuts import render
from django.http import HttpResponse
from api.models import Events,Images
# from django.template import loader
from django.template.loader import render_to_string
import random

header = render_to_string('header.html')
footer = render_to_string('footer.html')

# Create your views here.
def index(request):
    return render(request, 'index.html', {'header': header, 'footer': footer})

def gallary(request, event_id):
    try:
        event = Events.objects.get(external_id=event_id)
        images = Images.objects.filter(event=event).order_by("created")
        return render(request, 'gallary.html', {'header': header, 'footer': footer, 'event': event, 'images': images})
        
    except Events.DoesNotExist:
        return render(request, 'gallary.html', {'header': header, 'footer': footer})

    