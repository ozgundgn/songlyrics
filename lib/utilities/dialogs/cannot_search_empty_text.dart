import 'dart:ffi';

import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<void> showCannotSearchTextDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      content: "Lütfen boş yapmayın",
      title: "Uyarı",
      optionsBuilder: () => {
            'OK': null,
          });
}
