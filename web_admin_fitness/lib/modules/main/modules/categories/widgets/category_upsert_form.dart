import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../../../global/gen/i18n.dart';
import '../../../../../global/widgets/label.dart';

class CategoryUpsertForm extends StatefulWidget {
  const CategoryUpsertForm({
    super.key,
    // required this.initial,
  });

  // final GCategory initial;

  @override
  State<CategoryUpsertForm> createState() => _CategoryUpsertFormState();
}

class _CategoryUpsertFormState extends State<CategoryUpsertForm> {
  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final isLargerThanMobile =
        ResponsiveWrapper.of(context).isLargerThan(MOBILE);

    return ListView(
      children: [
        const SizedBox(height: 16),
        const Label('Category Name'),
        FormBuilderTextField(
          name: 'name',
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.required(
            errorText: 'Name is required',
          ),
        ),
        const Label('Category Image'),
        FormBuilderField(
          builder: (field) {
            return InputDecorator(
              decoration: const InputDecoration(),
              child: InkWell(
                onTap: () async {
                  XFile? pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    print(pickedFile.path);
                  }
                },
              ),
            );
          },
          name: 'imgUrl',
        ),
      ],
    );
  }
}
