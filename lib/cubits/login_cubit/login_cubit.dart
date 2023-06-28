import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_club/cache_helper.dart';
import 'package:intl/intl.dart';
import 'package:st_club/models/comment_model.dart';

import 'package:st_club/models/my_user.dart';
import 'package:st_club/models/post_model.dart';

import './login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool isLoading = false;
  bool isUploading = false;
  bool isUpdateing = false;

  void register({
    required String name,
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    isLoading = true;
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        email: email,
        uId: value.user!.uid,
        name: name,
      );
      emit(LoginSuccessState(value.user!.uid));
      isLoading = false;
    }).catchError((error) {
      emit(LoginErrorState(error: error.toString()));
    });
  }

  void signIN({email, password}) {
    emit(LoginLoadingState());
    isLoading = true;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));
      isLoading = false;
    }).catchError((error) {
      emit(LoginErrorState(error: error.toString()));
    });
  }

  void createUser(
      {required String email, required String name, required String uId}) {
    userModel = MyUser(
        userEmail: email,
        userId: uId,
        userName: name,
        bio: "",
        userImage:
            "https://cdn.dribbble.com/users/759083/screenshots/4786033/ddd.jpg?compress=1&resize=800x600",
        userProfileImage:
            "https://cdn.dribbble.com/users/56251/screenshots/14696619/media/0b2a6cada922652e64fab0f07dadd3f9.png?compress=1&resize=800x600");

    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(userModel!.toMap())
        .then((value) {
      CacheHelper.saveData(key: 'uId', value: uId);
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error: error.toString()));
    });
  }

  MyUser? userModel;

  void getUserData(String? id) {
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      userModel = MyUser.fromJson(value.data()!);
      debugPrint("*************${userModel!.userId}");
      debugPrint(userModel!.userEmail);
      debugPrint(userModel!.userName);

      emit(GetUserSuccess());
    }).catchError((error) {
      debugPrint(error.toString());

      emit(GetUserError(
        message: error.toString(),
      ));
    });
  }

  File? profileImage;
  var picker = ImagePicker();

  Future pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
    } else {
      debugPrint("No Image Selected");
      emit(PickProfileImageErrorState());
    }
  }

  File? coverImage;

  Future pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PickCoverImageSuccessState());
    } else {
      debugPrint("No Image Selected");
      emit(PickCoverImageErrorState());
    }
  }

  void uploadProfileImage() {
    emit(ProfileUploadLoadingState());
    isUploading = true;
    FirebaseStorage.instance
        .ref()
        .child("user/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((val) {
      val.ref.getDownloadURL().then((value) {
        updateUerDate(profileImage: value);
        coverImage = null;
        profileImage = null;
        isUploading = false;
        emit(ProfileUploadSuccessState());
      }).catchError((error) {
        emit(ProfileGetUrlErrorState());
      });
    }).catchError((error) {
      emit(ProfileUploadErrorState(message: error.toString()));
    });
  }

  void uploadCoverImage() {
    emit(UploadCoverImageLoadingState());
    isUploading = true;
    FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((val) {
      val.ref.getDownloadURL().then((value) {
        updateUerDate(coverImage: value);
        coverImage = null;
        profileImage = null;
        isUploading = false;
        emit(CoverImageUploadSuccessState());
      }).catchError((error) {
        emit(CoverImageGetUrlErrorState());
      });
    }).catchError((error) {
      emit(CoverImageUploadErrorState(message: error.toString()));
    });
  }

  void updateUerDate({
    String? profileImage,
    String? coverImage,
    String? userName,
    String? bio,
  }) {
    MyUser user = MyUser(
        userEmail: userModel!.userEmail,
        userId: userModel!.userId,
        userName: userName ?? userModel!.userName,
        bio: bio ?? userModel!.bio,
        userProfileImage: profileImage ?? userModel!.userProfileImage,
        userImage: coverImage ?? userModel!.userImage);
    emit(UpdateUserDataLoadingState());
    isUpdateing = true;
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.userId)
        .update(user.toMap())
        .then((value) {
      isUpdateing = false;
      coverImage = null;
      profileImage = null;
      emit(UpdateUserDataSuccessState());

      getUserData(userModel!.userId);
    }).catchError((error) {
      emit(UpdateUserDataErrorState(message: error.toString()));
    });
  }

  File? postImage;

  Future pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PickPostImageSuccessState());
    } else {
      debugPrint("No Image Selected");
      emit(PickPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageSuccessState());
  }

  MyPost? post;

  void createPost({String? postText}) {
    if (postImage == null) {
      post = MyPost(
          userId: userModel!.userId,
          userName: userModel!.userName,
          userProfileImage: userModel!.userProfileImage,
          postText: postText,
          dateTime: DateFormat.yMEd().add_jms().format(DateTime.now()));
      FirebaseFirestore.instance
          .collection("posts")
          .add(post!.toMap())
          .then((value) {
        emit(CreatePostSuccessState());
        getPosts();
      }).catchError((error) {
        emit(CreatePostErrorState(message: error.toString()));
      });
    } else {
      emit(UploadPostImageLoadingState());
      isUploading = true;
      FirebaseStorage.instance
          .ref()
          .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
          .putFile(postImage!)
          .then((val) {
        isUploading = false;
        emit(UploadPostImageSuccessState());
        val.ref.getDownloadURL().then((imageLink) {
          emit(GetPostImageUrlSuccessState());
          post = MyPost(
              userId: userModel!.userId,
              userName: userModel!.userName,
              userProfileImage: userModel!.userProfileImage,
              postText: postText,
              postImage: imageLink,
              dateTime: DateFormat.yMEd().add_jms().format(DateTime.now()));
          FirebaseFirestore.instance
              .collection("posts")
              .add(post!.toMap())
              .then((value) {
            postImage = null;
            emit(CreatePostSuccessState());
            getPosts();
          });
        }).catchError((error) {
          emit(GetPostImageUrlErrorState(message: error.toString()));
        });
      }).catchError((error) {
        emit(UploadPostImageErrorState(message: error.toString()));
      });
    }
  }

  List<MyPost>? posts = [];
  List<String>? postsId = [];
  List<String>? commentsId = [];
  List<MyComment>? comments = [];
  List<int>? postsLikes = [];
  List<int>? postsCommentsNo = [];

  void getPosts() {
    posts = [];
    postsId = [];
    postsLikes = [];
    postsCommentsNo = [];

    emit(GetPostsLoadingState());
    FirebaseFirestore.instance.collection("posts").get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('comments').get().then((value) {
          postsCommentsNo!.add(value.docs.length);
        }).catchError((error) {});
        element.reference.collection('likes').get().then((value) {
          postsLikes!.add(value.docs.length);
          postsId!.add(element.id);
          posts!.add(MyPost.fromJson(element.data()));
          emit(GetPostsSuccessState());
        }).catchError((error) {
          emit(LikePostErrorState(message: error.toString()));
        });
      });
    }).catchError((error) {
      emit(GetPostsErrorState(message: error.toString()));
    });
  }

  void getComments() {
    comments = [];
    commentsId = [];
    emit(GetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .doc()
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        commentsId!.add(element.id);
        print(MyComment.fromJson(element.data()));
        comments!.add(MyComment.fromJson(element.data()));
        emit(GetCommentsSuccessState());
      });
    }).catchError((error) {
      emit(GetCommentsErrorState(message: error.toString()));
    });
  }

  void likePost(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.userId)
        .set({'like': true}).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState(message: error.toString()));
    });
  }

  MyComment? commentModel;

  void addComment({String? postId, String? comment}) {
    commentModel = MyComment(
        userId: userModel!.userId,
        userName: userModel!.userName,
        userProfileImage: userModel!.userProfileImage,
        commentText: comment);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.userId)
        .set(commentModel!.toMap())
        .then((value) {
      emit(AddCommentSuccessState());
    }).catchError((error) {
      emit(AddCommentErrorState(message: error.toString()));
    });
  }
}