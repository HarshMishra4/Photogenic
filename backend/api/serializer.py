from rest_framework import serializers
from .models import User, Comment, Follow, Post

# For User
class UserSerializer(serializers.ModelSerializer):
    follower = serializers.SerializerMethodField(read_only=True)
    following = serializers.SerializerMethodField(read_only=True)
    class Meta:
        model = User
        fields = ["id", "name", "email", "userId", "gender", "isVerified", "isBlocked", "bio", "dob", "avatar", 'follower', 'following']
    
    def get_follower(self, object):
        return Follow.objects.filter(user= object.id).count()    
    
    def get_following(self, object):
        return [i.follower for i in Follow.objects.filter(follower= object.id)]


# For Public
class UserProfileSerializer(serializers.ModelSerializer):
    follower = serializers.SerializerMethodField(read_only=True)
    following = serializers.SerializerMethodField(read_only=True)
    class Meta:
        model = User
        fields = ["id", "bio", "name", "userId", "isVerified", "avatar", 'follower', 'following']
    
    def get_follower(self, object):
        return Follow.objects.filter(user= object.id).count()    
    
    def get_following(self, object):
        return [i.follower for i in Follow.objects.filter(follower= object.id)]

#  Post Serializer
class PostSerializer(serializers.ModelSerializer):
    author = UserProfileSerializer()

    class Meta:
        model = Post
        fields = '__all__'


# Comment Serializer
class CommentSerializer(serializers.ModelSerializer):
    author = UserProfileSerializer()

    class Meta:
        model = Comment
        fields = '__all__'
