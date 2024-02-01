from django.db import models


class Key(models.Model):
    value = models.CharField(max_length=255, unique=True)
    creation_datetime = models.DateTimeField(auto_now_add=True)
    editing_datetime = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "sample_key"
        verbose_name = "Key"
        verbose_name_plural = "Keys"


# Create your models here.
