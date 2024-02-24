abstract class LoginStates{}



class AppInitialState extends LoginStates{}
class ChangeNavBarState extends LoginStates{}
class AddPostState extends LoginStates{}

class LoginInitState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{

  final String userIdFb;

  LoginSuccessState(this.userIdFb);

}
class LoginErrorState extends LoginStates{
  final String? error;
  LoginErrorState({this.error});
}

class CreateUserLoadingState extends LoginStates{}
class CreateUserSuccessState extends LoginStates{}
class CreateUserErrorState extends LoginStates{
  final String? error;
  CreateUserErrorState({this.error});
}
class GetUserSuccess extends LoginStates{}
class GetUserError extends LoginStates{
  final String? message;

  GetUserError({this.message});
}

class PickProfileImageSuccessState extends LoginStates{}
class PickProfileImageErrorState extends LoginStates{
  final String? message;

  PickProfileImageErrorState({this.message});

}
class PickCoverImageSuccessState extends LoginStates{}
class PickCoverImageErrorState extends LoginStates{
  final String? message;

  PickCoverImageErrorState({this.message});

}
class ProfileUploadLoadingState extends LoginStates{}
class ProfileUploadSuccessState extends LoginStates{}
class  ProfileUploadErrorState extends LoginStates{
  final String? message;

  ProfileUploadErrorState({this.message});

}
class ProfileGetUrlSuccessState extends LoginStates{}
class  ProfileGetUrlErrorState extends LoginStates{
  final String? message;

  ProfileGetUrlErrorState({this.message});

}
class UploadCoverImageLoadingState extends LoginStates{}
class CoverImageUploadSuccessState extends LoginStates{}
class CoverImageUploadErrorState extends LoginStates{
  final String? message;

  CoverImageUploadErrorState({this.message});
}
class CoverImageGetUrlErrorState extends LoginStates{
  final String? message;

  CoverImageGetUrlErrorState({this.message});
}
class UpdateUserDataLoadingState extends LoginStates{}
class UpdateUserDataSuccessState extends LoginStates{}
class UpdateUserDataErrorState extends LoginStates{
  final String? message;

  UpdateUserDataErrorState({this.message});
}
class PickPostImageLoadingState extends LoginStates{}
class PickPostImageSuccessState extends LoginStates{}
class PickPostImageErrorState extends LoginStates{
  final String? message;

  PickPostImageErrorState({this.message});
}
class RemovePostImageSuccessState extends LoginStates{}
class RemovePostImageErrorState extends LoginStates{
  final String? message;

  RemovePostImageErrorState({this.message});
}
class UploadPostImageSuccessState extends LoginStates{}
class UploadPostImageLoadingState extends LoginStates{}
class UploadPostImageErrorState extends LoginStates{
  final String? message;

  UploadPostImageErrorState({this.message});
}
class GetPostImageUrlSuccessState extends LoginStates{}
class GetPostImageUrlErrorState extends LoginStates{
  final String? message;

  GetPostImageUrlErrorState({this.message});
}
class CreatePostSuccessState extends LoginStates{}
class CreatePostLoadingState extends LoginStates{}
class CreatePostErrorState extends LoginStates{
  final String? message;

  CreatePostErrorState({this.message});
}
class GetPostsSuccessState extends LoginStates{}
class GetPostsLoadingState extends LoginStates{}
class GetPostsErrorState extends LoginStates{
  final String? message;

  GetPostsErrorState({this.message});
}
class LikePostSuccessState extends LoginStates{}

class LikePostErrorState extends LoginStates{
  final String? message;

  LikePostErrorState({this.message});
}
class AddCommentSuccessState extends LoginStates{}

class AddCommentErrorState extends LoginStates{
  final String? message;

  AddCommentErrorState({this.message});
}
class GetCommentsSuccessState extends LoginStates{}
class AddcommentPageStat extends LoginStates{}

class GetCommentsLoadingState extends LoginStates{}
class GetCommentsErrorState extends LoginStates{
  final String? message;

  GetCommentsErrorState({this.message});
}