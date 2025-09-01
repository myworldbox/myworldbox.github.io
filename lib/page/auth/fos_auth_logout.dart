import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../item/layout/overlay_layout.dart';
import '../../utility/utility_widget.dart';
import '../../core/core_generic.dart';
import '../../item/button/audible_button.dart';
import '../../item/table/default_table.dart';
import '../../item/text/markdown_text.dart';
import '../../model/model_app.dart';

import '../../model/model_local.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_selector.dart';
import '../sample/sample_sign_in.dart';
import '../sample/simple_register.dart';
import '../../utility/utility_activity.dart';
import '../../utility/utility_selector.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  late final Widget _sectionLogin;

  CurrentParam()
    : _emailController = TextEditingController(),
      _passwordController = TextEditingController();
}

class CurrentUtility {
  final UtilityWidget _utilityWidget;
  final UtilityActivity _utilityActivity;
  final UtilitySelector _utilitySelector;

  CurrentUtility()
    : _utilityWidget = UtilityWidget(),
      _utilityActivity = UtilityActivity(),
      _utilitySelector = UtilitySelector();
}

class CurrentFunc {
  void _logout() {}

  ModelUi _pageUi(FosAuthLogout app) {
    final selector = app.local.utility._utilitySelector;

    final size = selector.getSize(app);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);

    return ModelUi(
      dataList: [
        utility._utilityWidget.widgetBackground(app),
        ...List.generate(100, (index) => Text(index.toString())),
      ],
    );
  }

  Widget _sectionLogin(FosAuthLogout app) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: app.local.param._emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your email'
                : null,
          ),
          TextFormField(
            controller: app.local.param._passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your password'
                : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: app.local.func._logout,
            child: const Text('Sign In'),
          ),
        ],
      ),
    ),
  );
}

class FosAuthLogout
    extends
        ModelApp<
          Pager<FosAuthLogout>,
          CurrentParam,
          CurrentUtility,
          CurrentFunc
        > {
  @override
  get init => () async {
    await local.utility._utilityActivity.init(this);
    setState(() {
      local.param._sectionLogin = local.func._sectionLogin(this);
    });
  };

  @override
  get refresh => () async {
    await local.utility._utilityActivity.refresh(this);
  };

  @override
  get renew => () async {
    await local.utility._utilityActivity.renew(this);
  };

  @override
  get discard => () async {};

  @override
  get ui => [
    OverlayLayout(ui: local.func._pageUi(this)),
    const MarkdownTextWidget(
      markdown: '''
# Header 1
This is a **bold** and *italic* text.
## Header 2
Normal paragraph here.
          ''',
      richText: true,
    ),
    const SampleSignIn(),
    local.param._sectionLogin,
  ];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
