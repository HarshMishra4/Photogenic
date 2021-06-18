from django.shortcuts import render
from rest_framework import views, status, generics
from .models import User, Comment, Follow, Post, ReportPost
from rest_framework.response import Response
from .serializer import UserSerializer, PostSerializer, CommentSerializer, UserProfileSerializer
from rest_framework.pagination import PageNumberPagination
from django.core.files.base import ContentFile
import base64

# * Completed
class UserProfile(views.APIView):
    permission_classes = ()
    def get_object(self, id):
        try:
            return User.objects.get(id=id)
        except (User.DoesNotExist, AttributeError):
            return None

    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        userdetail = User.objects.get(id=request.GET.get('userId'))
        serializer = UserSerializer(userdetail, context={'request': request}).data
        serializer['posts'] = PostSerializer(Post.objects.filter(author= userdetail,isReported=False).order_by("-postedOn"),many=True,context={'request':request}).data
        return Response(serializer, status=status.HTTP_200_OK)

    def post(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        try:
            user = User.objects.get(email=request.data['email'])
            serializeredData = UserSerializer(user, context={'request':request})
            return Response(serializeredData.data,status=status.HTTP_200_OK)
        except User.DoesNotExist:
            try:
                user = User(
                    name = request.data['name'],
                    email = request.data['email'],
                    userId = request.data['email'].split('@')[0],
                    isVerified = False,
                    avatar = ContentFile(base64.b64decode(request.data['avatar']),f"{request.data['email'].split('@')[0]}.jpg")
                ).save()
                serializeredData = UserSerializer(user, context= {'request': request}).data
                serializeredData['posts'] = PostSerializer(Post.objects.filter(author= user,isReported=False).order_by("-postedOn"),many=True,context={'request':request}).data
                return Response(serializeredData,status=status.HTTP_201_CREATED)
            except KeyError:
                return Response(status=status.HTTP_400_BAD_REQUEST)

    def put(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)
        userdetail = self.get_object(request.data['userId'])
        try:
            userdetail.bio = request.data["bio"]
            userdetail.dob = request.data["dob"]
            userdetail.name = request.data["name"]
            # userdetail.userId = request.data["userId"]
            userdetail.gender = request.data["gender"]

            if not str(request.data["avatar"]).startswith(('http','https')):
                userdetail.avatar = ContentFile(base64.b64decode(request.data['avatar']),f"{request.data['email'].split('@')[0]}.jpg")

            userdetail.save()
            serializeredData = UserSerializer(userdetail, context={'request': request}).data
            serializeredData['posts'] = PostSerializer(Post.objects.filter(author= userdetail,isReported=False).order_by("-postedOn"),many=True,context={'request':request}).data
            return Response(serializeredData, status=status.HTTP_200_OK)
        except KeyError:
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        userdetail = self.get_object(request.data['userId'])
        userdetail.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


# * Completed
class UserProfileForPublic(views.APIView):
    permission_classes = ()
    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        try:
            user = User.objects.get(id=request.GET.get('userId'))
            serializer = UserProfileSerializer(user, context={'request':request}).data
            serializer['posts'] = PostSerializer(Post.objects.filter(author= user,isReported=False).order_by("-postedOn"),many=True,context={'request':request}).data
            return Response(serializer, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response(status= status.HTTP_400_BAD_REQUEST)

# * Completed
class PostAPIView(views.APIView):
    permission_classes = ()
    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        try:
            post = Post.objects.filter(id__in= (int(i) for i in request.GET.get('postIds')), isReported=False).order_by("-postedOn")
            serializer = PostSerializer(post,many=True,context={'request':request})
            return Response(serializer.data ,status=status.HTTP_200_OK)
        except Post.DoesNotExist:
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)
        try:
            user = User.objects.get(id= int(request.data['userId']))
            Post(
                author = user,
                caption = request.data['caption'],
                image = ContentFile(base64.b64decode(request.data['image']),f'{user.userId}.jpg')
            ).save()
            postdetail = PostSerializer(Post.objects.filter(author=int(request.data['userId'])).order_by("-postedOn"), context={'request': request}, many=True)
            return Response(postdetail.data,status=status.HTTP_201_CREATED)
        except (User.DoesNotExist, KeyError, AttributeError):
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)
        try:
            Post.objects.get(id=request.GET.get(['postId'])).delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Post.DoesNotExist:
            return Response(status=status.HTTP_400_BAD_REQUEST)

