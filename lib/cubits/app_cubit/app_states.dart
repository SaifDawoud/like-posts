abstract class AppCubitStates{}
class AppInitialState extends AppCubitStates{}
class ChangeNavBarState extends AppCubitStates{}
class AddPostState extends AppCubitStates{}
class GetUserSuccessState extends AppCubitStates{}
class GetUserErrorState extends AppCubitStates{
  final String? message;
  GetUserErrorState({this.message});
}
