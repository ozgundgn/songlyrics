import 'package:flutter/material.dart';
import 'package:songlyrics/extensions/buildcontext/loc.dart';

import 'generic_dialog.dart';

Future<void> showCannotSearchTextDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      content: context.loc.please_give_some_words,
      title: context.loc.warning,
      optionsBuilder: () => {
            'OK': null,
          });
}
