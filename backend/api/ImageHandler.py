import boto3

class ImageHandler:

	def __init__(self):
		s3 = boto3.resource('s3')
		self.bucket = s3.Bucket('dejaview')

	def uploadFile(self, eventId, fileId, filePath):
		data = open(filePath, 'rb')
		self.bucket.put_object(Key=eventId + '/' + fileId, Body=data)


