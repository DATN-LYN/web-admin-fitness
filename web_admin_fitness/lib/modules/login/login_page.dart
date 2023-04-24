import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../global/gen/assets.gen.dart';
import '../../global/gen/i18n.dart';
import '../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../global/models/hive/user.dart';
import '../../global/providers/auth_provider.dart';
import '../../global/routers/app_router.dart';
import '../../global/themes/app_colors.dart';
import '../../global/utils/dialogs.dart';
import '../../global/widgets/elevated_button_opacity.dart';
import '../../global/widgets/label.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ClientMixin {
  final formKey = GlobalKey<FormBuilderState>();
  bool passwordObscure = true;
  bool isLoading = false;

  void login() async {
    AutoRouter.of(context).replaceAll([const MainRoute()]);

    if (formKey.currentState!.saveAndValidate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      final loginReq = GLoginReq(
        (b) => b.vars.input.replace(
          GLoginInputDto.fromJson(formKey.currentState!.value)!,
        ),
      );

      setState(() => isLoading = true);
      final response = await client.request(loginReq).first;
      setState(() => isLoading = false);

      if (mounted) {
        AutoRouter.of(context).replaceAll([const MainRoute()]);
      }

      if (response.hasErrors) {
        if (mounted) {
          DialogUtils.showError(context: context, response: response);
        }
      } else {
        handleLoginSuccess(response.data!.login);
      }
    }
  }

  void handleLoginSuccess(GLoginData_login response) async {
    print(response.user);
    await context.read<AuthProvider>().login(
          token: response.accessToken!,
          //refreshToken: response.refreshToken,
          user: User.fromJson(response.user!.toJson()),
        );

    if (!mounted) return;

    // if (AutoRouter.of(context).canPop()) {
    //   AutoRouter.of(context).pop();
    // } else {
    //   AutoRouter.of(context).replaceAll([const MainRoute()]);
    // }
    AutoRouter.of(context).replaceAll([const MainRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: kIsWeb ? null : AppBar(elevation: 0),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: width > 850
                    ? const EdgeInsets.symmetric(horizontal: 100)
                    : const EdgeInsets.all(16),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Assets.images.logo.image(width: 100),
                      const SizedBox(height: 16),
                      const Text(
                        'Login with your admin account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Label(i18n.login_Email),
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
          if (width > 850)
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
