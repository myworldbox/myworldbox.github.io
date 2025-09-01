import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/core_record.dart';
import 'package:flutter_template/effect/effect_neon.dart';
import '../../core/core_enum.dart';
import '../core/core_static.dart';
import '../effect/effect_galaxy.dart';
import '../effect/effect_tex.dart';
import '../effect/effect_text_shuffle.dart';
import '../item/graph/default_graph.dart';
import '../item/slideshow/default_slideshow.dart';

import '../../model/model_local.dart';
import '../../utility/utility_callback.dart';
import '../../utility/utility_reader.dart';
import '../../utility/utility_selector.dart';
import '../../utility/utility_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/core_generic.dart';
import '../effect/effect_milky.dart';
import '../item/layout/stack_layout.dart';
import '../../model/model_app.dart';
import '../item/layout/overlay_layout.dart';
import '../../model/model_ui.dart';
import '../../utility/utility_activity.dart';
import 'package:flutter_library/@core/core_enum.dart';

class CurrentParam {
  late String _textCompanyName;
  late String _textCopyright;
  late String _textAlias;
  late String _textBio;
  late String _textEducation;
  late String _textMotto;
  late String _textReserveRight;
  late String _textIntroTopic;
  late String _textIntroText;
  late String _textProfileTopic;
  late String _textProfileText;
  late bool _isIntroExpanded;
  late bool _isProfileExpanded;
  late final List<CoreRecordTex> _listTex;
  late final List<CoreRecordGraph> _listFamilyOfKing;

  CurrentParam();
}

class CurrentUtility {
  final UtilityActivity _utilityActivity;
  final UtilityWidget _utilityWidget;
  final UtilityReader _utilityReader;
  final UtilitySelector _utilitySelector;
  final UtilityCallback _utilityCallback;

  CurrentUtility()
    : _utilityActivity = UtilityActivity(),
      _utilityWidget = UtilityWidget(),
      _utilityReader = UtilityReader(),
      _utilitySelector = UtilitySelector(),
      _utilityCallback = UtilityCallback();
}

