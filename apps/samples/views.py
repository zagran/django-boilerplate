from drf_spectacular.utils import extend_schema
from rest_framework import viewsets

from apps.samples.models import Key
from apps.samples.serializers import KeySerializer


@extend_schema(
    tags=["[Samples] Key"],
    description="Sample description",
    summary="Sample summary",
    responses={200: KeySerializer(many=True)},
)
class KeyViewSet(viewsets.ModelViewSet):
    queryset = Key.objects.order_by("-id")
    serializer_class = KeySerializer
