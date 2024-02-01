from django.contrib import admin

from .models import Key


@admin.register(Key)
class KeyAdmin(admin.ModelAdmin):
    list_display = (
        "value",
        "creation_datetime",
        "editing_datetime",
    )

    search_fields = ("value",)


# Register your models here.
