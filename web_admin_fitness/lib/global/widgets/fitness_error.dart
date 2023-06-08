import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';
import '../gen/i18n.dart';

class FitnessError extends StatelessWidget {
  const FitnessError({
    Key? key,
    this.response,
  }) : super(key: key);

  final OperationResponse? response;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return LayoutBuilder(builder: (context, box) {
      return SingleChildScrollView(
        primary: false,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: box.maxHeight,
          width: box.maxWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.sadFace.image(width: 207, height: 140),
              const SizedBox(height: 24),
              const Text(
                'sad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                response == null
                    ? 'error'
                    : response?.graphqlErrors?.isNotEmpty ?? false
                        ? response?.graphqlErrors?.first.message ?? ''
                        : response?.linkException.toString() ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
