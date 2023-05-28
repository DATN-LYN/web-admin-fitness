import 'package:adaptive_selector/adaptive_selector.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/enums/support_status.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_support_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/support_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_support.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/right_sheet_appbar.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

import '../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../global/widgets/label.dart';
import '../../../../global/widgets/toast/multi_toast.dart';
import '../../../../global/widgets/upsert_form_button.dart';

class SupportUpsertPage extends StatefulWidget {
  const SupportUpsertPage({
    super.key,
    required this.support,
    // required this.supportId,
  });
  // final String supportId;
  final GSupport support;

  @override
  State<SupportUpsertPage> createState() => _SupportUpsertPageState();
}

class _SupportUpsertPageState extends State<SupportUpsertPage>
    with ClientMixin {
  // GISupport? support;
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getSupport();
    });
    super.initState();
  }

  // void getSupport() async {
  //   var req = GGetSupportReq(
  //     (b) => b..vars.supportId = widget.supportId,
  //   );

  //   final res = await client.request(req).first;

  //   if (res.hasErrors) {
  //     if (mounted) {
  //       showErrorToast(context, res.graphqlErrors?.first.message);
  //     }
  //   } else {
  //     if (mounted) {
  //       setState(() {
  //         support = res.data?.getSupport;
  //       });
  //     }
  //   }
  // }

  GUpsertSupportInputDto get formData {
    final formValue = formKey.currentState!.value;
    return GUpsertSupportInputDto(
      (b) => b
        ..id = widget.support.id
        ..content = widget.support.content
        ..imgUrl = widget.support.imgUrl
        ..userId = widget.support.userId
        ..isRead = true
        ..status = formValue['status'],
    );
  }

  void handleSubmit() {
    if (formKey.currentState!.saveAndValidate()) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return ConfirmationDialog(
            titleText: 'Support Detail',
            contentText:
                'Are you sure you want to change status of support request?',
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);

              var request = GUpsertSupportReq(
                (b) => b
                  ..vars.input.replace(formData)
                  ..updateCacheHandlerKey = UpsertSupportCacheHandler.key
                  ..updateCacheHandlerContext = {
                    'upsertData': formData,
                  },
              );

              final response = await client.request(request).first;

              setState(() => loading = false);
              if (response.hasErrors) {
                if (mounted) {
                  showErrorToast(
                    context,
                    response.graphqlErrors?.first.message,
                  );
                  // DialogUtils.showError(context: context, response: response);
                }
              } else {
                if (mounted) {
                  showSuccessToast(context, 'Update successfully');
                  context.popRoute();
                }
              }
            },
          );
        },
      );
    }
  }

  void handleCancel() {
    context.popRoute();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        appBar: RightSheetAppBar(
          title: Text(i18n.support_SupportDetails),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Label(i18n.login_Email),
                    FormBuilderTextField(
                      name: 'email',
                      enabled: false,
                      readOnly: true,
                      initialValue: widget.support.user?.email,
                    ),
                    Label(i18n.support_Content),
                    FormBuilderTextField(
                      name: 'content',
                      enabled: false,
                      readOnly: true,
                      initialValue: widget.support.content,
                    ),
                    Label(i18n.upsertExercise_Image),
                    FormBuilderTextField(
                      name: 'imgUrl',
                      enabled: false,
                      readOnly: true,
                      initialValue: widget.support.imgUrl,
                    ),
                    const SizedBox(height: 10),
                    ShimmerImage(
                      imageUrl: widget.support.imgUrl ?? '_',
                      height: 300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Label(i18n.support_Status),
                    FormBuilderField(
                      name: 'status',
                      initialValue: widget.support.status,
                      builder: (field) {
                        final options = SupportStatus.values
                            .map(
                              (e) => AdaptiveSelectorOption(
                                  label: e.label(i18n), value: e.value),
                            )
                            .toList();
                        final initialData =
                            SupportStatus.getStatus(widget.support.status ?? 1);
                        return AdaptiveSelector(
                          options: options,
                          type: isDesktopView
                              ? SelectorType.menu
                              : SelectorType.bottomSheet,
                          initialOption: AdaptiveSelectorOption(
                            label: initialData.label(i18n),
                            value: initialData.value,
                          ),
                          allowClear: false,
                          onChanged: (selectedItem) {
                            if (selectedItem != null) {
                              field.didChange(selectedItem.value);
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            UpsertFormButton(
              onPressPositiveButton: handleSubmit,
              onPressNegativeButton: handleCancel,
              positiveButtonText: i18n.button_Save,
              negativeButtonText: i18n.button_Cancel,
            ),
          ],
        ),
      ),
    );
  }
}
