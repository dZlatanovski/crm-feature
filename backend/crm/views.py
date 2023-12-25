import csv
from rest_framework import viewsets
from django.conf import settings
from rest_framework.response import Response
import uuid

class OrdersViewSet(viewsets.ViewSet):
    authentication_classes = []
    permission_classes = []
    def list(self, request):
        data = []
        with open(f"{settings.BASE_DIR}/proton/data/orders.csv") as f:
            reader = csv.DictReader(f)
            data = list(reader)
        for row in data:
            del row['']
            # We need a unique identifier so that we can properly render and manipulate lists on the front end
            row['Id'] = str(uuid.uuid4())
        return Response(data)

