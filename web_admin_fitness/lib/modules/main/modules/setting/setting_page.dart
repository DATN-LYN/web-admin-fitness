import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

import '../../../../global/enums/app_locale.dart';
import '../../../../global/gen/i18n.dart';
import '../../../../global/graphql/auth/__generated__/mutation_logout.req.gql.dart';
import '../../../../global/providers/app_settings_provider.dart';
import '../../../../global/providers/auth_provider.dart';
import '../../../../global/routers/app_router.dart';
import '../../../../global/utils/constants.dart';
import '../../../../global/widgets/avatar.dart';
import '../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../global/widgets/dialogs/radio_selector_dialog.dart';
import '../../../../global/widgets/shadow_wrapper.dart';
import 'widgets/change_password_dialog.dart';
import 'widgets/setting_tile.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with ClientMixin {
  void changeLanguage(AppSettingsProvider provider, I18n i18n) async {
    final data = await showDialog(
      context: context,
      builder: (_) => RadioSelectorDialog(
        currentValue: provider.appSettings.locale.getLabel(i18n),
        itemLabelBuilder: (item) => item,
        title: i18n.setting_Language,
        values: i18n.language,
      ),
    );
    if (data != provider.appSettings.locale.getLabel(i18n)) {
      if (mounted) {
        if (data == i18n.language[1]) {
          provider.changeLocale(AppLocale.viVN);
        } else {
          provider.changeLocale(AppLocale.enUs);
        }
      }
    }
  }

  Future<void> changePasswordHandler() async {
    final data = await showDialog(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );

    if (data != null) {}
  }

  void logOut() {
    final i18n = I18n.of(context)!;
    final user = hiveService.getUserCredentials();

    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        titleText: i18n.setting_ConfirmLogout,
        contentText: i18n.setting_ConfirmLogoutDes,
        positiveButtonText: i18n.button_Ok,
        onTapPositiveButton: () async {
          final loginReq = GLogoutReq((b) => b.vars.userId = user.id);

          final response = await client.request(loginReq).first;

          if (response.data?.logout.success == true) {
            if (mounted) {
              context.read<AuthProvider>().logout();
              Navigator.pop(context);
              AutoRouter.of(context).push(const LoginRoute());
            }
          }
        },
      ),
    );
  }

  void openPrivacyPolicyUrl() async {
    if (await canLaunchUrlString(Constants.privacyPolicyUrl)) {
      await launchUrlString(Constants.privacyPolicyUrl);
    }
  }

  void openTermsAndConditionsUrl() async {
    if (await canLaunchUrlString(Constants.termsAndConditionsUrl)) {
      await launchUrlString(Constants.termsAndConditionsUrl);
    }
  }

  void shareIntroUrl() {
    Share.share(
      Constants.introductionUrl,
      subject: I18n.of(context)!.setting_ShareWithFriends,
    );
  }

  void goToEditProfile() {
    context
        .pushRoute(const EditProfileRoute())
        .then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final user = hiveService.getUserCredentials().user;
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (isDesktopView) const SizedBox(height: 20),
        Center(
          child: ShimmerImage(
            width: 100,
            height: 100,
            borderRadius: BorderRadius.circular(100),
            errorWidget: Avatar(
              name: user?.fullName,
              size: 100,
            ),
            imageUrl: user?.avatar ?? '_',
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            user?.fullName ?? '_',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            user?.email ?? '_',
          ),
        ),
        const SizedBox(height: 20),
        ShadowWrapper(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.setting_Account,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SettingTile(
                icon: Icons.account_circle_outlined,
                title: 'Edit Profile',
                onTap: goToEditProfile,
              ),
              const Divider(height: 12),
              SettingTile(
                icon: Icons.password,
                title: i18n.setting_ChangePassword,
                onTap: changePasswordHandler,
              ),
              const Divider(height: 12),
              SettingTile(
                icon: Icons.logout,
                title: i18n.setting_Logout,
                onTap: logOut,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadowWrapper(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.setting_AboutApp,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Consumer<AppSettingsProvider>(
                  builder: (context, provider, child) {
                return SettingTile(
                  icon: Icons.language,
                  title: i18n.setting_Language,
                  onTap: () => changeLanguage(provider, i18n),
                );
              }),
              const Divider(height: 12),
              SettingTile(
                icon: Icons.share,
                title: i18n.setting_ShareWithFriends,
                onTap: shareIntroUrl,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadowWrapper(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.setting_Security,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              SettingTile(
                icon: Icons.privacy_tip_outlined,
                title: i18n.setting_PrivacyPolicy,
                onTap: openPrivacyPolicyUrl,
              ),
              const Divider(height: 12),
              SettingTile(
                icon: Icons.note_outlined,
                title: i18n.setting_TermsAndConditions,
                onTap: openTermsAndConditionsUrl,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
