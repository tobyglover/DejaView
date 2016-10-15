import boto3

class ImageHandler:

	def __init__(self):
		client = boto3.client(
			    's3',
			    aws_access_key_id='',
    			aws_secret_access_key='')
		self.bucket = s3.Bucket('dejaview')

	def uploadFile(self, eventId, fileId, filePath):
		s3key = eventId + "/"  + fileId
		self.s3.upload_file(filePath, 'dejaview', s3key)
		return s3key