# * Completed
class CommentAPIView(views.APIView):
    permission_classes = ()   
    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)
            
        # http://127.0.0.1:8000/comment?postId=1
        comments = Comment.objects.filter(post=request.GET.get('postId'))
        serializer = CommentSerializer(comments,many=True,context={'request':request})
        return Response(serializer.data,status=status.HTTP_200_OK)

    def post(self, request):
        try:
            Comment(
                author = User.objects.get(id=request.data['userId']),
                post = Post.objects.get(id=request.data['postId']),
                content = request.data['content']
            ).save()
            # serializer = CommentSerializer(Comment.objects.filter(post=post),many=True,context={'request':request})
            return Response(status=status.HTTP_200_OK)
        except (User.DoesNotExist,Post.DoesNotExist):
            return Response(status=status.HTTP_400_BAD_REQUEST)
    
    def delete(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        try:
            Comment.objects.get(id=request.GET.get('commentId')).delete()
            return Response(status=status.HTTP_200_OK)
        except Comment.DoesNotExist:
            return Response(status=status.HTTP_400_BAD_REQUEST)

# * Completed
class SearchEngine(views.APIView):
    # Use http://127.0.0.1:8000/search?query=har
    permission_classes = ()
    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        users = User.objects.filter(userId__startswith = request.GET.get('query'))
        serializer = UserProfileSerializer(users, many=True, context={'request':request})
        return Response(serializer.data, status=status.HTTP_200_OK)

# * Completed
class LikePost(views.APIView):
    permission_classes = ()
    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)
        try:
            post = Post.objects.get(id=request.GET.get('postId'))
            post.likes += 1
            post.save()
            return Response(status= status.HTTP_200_OK)
        except Post.DoesNotExist:
            return Response(status= status.HTTP_400_BAD_REQUEST)

# * Completed
class FollowUser(views.APIView):
    permission_classes = ()
    def get(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)

        userId, followerId = request.GET.get('userId'),request.GET.get('followerId') # replace by userIds
        if(userId == followerId):
            return Response(status= status.HTTP_400_BAD_REQUEST)
        # If Follower is already following User then unfollow
        follow = Follow.objects.filter(user= userId, follower= followerId)
        if len(follow) != 0:
            follow.delete()
            return Response(status= status.HTTP_204_NO_CONTENT)
        else:
            # Else Follow the User
            Follow(user= userId, follower= followerId).save()
            return Response(status= status.HTTP_200_OK)

# * Completed
class Reportpost(views.APIView):
    permission_classes = ()
    # {
    #     'postId':'1',
    #     'email':'',
    #     'type' : ''
    # }
    def post(self, request):
        if self.request.META['HTTP_USER_AGENT'] != 'Dart/2.10 (dart:io)':
            return Response(status= status.HTTP_401_UNAUTHORIZED)
            
        try:
            post = Post.objects.get(id= int(request.data['postId']))
            post.isReported = True
            post.save()
            ReportPost(post= post,reportedBy=request.data['email'],reportType= request.data['type']).save()
            return Response(status= status.HTTP_200_OK)
        except Post.DoesNotExist:
            return Response(status= status.HTTP_400_BAD_REQUEST)

# * Completed
class PostPaginationClass(PageNumberPagination):
    page_size = 10

# * Completed
class LatestPosts(generics.ListAPIView):
    permission_classes = ()
    serializer_class = PostSerializer
    pagination_class = PostPaginationClass

    def get_queryset(self):
        return Post.objects.filter(isReported=False).order_by("-postedOn")