class CurrentFunc {
  List<Widget> _layout(MwbRoot app) {
    final selector = app.local.utility._utilitySelector;

    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(app);
    final size = selector.getSize(app);
    final (maxHeight, maxWidth, eachHeight) = selector.getAdjustedSize(app);

    final changeSize = utility._utilitySelector.changeSize();

    final logo = Image.asset(
      height: eachHeight,
      width: eachHeight,
      'assets/png/${CoreStatic.coreVar.project.name}_favicon_1.png',
      fit: BoxFit.contain,
    );

    List<Widget> mainItems = [
      Container(
        height: maxHeight,
        width: maxWidth,
        child: StackLayout(
          ui: ModelUi(
            dataList: [
              Container(
                height: maxHeight,
                width: maxWidth,
                child: EffectGalaxy(),
              ),
              Container(
                height: maxHeight,
                width: maxWidth,
                child: EffectTextShuffle(
                  ui: ModelUi(
                    data: CoreStatic
                        .coreVar
                        .file![(CoreEnumAsset.motto, CoreEnumFile.json)]
                        .where((item) => item[CoreEnumInput.label.name] != null)
                        .map((item) => item[CoreEnumInput.label.name])
                        .cast<
                          String
                        >() // Ensures the list is strictly List<String>
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        width: maxWidth,
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            app.setState(() {
              param._isIntroExpanded = !param._isIntroExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Padding(
                  padding: EdgeInsets.all(size.xxxs),
                  child: Text(
                    param._textIntroTopic,
                    style: TextStyle(
                      fontSize: size.xxxs,
                      color: Colors.tealAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: EdgeInsets.all(size.xxxs),
                child: Text(
                  param._textIntroText,
                  style: TextStyle(
                    fontSize: size.xxxs,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              isExpanded: param._isIntroExpanded,
              canTapOnHeader: true,
            ),
          ],
          dividerColor: Colors.greenAccent,
        ),
      ),
      Container(
        height: maxHeight,
        width: maxWidth,
        child: StackLayout(
          ui: ModelUi(
            dataList: [
              Container(
                height: maxHeight,
                width: maxWidth,
                decoration: BoxDecoration(color: Colors.black),
                child: EffectNeon(),
              ),
              Container(
                height: maxHeight,
                width: maxWidth,
                child: Center(child: EffectTex(theories: param._listTex)),
              ),
            ],
          ),
        ),
      ),
      Container(
        width: maxWidth,
        constraints: BoxConstraints(minHeight: maxHeight),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned.fill(child: EffectMilky()),
            Container(
              padding: EdgeInsets.symmetric(vertical: eachHeight),
              constraints: BoxConstraints(minHeight: maxHeight),
              child: Center(
                child: Container(
                  width: changeSize ? maxWidth * 0.8 : null,
                  padding: EdgeInsets.all(size.xxs),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(size.xs),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightGreenAccent,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: size.xs,
                    children: [
                      FractionallySizedBox(
                        widthFactor: changeSize ? 1 / 3 : 1 / 8,
                        child: AspectRatio(aspectRatio: 1, child: logo),
                      ),
                      Text(
                        param._textAlias,
                        style: TextStyle(
                          fontSize: size.xxs,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        param._textBio,
                        style: TextStyle(
                          fontSize: size.xxxs,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        param._textEducation,
                        style: TextStyle(
                          fontSize: size.xxxs,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        param._textMotto,
                        style: TextStyle(
                          fontSize: size.xxxs,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w300,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: size.xxxs,
                        children: [
                          IconButton(
                            onPressed: () => launchUrl(
                              Uri.https(
                                CoreStatic.coreConst.host.linkedin,
                                "in/${param._textCompanyName}",
                              ),
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.linkedin,
                              color: Colors.blue[700],
                              size: size.xs,
                            ),
                          ),
                          IconButton(
                            onPressed: () => launchUrl(
                              Uri.https(
                                CoreStatic.coreConst.host.facebook,
                                param._textCompanyName,
                              ),
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue[600],
                              size: size.xs,
                            ),
                          ),
                          IconButton(
                            onPressed: () => launchUrl(
                              Uri.parse(
                                "${CoreStatic.coreConst.host.mail}:54nicholasleung45@gmail.com",
                              ),
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.envelope,
                              color: Colors.red[600],
                              size: size.xs,
                            ),
                          ),
                          IconButton(
                            onPressed: () => launchUrl(
                              Uri.https(
                                CoreStatic.coreConst.host.github,
                                param._textCompanyName,
                              ),
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.github,
                              color: Colors.grey[800],
                              size: size.xs,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Container(
        width: maxWidth,
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            app.setState(() {
              param._isProfileExpanded = !param._isProfileExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: EdgeInsets.all(size.xxxs),
                  child: Text(
                    param._textProfileTopic,
                    style: TextStyle(
                      fontSize: size.xxxs,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              body: Padding(
                padding: EdgeInsets.all(size.xxxs),
                child: Text(
                  param._textProfileText,
                  style: TextStyle(
                    fontSize: size.xxxs,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true, // Ensures text wraps nicely
                  overflow: TextOverflow.visible, // Prevents clipping
                ),
              ),
              isExpanded: param._isProfileExpanded,
              canTapOnHeader: true,
            ),
          ],
          dividerColor: Colors.grey[700],
        ),
      ),
      Container(
        height: maxHeight,
        width: maxWidth,
        child: DefaultSlideshow(
          ui: ModelUi(
            data: CoreStatic.coreUnion.data([
              "resource/image/portrait/VL_0.jpeg",
              "resource/image/portrait/VL_1.jpeg",
              "resource/image/portrait/VL_2.jpeg",
            ]),
          ),
        ),
      ),
      Container(
        height: maxHeight,
        width: maxWidth,
        child: Center(
          child: DefaultGraph(
            focus: param
                ._listFamilyOfKing[Random().nextInt(
                  param._listFamilyOfKing.length,
                )]
                .from,
            relations: param._listFamilyOfKing,
          ),
        ),
      ),
      Container(
        width: maxWidth,
        padding: EdgeInsets.all(size.xxxs),
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              param._textCopyright,
              style: TextStyle(
                fontSize: size.xxxs,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              param._textReserveRight,
              style: TextStyle(
                fontSize: size.xxxs,
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ];
    return [ListView(children: mainItems)];
  }
}

class MwbRoot
    extends
        ModelApp<Pager<MwbRoot>, CurrentParam, CurrentUtility, CurrentFunc> {
  MwbRoot() : super();
  @override
  get init => () async {
    final selector = local.utility._utilitySelector;

    final size = selector.getSize(this);
    final (CurrentParam param, CurrentUtility utility, CurrentFunc func) =
        selector.getLocal(this);

    await utility._utilityActivity.init(this);
    final localeJson =
        CoreStatic.coreVar.file![(CoreEnumAsset.locale, CoreEnumFile.json)];
    final route = CoreStatic.coreVar.route.value;
    final localeRouteJson = localeJson[route];
    setState(() {
      param
        .._textCompanyName = localeJson["company_name"].toString()
        .._textCopyright = localeJson["copyright"].toString().replaceAll(
          "{project.name}",
          param._textCompanyName,
        )
        .._textReserveRight = localeJson["reserve_right"].toString()
        .._textIntroTopic = localeRouteJson["intro_topic"].toString()
        .._textIntroText = localeRouteJson["intro_text"].toString()
        .._textProfileTopic = localeRouteJson["profile_topic"].toString()
        .._textProfileText = localeRouteJson["profile_text"].toString()
        .._textAlias = localeRouteJson["alias"].toString()
        .._textBio = localeRouteJson["bio"].toString()
        .._textEducation = localeRouteJson["education"].toString()
        .._textMotto = localeRouteJson["motto"].toString()
        .._isIntroExpanded = false
        .._isProfileExpanded = false
        .._listTex = [
          (
            name: "Nash Equilibrium",
            tex:
                r"x^{*} \in \operatorname*{arg\,max}_{x_i} u_i(x_i, x_{-i}^{*}), \quad \forall i",
          ),
          (
            name: "Prisoner's Dilemma",
            tex:
                r"\begin{pmatrix} (R,R) & (S,T) \\ (T,S) & (P,P) \end{pmatrix}",
          ),
          (
            name: "Bayesian Game",
            tex:
                r"P(\theta_i \mid s_i) = \frac{P(s_i \mid \theta_i)\,P(\theta_i)}{\sum_{\theta_i'} P(s_i \mid \theta_i')\,P(\theta_i')}",
          ),
          (
            name: "Minimax Theorem",
            tex:
                r"\min_{x \in X}\, \max_{y \in Y}\, f(x,y) = \max_{y \in Y}\, \min_{x \in X}\, f(x,y)",
          ),
          (
            name: "Dominant Strategy",
            tex:
                r"s_i \succ s_i' \iff u_i(s_i, s_{-i}) \ge u_i(s_i', s_{-i}) \quad \forall s_{-i}",
          ),
          (
            name: "Pareto Efficiency",
            tex:
                r"\nexists\, x' \in X \ \text{s.t.}\ \forall i:\ u_i(x') \ge u_i(x),\ \text{with strict inequality for some } i",
          ),
          (
            name: "Shapley Value",
            tex:
                r"\phi_i(v) = \sum_{S \subseteq N \setminus \{i\}} \frac{|S|!\,(|N|-|S|-1)!}{|N|!}\,\big[v(S \cup \{i\}) - v(S)\big]",
          ),
          (
            name: "Core of a Game",
            tex:
                r"C(v) = \{ x \in \mathbb{R}^n \mid \sum_{i \in N} x_i = v(N),\ \sum_{i \in S} x_i \ge v(S)\ \forall S \subseteq N \}",
          ),
          (
            name: "Stackelberg Equilibrium",
            tex:
                r"\max_{x_1} u_1(x_1, x_2^*(x_1)) \text{ s.t. } x_2^*(x_1) = \arg\max_{x_2} u_2(x_1, x_2)",
          ),
          (
            name: "Correlated Equilibrium",
            tex:
                r"\sum_{s_{-i}} p(s)\, u_i(s_i, s_{-i}) \ge \sum_{s_{-i}} p(s)\, u_i(s_i', s_{-i}) \quad \forall s_i, s_i'",
          ),
        ]
        .._listFamilyOfKing = [
          (from: '司馬防', to: '司馬懿', type: CoreEnumStep.next),
          (from: '司馬懿', to: '王凌', type: CoreEnumStep.parallel),
          (from: '司馬懿', to: '柏夫人', type: CoreEnumStep.parallel),
          (from: '司馬懿', to: '諸葛亮', type: CoreEnumStep.parallel),
          (from: '司馬懿', to: '曹真', type: CoreEnumStep.parallel),
          (from: '秦伯南', to: '曹真', type: CoreEnumStep.next),
          (from: '曹真', to: '曹爽', type: CoreEnumStep.next),
          (from: '柏夫人', to: '司馬倫', type: CoreEnumStep.next),
          (from: '司馬懿', to: '司馬師', type: CoreEnumStep.next),
          (from: '司馬懿', to: '司馬昭', type: CoreEnumStep.next),
          (from: '司馬懿', to: '司馬亮', type: CoreEnumStep.next),
          (from: '司馬懿', to: '司馬倫', type: CoreEnumStep.next),
          (from: '司馬懿', to: '司馬馗', type: CoreEnumStep.next),
          (from: '司馬懿', to: '司馬伷', type: CoreEnumStep.next),
          (from: '司馬伷', to: '司馬覲', type: CoreEnumStep.next),
          (from: '司馬覲', to: '司馬睿', type: CoreEnumStep.next),
          (from: '司馬倫', to: '司馬荂', type: CoreEnumStep.next),
          (from: '司馬昭', to: '司馬炎', type: CoreEnumStep.next),
          (from: '司馬昭', to: '司馬攸', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬衷', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬冏', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬穎', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬瑋', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬乂', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬越', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬遲', type: CoreEnumStep.next),
          (from: '司馬炎', to: '司馬柬', type: CoreEnumStep.next),
          (from: '司馬柬', to: '司馬鄴', type: CoreEnumStep.next),
          (from: '司馬睿', to: '司馬邵', type: CoreEnumStep.next),
          (from: '司馬邵', to: '司馬衍', type: CoreEnumStep.next),
          (from: '司馬邵', to: '司馬岳', type: CoreEnumStep.next),
          (from: '司馬岳', to: '司馬聃', type: CoreEnumStep.next),
          (from: '司馬衍', to: '司馬丕', type: CoreEnumStep.next),
          (from: '司馬衍', to: '司馬奕', type: CoreEnumStep.next),
          (from: '司馬睿', to: '司馬昱', type: CoreEnumStep.next),
          (from: '司馬昱', to: '司馬道子', type: CoreEnumStep.next),
          (from: '司馬道子', to: '司馬曜', type: CoreEnumStep.next),
          (from: '司馬曜', to: '司馬德宗', type: CoreEnumStep.next),
          (from: '司馬曜', to: '司馬德文', type: CoreEnumStep.next),
        ];
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
  get discard => () async {
    await local.utility._utilityActivity.discard(this);
  };

  @override
  get ui => [StackLayout(ui: ModelUi(dataList: local.func._layout(this)))];

  @override
  var local = ModelLocal(CurrentParam.new, CurrentUtility.new, CurrentFunc.new);
}
