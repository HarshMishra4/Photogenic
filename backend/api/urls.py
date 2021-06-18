from django.contrib import admin
from django.urls import path, include
from .views import LatestPosts, UserProfile, UserProfileForPublic, PostAPIView, SearchEngine, CommentAPIView, LikePost, FollowUser, Reportpost

urlpatterns = [
    path('userdetail', UserProfile.as_view()),
    path('user', UserProfileForPublic.as_view()),
    path('post/', PostAPIView.as_view()),
    path('feed/', LatestPosts.as_view()),
    path('search', SearchEngine.as_view()),
    path('comment', CommentAPIView.as_view()),
    path('like', LikePost.as_view()),
    path('follow', FollowUser.as_view()),
    path('report/', Reportpost.as_view()),
]