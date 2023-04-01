import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../global/gen/assets.gen.dart';
import '../../global/gen/i18n.dart';
import '../../global/themes/app_colors.dart';
import '../../global/widgets/elevated_button_opacity.dart';
import '../../global/widgets/label.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormBuilderState>();
  bool passwordObscure = true;
  bool isLoading = false;

  void login() {}

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return Scaffold(
      appBar: kIsWeb ? null : AppBar(elevation: 0),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FormBuilder(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Assets.images.logo.image(width: 100),
                      const SizedBox(height: 16),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FormBuilderTextField(
                        name: 'email',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: i18n.login_EmailIsRequired,
                            ),
                            FormBuilderValidators.email(
                              errorText: i18n.login_EmailNotValid,
                            ),
                          ],
                        ),
                        decoration: InputDecoration(
                          hintText: i18n.login_EmailHint,
                          filled: true,
                          fillColor:
                              isLoading ? AppColors.grey6 : AppColors.white,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                      ),
                      Label(i18n.login_Password),
                      FormBuilderTextField(
                        name: 'password',
                        enabled: !isLoading,
                        obscureText: passwordObscure,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText: i18n.login_PasswordIsRequired,
                            ),
                            FormBuilderValidators.minLength(
                              6,
                              errorText:
                                  i18n.login_PasswordMustBeAtLeastSixCharacters,
                            )
                          ],
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                              isLoading ? AppColors.grey6 : AppColors.white,
                          hintText: i18n.login_PasswordHint,
                          suffixIconConstraints: const BoxConstraints(),
                          suffixIcon: SizedBox.square(
                            dimension: 40,
                            child: IconButton(
                              onPressed: () => setState(() {
                                passwordObscure = !passwordObscure;
                              }),
                              icon: Icon(
                                passwordObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.grey2,
                              ),
                            ),
                          ),
                        ),
                        onSubmitted: (_) => login(),
                        autocorrect: false,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            //TODO: forgot pass route
                          },
                          child: Text(i18n.login_ForgotPassword),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButtonOpacity(
                        onTap: isLoading ? null : login,
                        loading: isLoading,
                        label: i18n.login_LogIn,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).size.width > 850)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Assets.images.login.image(
                    height: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
