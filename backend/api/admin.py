from django.contrib import admin
from .models import User, Comment, Follow, Post, ReportPost

# Register your models here.
admin.site.register((User, Comment, Follow, Post, ReportPost))