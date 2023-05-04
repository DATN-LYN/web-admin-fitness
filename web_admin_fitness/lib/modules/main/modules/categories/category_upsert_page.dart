import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/right_sheet_appbar.dart';
import 'package:web_admin_fitness/modules/main/modules/categories/widgets/category_upsert_form.dart';

class CategoryUpsertPage extends StatefulWidget {
  const CategoryUpsertPage({
    super.key,
    @queryParam this.id,
  });
  final String? id;

  @override
  State<CategoryUpsertPage> createState() => _CategoryUpsertPageState();
}

class _CategoryUpsertPageState extends State<CategoryUpsertPage> {
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = false;

  void handleReset() async {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
    });
  }

  void handleCancel() {}

  void handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: RightSheetAppBar(
          title: const Text('Create new category'),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: const CategoryUpsertForm(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: handleReset,
                      child: Text(
                        widget.id == null ? 'Reset' : i18n.button_Cancel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text(
                        widget.id == null
                            ? i18n.button_Confirm
                            : i18n.button_Confirm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
