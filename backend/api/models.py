from django.db import models

# todo add unique token field for User table
class User(models.Model):
    bio = models.CharField(default="",max_length=500)
    dob = models.CharField(default="",max_length=100)
    name = models.CharField(max_length=150)
    email = models.CharField(max_length=150)
    userId = models.CharField(max_length=20)
    gender = models.CharField(default="",max_length=10)
    isVerified = models.BooleanField(default=False)
    isBlocked = models.BooleanField(default=False)
    createdOn = models.DateTimeField(auto_now_add=True)
    avatar = models.ImageField('image', upload_to='avatars/')

    def __str__(self):
        return self.userId    

class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    likes = models.IntegerField(default=0)
    caption = models.CharField(max_length=1500)
    isReported = models.BooleanField(default=False)
    postedOn = models.DateTimeField(auto_now_add=True)
    image = models.ImageField('image', upload_to='posts/')

class Comment(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    post = models.ForeignKey(Post, on_delete=models.CASCADE)
    content = models.CharField(max_length=1000)
    commentedOn = models.DateTimeField(auto_now_add=True)

class Follow(models.Model):
    user = models.CharField(max_length=10)
    follower = models.CharField(max_length=10)

class ReportPost(models.Model):
    post = models.ForeignKey(Post, on_delete= models.CASCADE)
    reportType = models.CharField(max_length=20)
    reportedBy = models.CharField(max_length=150)

    def __str__(self):
        return self.reportType