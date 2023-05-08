import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_brace_in_string_interps

//WARNING: This file is automatically generated. DO NOT EDIT, all your changes would be lost.

typedef LocaleChangeCallback = void Function(Locale locale);

class I18n implements WidgetsLocalizations {
  const I18n();
  static Locale? _locale;
  static bool _shouldReload = false;
  static Locale? get locale => _locale;
  static set locale(Locale? newLocale) {
    _shouldReload = true;
    I18n._locale = newLocale;
  }

  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  /// function to be invoked when changing the language
  static LocaleChangeCallback? onLocaleChanged;

  static I18n? of(BuildContext context) =>
    Localizations.of<I18n>(context, WidgetsLocalizations);
  @override
  TextDirection get textDirection => TextDirection.ltr;
	/// "Email"
	String get login_Email => "Email";
	/// "Password"
	String get login_Password => "Password";
	/// "Enter your email"
	String get login_EmailHint => "Enter your email";
	/// "Enter your password"
	String get login_PasswordHint => "Enter your password";
	/// "Forgot password?"
	String get login_ForgotPassword => "Forgot password?";
	/// "Or log in with"
	String get login_OrLogInWith => "Or log in with";
	/// "Don't have an account? "
	String get login_DoNotHaveAnAccount => "Don't have an account? ";
	/// "Register now"
	String get login_RegisterNow => "Register now";
	/// "Log In"
	String get login_LogIn => "Log In";
	/// "Email is invalid"
	String get login_EmailNotValid => "Email is invalid";
	/// "Email is required"
	String get login_EmailIsRequired => "Email is required";
	/// "Password must be at least 6 characters"
	String get login_PasswordMustBeAtLeastSixCharacters => "Password must be at least 6 characters";
	/// "Password is required"
	String get login_PasswordIsRequired => "Password is required";
	/// "Admin Login"
	String get login_AdminLogin => "Admin Login";
	/// "Next"
	String get button_Next => "Next";
	/// "Done"
	String get button_Done => "Done";
	/// "Cancel"
	String get button_Cancel => "Cancel";
	/// "OK"
	String get button_Ok => "OK";
	/// "Apply"
	String get button_Apply => "Apply";
	/// "Confirm"
	String get button_Confirm => "Confirm";
	/// "Reset"
	String get button_Reset => "Reset";
	/// "Save"
	String get button_Save => "Save";
	/// "Delete"
	String get button_Delete => "Delete";
	/// "Edit"
	String get button_Edit => "Edit";
	/// "Setting"
	String get setting_Title => "Setting";
	/// "Language"
	String get setting_Language => "Language";
	/// "Share with friends"
	String get setting_ShareWithFriends => "Share with friends";
	/// "Privacy policy"
	String get setting_PrivacyPolicy => "Privacy policy";
	/// "Terms and conditions"
	String get setting_TermsAndConditions => "Terms and conditions";
	/// "Change password"
	String get setting_ChangePassword => "Change password";
	/// "Log out"
	String get setting_Logout => "Log out";
	/// "Account"
	String get setting_Account => "Account";
	/// "Security"
	String get setting_Security => "Security";
	/// "About app"
	String get setting_AboutApp => "About app";
	/// "Please enter your old password, then enter the new password to proceed with the password change"
	String get setting_ChangePasswordDes => "Please enter your old password, then enter the new password to proceed with the password change";
	/// "Old password"
	String get setting_OldPassword => "Old password";
	/// "Enter your old password"
	String get setting_OldPasswordHint => "Enter your old password";
	/// "Old password is required"
	String get setting_OldPasswordRequired => "Old password is required";
	/// "New password"
	String get setting_NewPassword => "New password";
	/// "Enter your new password"
	String get setting_NewPasswordHint => "Enter your new password";
	/// "New password is required"
	String get setting_NewPasswordRequired => "New password is required";
	/// "Confirm new password"
	String get setting_ConfirmNewPassword => "Confirm new password";
	/// "Enter your confirm new password"
	String get setting_ConfirmNewPasswordHint => "Enter your confirm new password";
	/// "Confirm new password is required"
	String get setting_ConfirmNewPasswordRequired => "Confirm new password is required";
	/// "Password not match"
	String get setting_PasswordNotMatch => "Password not match";
	/// "Confirm logout"
	String get setting_ConfirmLogout => "Confirm logout";
	/// "You need confirm to logout from this app"
	String get setting_ConfirmLogoutDes => "You need confirm to logout from this app";
	/// ["English (US)", "Tiếng Việt"]
	List<String> get language => ["English (US)", "Tiếng Việt"];
	/// "Category List"
	String get categories_CategoryList => "Category List";
	/// "calo"
	String get programs_Calo => "calo";
	/// "Program List"
	String get programs_ProgramList => "Program List";
	/// "Body Part"
	String get programs_BodyPart => "Body Part";
	/// "Description"
	String get programs_Description => "Description";
	/// "Enter program name"
	String get programs_SearchHint => "Enter program name";
	/// "Actions"
	String get common_Actions => "Actions";
	/// "Not Found"
	String get common_NotFound => "Not Found";
	/// "View Detail"
	String get common_ViewDetail => "View Detail";
	/// "Update Data"
	String get common_UpdateData => "Update Data";
	/// "Duration"
	String get common_Duration => "Duration";
	/// "Level"
	String get common_Level => "Level";
	/// "Image URL"
	String get common_ImageUrl => "Image URL";
	/// "ID"
	String get common_Id => "ID";
	/// "Name"
	String get common_Name => "Name";
	/// "Calo"
	String get common_Calo => "Calo";
	/// "${appName} would like to use your camera for your scan document."
	String common_CameraPermissionRequest(String appName) => "${appName} would like to use your camera for your scan document.";
	/// "${appName} requires access to the photo library for you to be able to upload photos for your print document."
	String common_PhotoPermissionRequest(String appName) => "${appName} requires access to the photo library for you to be able to upload photos for your print document.";
	/// "${appName} requires access to the storage for you to be able to save your print document."
	String common_StoragePermissionRequest(String appName) => "${appName} requires access to the storage for you to be able to save your print document.";
	/// "Home"
	String get main_Home => "Home";
	/// "Categories"
	String get main_Categories => "Categories";
	/// "Programs"
	String get main_Programs => "Programs";
	/// "Setting"
	String get main_Setting => "Setting";
	/// "Exercises"
	String get main_Exercises => "Exercises";
	/// "Inboxes"
	String get main_Inboxes => "Inboxes";
	/// "Users"
	String get main_Users => "Users";
	/// ["Beginner", "Intermediate", "Advanced"]
	List<String> get workoutLevel => ["Beginner", "Intermediate", "Advanced"];
	/// ["Upper", "Downer", "Abs", "Full Body"]
	List<String> get workoutBodyPart => ["Upper", "Downer", "Abs", "Full Body"];
	/// "Filter"
	String get filter_Filter => "Filter";
	/// "Workout Level"
	String get filter_WorkoutLevel => "Workout Level";
	/// "Exercise List"
	String get exercises_ExerciseList => "Exercise List";
	/// "Enter exercise name"
	String get exercises_SearchHint => "Enter exercise name";
	/// "Program"
	String get exercises_Program => "Program";
	/// "Program ID"
	String get exercises_ProgramId => "Program ID";
	/// "Video URL"
	String get exercises_VideoUrl => "Video URL";
	/// "Inbox List"
	String get inboxes_InboxList => "Inbox List";
	/// "User"
	String get inboxes_User => "User";
	/// "Message"
	String get inboxes_Message => "Message";
	/// "Is Sender"
	String get inboxes_IsSender => "Is Sender";
	/// "Enter user email"
	String get inboxes_SearchHint => "Enter user email";
	/// "User List"
	String get users_UserList => "User List";
	/// "Enter user email"
	String get users_SearchHint => "Enter user email";
	/// "Create New Category"
	String get upsertCategory_CreateNewTitle => "Create New Category";
	/// "Update Category"
	String get upsertCategory_UpdateTitle => "Update Category";
	/// "Are you sure you want to create a new category?"
	String get upsertCategory_CreateNewDes => "Are you sure you want to create a new category?";
	/// "Are you sure you want to update this category information?"
	String get upsertCategory_UpdateDes => "Are you sure you want to update this category information?";
	/// "Category Detail"
	String get upsertCategory_CategoryDetail => "Category Detail";
	/// "Category Name"
	String get upsertCategory_CategoryName => "Category Name";
	/// "Category Image"
	String get upsertCategory_CategoryImage => "Category Image";
	/// "Name is required"
	String get upsertCategory_NameIsRequired => "Name is required";
	/// "Image is required"
	String get upsertCategory_ImageIsRequired => "Image is required";
	/// "Input category name"
	String get upsertCategory_NameHint => "Input category name";
	/// "Choose category image"
	String get upsertCategory_ImageHint => "Choose category image";
	/// "Category ID"
	String get upsertCategory_CategoryID => "Category ID";
	/// "Success"
	String get toast_Title_Success => "Success";
	/// "Error"
	String get toast_Title_Error => "Error";
	/// "Warning"
	String get toast_Title_Warning => "Warning";
	/// "Something went wrong, please try again"
	String get toast_Subtitle_Error => "Something went wrong, please try again";
	/// "Your information is not valid, please try again"
	String get toast_Subtitle_InvalidInformation => "Your information is not valid, please try again";
	/// "You have created a new category successfully"
	String get toast_Subtitle_CreateCategory => "You have created a new category successfully";
	/// "You have updated a category successfully"
	String get toast_Subtitle_UpdateCategory => "You have updated a category successfully";
	/// "You have deleted a category successfully"
	String get toast_Subtitle_DeleteCategory => "You have deleted a category successfully";
	/// "You have created a new program successfully"
	String get toast_Subtitle_CreateProgram => "You have created a new program successfully";
	/// "You have updated a program successfully"
	String get toast_Subtitle_UpdateProgram => "You have updated a program successfully";
	/// "You have deleted a program successfully"
	String get toast_Subtitle_DeleteProgram => "You have deleted a program successfully";
	/// "You have created a new exercise successfully"
	String get toast_Subtitle_CreateExercise => "You have created a new exercise successfully";
	/// "You have updated a exercise successfully"
	String get toast_Subtitle_UpdateExercise => "You have updated a exercise successfully";
	/// "You have deleted a exercise successfully"
	String get toast_Subtitle_DeleteExercise => "You have deleted a exercise successfully";
	/// "Create New Program"
	String get upsertProgram_CreateNewTitle => "Create New Program";
	/// "Update Program"
	String get upsertProgram_UpdateTitle => "Update Program";
	/// "Are you sure you want to create a new program?"
	String get upsertProgram_CreateNewDes => "Are you sure you want to create a new program?";
	/// "Are you sure you want to update this program information?"
	String get upsertProgram_UpdateDes => "Are you sure you want to update this program information?";
	/// "Program detail"
	String get upsertProgram_ProgramDetail => "Program detail";
	/// "Program Name"
	String get upsertProgram_Name => "Program Name";
	/// "Program Image"
	String get upsertProgram_Image => "Program Image";
	/// "Name is required"
	String get upsertProgram_NameIsRequired => "Name is required";
	/// "Image is required"
	String get upsertProgram_ImageIsRequired => "Image is required";
	/// "Input program name"
	String get upsertProgram_NameHint => "Input program name";
	/// "Choose program image"
	String get upsertProgram_ImageHint => "Choose program image";
	/// "Program ID"
	String get upsertProgram_ID => "Program ID";
	/// "Level"
	String get upsertProgram_Level => "Level";
	/// "Body Part"
	String get upsertProgram_BodyPart => "Body Part";
	/// "Category"
	String get upsertProgram_Category => "Category";
	/// "Choose category"
	String get upsertProgram_CategoryHint => "Choose category";
	/// "Level is required"
	String get upsertProgram_LevelRequired => "Level is required";
	/// "Body part is required"
	String get upsertProgram_BodyPartRequired => "Body part is required";
	/// "Category is required"
	String get upsertProgram_CategoryRequired => "Category is required";
	/// "Description is required"
	String get upsertProgram_DescriptionRequired => "Description is required";
	/// "Description"
	String get upsertProgram_Description => "Description";
	/// "Input program description"
	String get upsertProgram_DescriptionHint => "Input program description";
	/// "Create New Exercise"
	String get upsertExercise_CreateNewTitle => "Create New Exercise";
	/// "Update Exercise"
	String get upsertExercise_UpdateTitle => "Update Exercise";
	/// "Are you sure you want to create a new exercise?"
	String get upsertExercise_CreateNewDes => "Are you sure you want to create a new exercise?";
	/// "Are you sure you want to update this exercise information?"
	String get upsertExercise_UpdateDes => "Are you sure you want to update this exercise information?";
	/// "Exercise Detail"
	String get upsertExercise_ExerciseDetail => "Exercise Detail";
	/// "Exercise Name"
	String get upsertExercise_Name => "Exercise Name";
	/// "Exercise Image"
	String get upsertExercise_Image => "Exercise Image";
	/// "Exercise Video"
	String get upsertExercise_Video => "Exercise Video";
	/// "Name is required"
	String get upsertExercise_NameIsRequired => "Name is required";
	/// "Image is required"
	String get upsertExercise_ImageIsRequired => "Image is required";
	/// "Video is required"
	String get upsertExercise_VideoIsRequired => "Video is required";
	/// "Input exercise name"
	String get upsertExercise_NameHint => "Input exercise name";
	/// "Choose exercise image"
	String get upsertExercise_ImageHint => "Choose exercise image";
	/// "Choose exercise video"
	String get upsertExercise_VideoHint => "Choose exercise video";
	/// "Exercise ID"
	String get upsertExercise_ID => "Exercise ID";
	/// "Program"
	String get upsertExercise_Program => "Program";
	/// "Choose program"
	String get upsertExercise_ProgramHint => "Choose program";
	/// "Program is required"
	String get upsertExercise_ProgramRequired => "Program is required";
	/// "Duration"
	String get upsertExercise_Duration => "Duration";
	/// "Choose a video to see its duration"
	String get upsertExercise_DurationHint => "Choose a video to see its duration";
	/// "Duration is required"
	String get upsertExercise_DurationRequired => "Duration is required";
	/// "Calo is required"
	String get upsertExercise_CaloRequired => "Calo is required";
	/// "Calo"
	String get upsertExercise_Calo => "Calo";
	/// "Input exercise calo"
	String get upsertExercise_CaloHint => "Input exercise calo";
	/// "Delete Category"
	String get deleteCategory_Title => "Delete Category";
	/// "Are you sure you want to delete this category?"
	String get deleteCategory_Des => "Are you sure you want to delete this category?";
	/// "Delete Exercise"
	String get deleteExercise_Title => "Delete Exercise";
	/// "Are you sure you want to delete this exercise?"
	String get deleteExercise_Des => "Are you sure you want to delete this exercise?";
	/// "Delete Program"
	String get deleteProgram_Title => "Delete Program";
	/// "Are you sure you want to delete this program?"
	String get deleteProgram_Des => "Are you sure you want to delete this program?";
	/// "Delete User"
	String get deleteUser_Title => "Delete User";
	/// "Are you sure you want to delete this user?"
	String get deleteUser_Des => "Are you sure you want to delete this user?";
	/// "Xác nhận thay đổi"
	String get setting_ConfirmChange => "Xác nhận thay đổi";
}
class _I18n_en_US extends I18n {
  const _I18n_en_US();
}
class _I18n_vi_VN extends I18n {
  const _I18n_vi_VN();
  @override
  TextDirection get textDirection => TextDirection.ltr;
	/// "Email"
	@override
	String get login_Email => "Email";
	/// "Mật khẩu"
	@override
	String get login_Password => "Mật khẩu";
	/// "Nhập email của bạn"
	@override
	String get login_EmailHint => "Nhập email của bạn";
	/// "Nhập mật khẩu của bạn"
	@override
	String get login_PasswordHint => "Nhập mật khẩu của bạn";
	/// "Quên mật khẩu?"
	@override
	String get login_ForgotPassword => "Quên mật khẩu?";
	/// "Hoặc đăng nhập bằng"
	@override
	String get login_OrLogInWith => "Hoặc đăng nhập bằng";
	/// "Chưa có tài khoản? "
	@override
	String get login_DoNotHaveAnAccount => "Chưa có tài khoản? ";
	/// "Đăng ký"
	@override
	String get login_RegisterNow => "Đăng ký";
	/// "Đăng Nhập"
	@override
	String get login_LogIn => "Đăng Nhập";
	/// "Email không hợp lệ"
	@override
	String get login_EmailNotValid => "Email không hợp lệ";
	/// "Email bắt buộc"
	@override
	String get login_EmailIsRequired => "Email bắt buộc";
	/// "Mật khẩu phải dài tối thiểu 6 ký tự"
	@override
	String get login_PasswordMustBeAtLeastSixCharacters => "Mật khẩu phải dài tối thiểu 6 ký tự";
	/// "Mật khẩu bắt buộc"
	@override
	String get login_PasswordIsRequired => "Mật khẩu bắt buộc";
	/// "Đăng nhập dành cho Quản trị viên"
	@override
	String get login_AdminLogin => "Đăng nhập dành cho Quản trị viên";
	/// "Tiếp tục"
	@override
	String get button_Next => "Tiếp tục";
	/// "Xong"
	@override
	String get button_Done => "Xong";
	/// "Huỷ bỏ"
	@override
	String get button_Cancel => "Huỷ bỏ";
	/// "Đồng ý"
	@override
	String get button_Ok => "Đồng ý";
	/// "Áp dụng"
	@override
	String get button_Apply => "Áp dụng";
	/// "Xác nhận"
	@override
	String get button_Confirm => "Xác nhận";
	/// "Đặt lại"
	@override
	String get button_Reset => "Đặt lại";
	/// "Lưu"
	@override
	String get button_Save => "Lưu";
	/// "Xoá"
	@override
	String get button_Delete => "Xoá";
	/// "Sửa"
	@override
	String get button_Edit => "Sửa";
	/// "Cài đặt"
	@override
	String get setting_Title => "Cài đặt";
	/// "Ngôn ngữ"
	@override
	String get setting_Language => "Ngôn ngữ";
	/// "Chia sẻ với bạn bè"
	@override
	String get setting_ShareWithFriends => "Chia sẻ với bạn bè";
	/// "Chính sách bảo mật"
	@override
	String get setting_PrivacyPolicy => "Chính sách bảo mật";
	/// "Điều khoản và điều kiện"
	@override
	String get setting_TermsAndConditions => "Điều khoản và điều kiện";
	/// "Thay đổi mật khẩu"
	@override
	String get setting_ChangePassword => "Thay đổi mật khẩu";
	/// "Đăng xuất"
	@override
	String get setting_Logout => "Đăng xuất";
	/// "Tài khoản"
	@override
	String get setting_Account => "Tài khoản";
	/// "Bảo mật"
	@override
	String get setting_Security => "Bảo mật";
	/// "Về ứng dụng"
	@override
	String get setting_AboutApp => "Về ứng dụng";
	/// "Vui lòng nhập mật khẩu cũ của bạn, sau đó nhập mật khẩu mới để tiến hành thay đổi mật khẩu"
	@override
	String get setting_ChangePasswordDes => "Vui lòng nhập mật khẩu cũ của bạn, sau đó nhập mật khẩu mới để tiến hành thay đổi mật khẩu";
	/// "Mật khẩu cũ"
	@override
	String get setting_OldPassword => "Mật khẩu cũ";
	/// "Nhập mật khẩu cũ của bạn"
	@override
	String get setting_OldPasswordHint => "Nhập mật khẩu cũ của bạn";
	/// "Mật khẩu cũ bắt buộc"
	@override
	String get setting_OldPasswordRequired => "Mật khẩu cũ bắt buộc";
	/// "Mật khẩu mới"
	@override
	String get setting_NewPassword => "Mật khẩu mới";
	/// "Nhập mật khẩu mới của bạn"
	@override
	String get setting_NewPasswordHint => "Nhập mật khẩu mới của bạn";
	/// "Mật khẩu mới bắt buộc"
	@override
	String get setting_NewPasswordRequired => "Mật khẩu mới bắt buộc";
	/// "Xác nhận mật khẩu mới"
	@override
	String get setting_ConfirmNewPassword => "Xác nhận mật khẩu mới";
	/// "Nhập xác nhận mật khẩu mới"
	@override
	String get setting_ConfirmNewPasswordHint => "Nhập xác nhận mật khẩu mới";
	/// "Xác nhận mật khẩu mới bắt buộc"
	@override
	String get setting_ConfirmNewPasswordRequired => "Xác nhận mật khẩu mới bắt buộc";
	/// "Mật khẩu không khớp"
	@override
	String get setting_PasswordNotMatch => "Mật khẩu không khớp";
	/// "Xác nhận đăng xuất"
	@override
	String get setting_ConfirmLogout => "Xác nhận đăng xuất";
	/// "Bạn cần xác nhận để đăng xuất khỏi ứng dụng"
	@override
	String get setting_ConfirmLogoutDes => "Bạn cần xác nhận để đăng xuất khỏi ứng dụng";
	/// ["English (US)", "Tiếng Việt"]
	@override
	List<String> get language => ["English (US)", "Tiếng Việt"];
	/// "Danh sách thể loại"
	@override
	String get categories_CategoryList => "Danh sách thể loại";
	/// "calo"
	@override
	String get programs_Calo => "calo";
	/// "Danh sách chương trình tập"
	@override
	String get programs_ProgramList => "Danh sách chương trình tập";
	/// "Bộ phận"
	@override
	String get programs_BodyPart => "Bộ phận";
	/// "Mô tả"
	@override
	String get programs_Description => "Mô tả";
	/// "Nhập tên chương trình"
	@override
	String get programs_SearchHint => "Nhập tên chương trình";
	/// "Hành động"
	@override
	String get common_Actions => "Hành động";
	/// "Không tìm thấy"
	@override
	String get common_NotFound => "Không tìm thấy";
	/// "Xem chi tiết"
	@override
	String get common_ViewDetail => "Xem chi tiết";
	/// "Cập nhật dữ liệu"
	@override
	String get common_UpdateData => "Cập nhật dữ liệu";
	/// "Thời gian"
	@override
	String get common_Duration => "Thời gian";
	/// "Độ khó"
	@override
	String get common_Level => "Độ khó";
	/// "Đường dẫn hình ảnh"
	@override
	String get common_ImageUrl => "Đường dẫn hình ảnh";
	/// "ID"
	@override
	String get common_Id => "ID";
	/// "Tên"
	@override
	String get common_Name => "Tên";
	/// "Calo"
	@override
	String get common_Calo => "Calo";
	/// "${appName} would like to use your camera for your scan document."
	@override
	String common_CameraPermissionRequest(String appName) => "${appName} would like to use your camera for your scan document.";
	/// "${appName} requires access to the photo library for you to be able to upload photos for your print document."
	@override
	String common_PhotoPermissionRequest(String appName) => "${appName} requires access to the photo library for you to be able to upload photos for your print document.";
	/// "${appName} requires access to the storage for you to be able to save your print document."
	@override
	String common_StoragePermissionRequest(String appName) => "${appName} requires access to the storage for you to be able to save your print document.";
	/// "Trang chủ"
	@override
	String get main_Home => "Trang chủ";
	/// "Thể loại"
	@override
	String get main_Categories => "Thể loại";
	/// "Chương trình"
	@override
	String get main_Programs => "Chương trình";
	/// "Cài đặt"
	@override
	String get main_Setting => "Cài đặt";
	/// "Bài tập"
	@override
	String get main_Exercises => "Bài tập";
	/// "Tin Nhắn"
	@override
	String get main_Inboxes => "Tin Nhắn";
	/// "Người dùng"
	@override
	String get main_Users => "Người dùng";
	/// ["Dễ", "Trung bình", "Khó"]
	@override
	List<String> get workoutLevel => ["Dễ", "Trung bình", "Khó"];
	/// ["Thân trên", "Thân dưới", "Bụng", "Toàn thân"]
	@override
	List<String> get workoutBodyPart => ["Thân trên", "Thân dưới", "Bụng", "Toàn thân"];
	/// "Bộ lọc"
	@override
	String get filter_Filter => "Bộ lọc";
	/// "Độ khó của chương trình"
	@override
	String get filter_WorkoutLevel => "Độ khó của chương trình";
	/// "Danh sách bài tập"
	@override
	String get exercises_ExerciseList => "Danh sách bài tập";
	/// "Nhập tên bài tập"
	@override
	String get exercises_SearchHint => "Nhập tên bài tập";
	/// "Chương trình"
	@override
	String get exercises_Program => "Chương trình";
	/// "Mã chương trình"
	@override
	String get exercises_ProgramId => "Mã chương trình";
	/// "Đường dẫn video"
	@override
	String get exercises_VideoUrl => "Đường dẫn video";
	/// "Danh sách tin nhắn"
	@override
	String get inboxes_InboxList => "Danh sách tin nhắn";
	/// "Người dùng"
	@override
	String get inboxes_User => "Người dùng";
	/// "Tin nhắn"
	@override
	String get inboxes_Message => "Tin nhắn";
	/// "Người gửi"
	@override
	String get inboxes_IsSender => "Người gửi";
	/// "Danh sách người dùng"
	@override
	String get users_UserList => "Danh sách người dùng";
	/// "Nhập tên người dùng"
	@override
	String get users_SearchHint => "Nhập tên người dùng";
	/// "Tạo thể loại mới"
	@override
	String get upsertCategory_CreateNewTitle => "Tạo thể loại mới";
	/// "Cập nhật thể loại"
	@override
	String get upsertCategory_UpdateTitle => "Cập nhật thể loại";
	/// "Bạn có chắc chắn muốn tạo thể loại mới?"
	@override
	String get upsertCategory_CreateNewDes => "Bạn có chắc chắn muốn tạo thể loại mới?";
	/// "Bạn có chắc chắn muốn cập nhật thông tin thể loại?"
	@override
	String get upsertCategory_UpdateDes => "Bạn có chắc chắn muốn cập nhật thông tin thể loại?";
	/// "Chi tiết thể loại"
	@override
	String get upsertCategory_CategoryDetail => "Chi tiết thể loại";
	/// "Tên thể loại"
	@override
	String get upsertCategory_CategoryName => "Tên thể loại";
	/// "Hình ảnh thể loại"
	@override
	String get upsertCategory_CategoryImage => "Hình ảnh thể loại";
	/// "Bạn chưa nhập tên"
	@override
	String get upsertCategory_NameIsRequired => "Bạn chưa nhập tên";
	/// "Bạn chưa chọn hình ảnh"
	@override
	String get upsertCategory_ImageIsRequired => "Bạn chưa chọn hình ảnh";
	/// "Nhập tên thể loại"
	@override
	String get upsertCategory_NameHint => "Nhập tên thể loại";
	/// "Chọn hình ảnh thể loại"
	@override
	String get upsertCategory_ImageHint => "Chọn hình ảnh thể loại";
	/// "Mã thể loại"
	@override
	String get upsertCategory_CategoryID => "Mã thể loại";
	/// "Thành công"
	@override
	String get toast_Title_Success => "Thành công";
	/// "Lỗi"
	@override
	String get toast_Title_Error => "Lỗi";
	/// "Cảnh báo"
	@override
	String get toast_Title_Warning => "Cảnh báo";
	/// "Đã có lỗi, hãy thử lại"
	@override
	String get toast_Subtitle_Error => "Đã có lỗi, hãy thử lại";
	/// "Thông tin của bạn chưa hợp lệ, hãy kiểm tra lại"
	@override
	String get toast_Subtitle_InvalidInformation => "Thông tin của bạn chưa hợp lệ, hãy kiểm tra lại";
	/// "Tạo thể loại mới thành công"
	@override
	String get toast_Subtitle_CreateCategory => "Tạo thể loại mới thành công";
	/// "Cập nhật thể loại thành công"
	@override
	String get toast_Subtitle_UpdateCategory => "Cập nhật thể loại thành công";
	/// "Xoá thể loại thành công"
	@override
	String get toast_Subtitle_DeleteCategory => "Xoá thể loại thành công";
	/// "Tạo chương trình mới thành công"
	@override
	String get toast_Subtitle_CreateProgram => "Tạo chương trình mới thành công";
	/// "Cập nhật chương trình thành công"
	@override
	String get toast_Subtitle_UpdateProgram => "Cập nhật chương trình thành công";
	/// "Xoá chương trình thành công"
	@override
	String get toast_Subtitle_DeleteProgram => "Xoá chương trình thành công";
	/// "Tạo bài tập mới thành công"
	@override
	String get toast_Subtitle_CreateExercise => "Tạo bài tập mới thành công";
	/// "Cập nhật bài tập thành công"
	@override
	String get toast_Subtitle_UpdateExercise => "Cập nhật bài tập thành công";
	/// "Xoá bài tập thành công"
	@override
	String get toast_Subtitle_DeleteExercise => "Xoá bài tập thành công";
	/// "Tạo chương trình mới"
	@override
	String get upsertProgram_CreateNewTitle => "Tạo chương trình mới";
	/// "Cập nhật chương trình"
	@override
	String get upsertProgram_UpdateTitle => "Cập nhật chương trình";
	/// "Bạn có chắc chắn muốn tạo chương trình mới?"
	@override
	String get upsertProgram_CreateNewDes => "Bạn có chắc chắn muốn tạo chương trình mới?";
	/// "Bạn có chắc chắn muốn cập nhật thông tin chương trình?"
	@override
	String get upsertProgram_UpdateDes => "Bạn có chắc chắn muốn cập nhật thông tin chương trình?";
	/// "Chi tiết chương trình"
	@override
	String get upsertProgram_ProgramDetail => "Chi tiết chương trình";
	/// "Tên chương trình"
	@override
	String get upsertProgram_Name => "Tên chương trình";
	/// "Hình ảnh"
	@override
	String get upsertProgram_Image => "Hình ảnh";
	/// "Bạn chưa nhập tên"
	@override
	String get upsertProgram_NameIsRequired => "Bạn chưa nhập tên";
	/// "Bạn chưa chọn hình"
	@override
	String get upsertProgram_ImageIsRequired => "Bạn chưa chọn hình";
	/// "Nhập tên chương trình"
	@override
	String get upsertProgram_NameHint => "Nhập tên chương trình";
	/// "Chọn hình ảnh của chương trình"
	@override
	String get upsertProgram_ImageHint => "Chọn hình ảnh của chương trình";
	/// "Mã chương trình"
	@override
	String get upsertProgram_ID => "Mã chương trình";
	/// "Độ khó"
	@override
	String get upsertProgram_Level => "Độ khó";
	/// "Vùng cơ thể"
	@override
	String get upsertProgram_BodyPart => "Vùng cơ thể";
	/// "Thể loại"
	@override
	String get upsertProgram_Category => "Thể loại";
	/// "Chọn thể loại"
	@override
	String get upsertProgram_CategoryHint => "Chọn thể loại";
	/// "Bạn chưa chọn độ khó"
	@override
	String get upsertProgram_LevelRequired => "Bạn chưa chọn độ khó";
	/// "Bạn chưa chọn vùng cơ thể"
	@override
	String get upsertProgram_BodyPartRequired => "Bạn chưa chọn vùng cơ thể";
	/// "Bạn chưa chọn thể loại"
	@override
	String get upsertProgram_CategoryRequired => "Bạn chưa chọn thể loại";
	/// "Bạn chưa nhập mô tả"
	@override
	String get upsertProgram_DescriptionRequired => "Bạn chưa nhập mô tả";
	/// "Mô tả"
	@override
	String get upsertProgram_Description => "Mô tả";
	/// "Nhập mô tả chương trình"
	@override
	String get upsertProgram_DescriptionHint => "Nhập mô tả chương trình";
	/// "Tạo bài tập mới"
	@override
	String get upsertExercise_CreateNewTitle => "Tạo bài tập mới";
	/// "Cập nhật bài tập"
	@override
	String get upsertExercise_UpdateTitle => "Cập nhật bài tập";
	/// "Bạn có chắc chắn muốn tạo bài tập mới?"
	@override
	String get upsertExercise_CreateNewDes => "Bạn có chắc chắn muốn tạo bài tập mới?";
	/// "Bạn có chắc chắn muốn cập nhật thông tin bài tập?"
	@override
	String get upsertExercise_UpdateDes => "Bạn có chắc chắn muốn cập nhật thông tin bài tập?";
	/// "Chi tiết bài tập"
	@override
	String get upsertExercise_ExerciseDetail => "Chi tiết bài tập";
	/// "Tên bài tập"
	@override
	String get upsertExercise_Name => "Tên bài tập";
	/// "Hình ảnh"
	@override
	String get upsertExercise_Image => "Hình ảnh";
	/// "Video bài tập"
	@override
	String get upsertExercise_Video => "Video bài tập";
	/// "Bạn chưa nhập tên"
	@override
	String get upsertExercise_NameIsRequired => "Bạn chưa nhập tên";
	/// "Bạn chưa chọn hình"
	@override
	String get upsertExercise_ImageIsRequired => "Bạn chưa chọn hình";
	/// "Bạn chưa chọn video"
	@override
	String get upsertExercise_VideoIsRequired => "Bạn chưa chọn video";
	/// "Nhập tên bài tập"
	@override
	String get upsertExercise_NameHint => "Nhập tên bài tập";
	/// "Chọn hình ảnh của bài tập"
	@override
	String get upsertExercise_ImageHint => "Chọn hình ảnh của bài tập";
	/// "Chọn video của bài tập"
	@override
	String get upsertExercise_VideoHint => "Chọn video của bài tập";
	/// "Mã bài tập"
	@override
	String get upsertExercise_ID => "Mã bài tập";
	/// "Chương trình"
	@override
	String get upsertExercise_Program => "Chương trình";
	/// "Chọn chương trình"
	@override
	String get upsertExercise_ProgramHint => "Chọn chương trình";
	/// "Bạn chưa chọn chương trình"
	@override
	String get upsertExercise_ProgramRequired => "Bạn chưa chọn chương trình";
	/// "Thời gian"
	@override
	String get upsertExercise_Duration => "Thời gian";
	/// "Chọn video để xem thời gian"
	@override
	String get upsertExercise_DurationHint => "Chọn video để xem thời gian";
	/// "Thời gian bắt buộc"
	@override
	String get upsertExercise_DurationRequired => "Thời gian bắt buộc";
	/// "Ban chưa nhập calo"
	@override
	String get upsertExercise_CaloRequired => "Ban chưa nhập calo";
	/// "Calo"
	@override
	String get upsertExercise_Calo => "Calo";
	/// "Nhập calo của bài tập"
	@override
	String get upsertExercise_CaloHint => "Nhập calo của bài tập";
	/// "Xoá thể loại"
	@override
	String get deleteCategory_Title => "Xoá thể loại";
	/// "Bạn có chắc chắn muốn xoá thể loại?"
	@override
	String get deleteCategory_Des => "Bạn có chắc chắn muốn xoá thể loại?";
	/// "Xoá bài tập"
	@override
	String get deleteExercise_Title => "Xoá bài tập";
	/// "Bạn có chắc chắn muốn xoá bài tập?"
	@override
	String get deleteExercise_Des => "Bạn có chắc chắn muốn xoá bài tập?";
	/// "Xoá chương trình"
	@override
	String get deleteProgram_Title => "Xoá chương trình";
	/// "Bạn có chắc chắn muốn xoá chương trình?"
	@override
	String get deleteProgram_Des => "Bạn có chắc chắn muốn xoá chương trình?";
	/// "Xoá người dùng"
	@override
	String get deleteUser_Title => "Xoá người dùng";
	/// "Bạn có chắc chắn muốn xoá người dùng?"
	@override
	String get deleteUser_Des => "Bạn có chắc chắn muốn xoá người dùng?";
}
class GeneratedLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", "US"),
			Locale("vi", "VN")
    ];
  }

  LocaleResolutionCallback resolution({Locale? fallback}) {
    return (Locale? locale, Iterable<Locale> supported) {
      if (locale != null && isSupported(locale)) {
        return locale;
      }
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    I18n._locale ??= locale;
    I18n._shouldReload = false;
    final String lang = I18n._locale != null ? I18n._locale.toString() : "";
    final String languageCode = I18n._locale != null ? I18n._locale!.languageCode : "";
    if ("en_US" == lang) {
			return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
		}
		else if ("vi_VN" == lang) {
			return SynchronousFuture<WidgetsLocalizations>(const _I18n_vi_VN());
		}
    else if ("en" == languageCode) {
			return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
		}
		else if ("vi" == languageCode) {
			return SynchronousFuture<WidgetsLocalizations>(const _I18n_vi_VN());
		}

    return SynchronousFuture<WidgetsLocalizations>(const I18n());
  }

  @override
  bool isSupported(Locale locale) {
    for (var i = 0; i < supportedLocales.length ; i++) {
      final l = supportedLocales[i];
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => I18n._shouldReload;
}
