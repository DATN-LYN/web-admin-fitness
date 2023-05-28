import 'package:auto_route/auto_route.dart';
import 'package:ferry_flutter/ferry_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_current_user.req.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

import '../../../../global/enums/app_locale.dart';
import '../../../../global/gen/i18n.dart';
import '../../../../global/providers/app_settings_provider.dart';
import '../../../../global/providers/auth_provider.dart';
import '../../../../global/themes/app_colors.dart';
import '../../../../global/widgets/avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      titleSpacing: responsive.adap(0, 24),
      toolbarHeight: responsive.adap(null, 80),
      centerTitle: false,
      actions: context.watch<AuthProvider>().isAuth
          ? [
              _NotificationAction(),
              SizedBox(width: responsive.adap(12, 24)),
              _ProfileAction(),
              const SizedBox(width: 24),
            ]
          : [],
      leading: isDesktopView
          ? null
          : IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: const Icon(Icons.menu),
            ),
    );
  }
}

class _NotificationAction extends StatelessWidget with ClientMixin {
  _NotificationAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Operation(
      client: client,
      // operationRequest: GGetTotalNotificationUnReadReq(
      //   (b) => b..requestId = '@getTotalNotificationUnReadRequestId',
      // ),
      operationRequest: GGetCategoriesReq(),
      builder: (context, response, error) {
        // final totalUnRead =
        //     response?.data?.getTotalNotificationUnRead.toInt() ?? 0;
        return SizedBox.square(
          dimension: 46,
          child: IconButton(
            onPressed: () {
              AutoRouter.of(context).push(const SupportsRoute());
            },
            splashRadius: 32,
            icon: const Badge(
              isLabelVisible: true,
              backgroundColor: AppColors.error,
              child: Icon(
                Icons.headphones,
                size: 30,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileAction extends StatelessWidget with ClientMixin {
  _ProfileAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return Operation(
      operationRequest:
          GGetCurrentUserReq((b) => b..requestId = '@getCurrentUserRequestId'),
      client: client,
      builder: (context, response, error) {
        final user = response?.data?.getCurrentUser;

        return PopupMenuButton(
          position: PopupMenuPosition.under,
          child: isDesktopView
              ? Row(
                  children: [
                    ShimmerImage(
                      imageUrl: user?.avatar ?? '_',
                      width: 46,
                      height: 46,
                      errorWidget:
                          Avatar(name: user?.fullName ?? '_', size: 46),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 280),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? '_',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            user?.email ?? '_',
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                    ),
                  ],
                )
              : Center(
                  child: ShimmerImage(
                    imageUrl: user?.avatar ?? '_',
                    width: 32,
                    height: 32,
                    errorWidget: Avatar(name: user?.fullName ?? '_', size: 32),
                  ),
                ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: popupMenuItemChild(
                icon: Icons.language_outlined,
                title: i18n.setting_Language,
              ),
              onTap: () {
                final appSettings = context.read<AppSettingsProvider>();
                if (appSettings.appSettings.locale == AppLocale.enUs) {
                  appSettings.changeLocale(AppLocale.viVN);
                } else {
                  appSettings.changeLocale(AppLocale.enUs);
                }
              },
            ),
            PopupMenuItem(
              child: popupMenuItemChild(
                icon: Icons.logout_outlined,
                title: i18n.setting_Logout,
              ),
              onTap: () {
                context.read<AuthProvider>().logout();
              },
            ),
          ],
        );
      },
    );
  }

  Widget popupMenuItemChild({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
