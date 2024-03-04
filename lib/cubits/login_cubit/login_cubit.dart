import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:st_club/cache_helper.dart';
import 'package:intl/intl.dart';
import 'package:st_club/models/comment_model.dart';

import 'package:st_club/models/my_user.dart';
import 'package:st_club/models/post_model.dart';

import '../../models/message_model.dart';
import '../../presentation/pages/add_post_page.dart';
import '../../presentation/pages/chat_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/users_page.dart';
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

    //FB
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      storeUserData(
        email: email,
        uId: value.user!.uid,
        name: name,
      );

      //FB
      emit(LoginSuccessState(value.user!.uid));
      isLoading = false;
    }).catchError((error) {
      emit(LoginErrorState(error: error.toString()));
    });
  }

  void signIN({email, password}) {
    emit(LoginLoadingState());
    isLoading = true;

    //FB
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      //getUserData(value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));

      isLoading = false;
    }).catchError((error) {
      emit(LoginErrorState(error: error.toString()));
    });
  }

  MyUser? userModel;

  storeUserData(
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
      //CacheHelper.saveData(key: 'uId', value: uId);
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error: error.toString()));
    });
  }

  void getUserData(String? id) {
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      userModel = MyUser.fromJson(value.data()!);
      emit(GetUserSuccess());
    }).catchError((error) {
      emit(GetUserError(
        message: error.toString(),
      ));
    });
  }

  List<MyUser> allUsers = [];

  void getAllUsers() {
    allUsers = [];
    FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((element) {
        if (element.id != userModel!.userId) {
          allUsers.add(MyUser.fromJson(element.data()!));
        }
      });
      emit(GetAllUsersSuccess());
    }).catchError((error) {
      emit(GetAllUsersErrorState(message: error.toString()));
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

  final String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void createPost({String? postText}) {
    if (postImage == null) {
      post = MyPost(
          userId: userModel!.userId,
          postId: getRandomString(20),
          userName: userModel!.userName,
          userProfileImage: userModel!.userProfileImage,
          postText: postText,
          postComments: 0,
          postLikes: [],
          dateTime: DateFormat.yMEd().add_jms().format(DateTime.now()));
      FirebaseFirestore.instance
          .collection("posts")
          .doc(post!.postId)
          .set(post!.toMap())
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
              postComments: 0,
              postLikes: [],
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
  List<String>? commentsId = [];
  List<MyComment>? comments = [];

  void getPosts() {
    posts = [];

    emit(GetPostsLoadingState());

    FirebaseFirestore.instance.collection("posts").get().then((value) {
      value.docs.forEach((element) {
        posts!.add(MyPost.fromJson(element.data()));
        emit(GetPostsSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetPostsErrorState(message: error.toString()));
    });
  }

  bool checkIfLiked(String userId, MyPost? postModel) {
    return postModel!.postLikes!.contains(userId);
  }

  void getComments({MyPost? post}) {
    comments = [];
    commentsId = [];
    emit(GetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .doc(post!.postId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        commentsId!.add(element.id);
        print(MyComment.fromJson(element.data()));
        comments!.add(MyComment.fromJson(element.data()));
      });
      emit(GetCommentsSuccessState());
    }).catchError((error) {
      emit(GetCommentsErrorState(message: error.toString()));
    });
  }

  void likePost(MyPost? post) {
    if (!post!.postLikes!.contains(userModel!.userId)) {
      post.postLikes!.add(userModel!.userId);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.postId)
          .update(post.toMap())
          .then((value) {
        emit(LikePostSuccessState());
      }).catchError((error) {
        emit(LikePostErrorState(message: error.toString()));
      });
    } else {
      post.postLikes!.remove(userModel!.userId);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.postId)
          .update(post.toMap())
          .then((value) {
        emit(LikePostSuccessState());
      }).catchError((error) {
        emit(LikePostErrorState(message: error.toString()));
      });
    }
  }

  MyComment? commentModel;

  void addComment({MyPost? post, String? comment}) {
    post!.postComments++;
    print(post.postComments);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(post.toMap())
        .then((value) {
      commentModel = MyComment(
          userId: userModel!.userId,
          userName: userModel!.userName,
          userProfileImage: userModel!.userProfileImage,
          commentText: comment);
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.postId)
          .collection('comments')
          .doc()
          .set(commentModel!.toMap())
          .then((value) {
        emit(AddCommentSuccessState());
      }).catchError((error) {
        emit(AddCommentErrorState(message: error.toString()));
      });
    });
  }

  int currentIndex = 0;
  List<Widget> pages = [
    HomePage(),
    ChatPage(),
    AddPostPage(),
    UserPage(),
    SettingsPage()
  ];
  List<String> titles = const [
    "Feed",
    "Chats",
    "Add Post",
    "Users",
    "Settings"
  ];

  void changeNavBar(int index) {
    if (index == 1) {
      emit(GetAllUsersLoading());
      currentIndex = index;
      emit(ChangeNavBarState());
    } else if (index == 2) {
      emit(AddPostState());
    } else if (index == 3) {
      emit(GetAllUsersLoading());
      currentIndex = index;
      emit(ChangeNavBarState());
    } else {
      currentIndex = index;
      emit(ChangeNavBarState());
    }
  }

  TextEditingController messageController = TextEditingController();

  void sendMessage(String? userId) {
    Message tobeSentMessage = Message(
        messageText: messageController.text,
        sender: userModel!.userId,
        sentAt: Timestamp.now());

    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.userId)
        .collection("messages")
        .doc(userId)
        .collection("messages")
        .add(tobeSentMessage.toMap());
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("messages")
        .doc(userModel!.userId)
        .collection("messages")
        .add(tobeSentMessage.toMap());

    //edit the last message
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.userId)
        .update({"lastMessage": tobeSentMessage.toMap()});
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"lastMessage": tobeSentMessage.toMap()});
    getAllUsers();
    print(userModel!.lastMessage!.sentAt);
  }

  List<Message> messagesModelList = [];

  Stream<QuerySnapshot> messageStream(String? userId) {
    Stream<QuerySnapshot> myMessageStream = FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.userId)
        .collection("messages")
        .doc(userId)
        .collection("messages")
        .orderBy("sentAt")
        .snapshots();
    return myMessageStream;
  }
}
