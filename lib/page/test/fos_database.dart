import 'package:flutter/material.dart';
import '../../core/core_enum.dart';
import '../../core/core_static.dart';
import '../../model/model_template.dart';
import '../../utility/utility_convert.dart';
import '../../utility/utility_request.dart';
import '../../item/table/default_table.dart';
import '../../model/atom.dart';

class PageDatabase extends StatefulWidget {
  PageDatabase({super.key});

  late Atom memberTable;

  @override
  State<PageDatabase> createState() => _PageDatabase();
}

class Local {}

class Func {}

class _PageDatabase extends ModelTemplate<PageDatabase> {
  Atom createMemberTable() {
    return Atom(
      thing: Thing(
        one: Content(
          any: [],
          data: Data(
            title: "Ulbf Database",
            current: 10,
            any: [5, 10, 20, 50, 100],
          ),
        ),
      ),
      style: Style(width: 800, height: 800),
    );
  }

  @override
  void initState() {
    super.initState();

    create(ui);
  }

  @override
  late Param param = Param();

  @override
  late Func func = Func();

  @override
  assign() {
    CoreStatic.coreVar.request = {
      "service": {
        "provider": "3ReX4Nt9Ee7AStVmSZHrAQ==",
        "action": "2lzrsPNMafw=",
        "node":
            "nyrRgetaHIjUU8dzOubJOdZWmE/Rgh8sDoioGmJvMHRLXeqVHB8cWHTgHSvNxE0zSmjLL7UYc8agHxzcdYdY+2tDHI2KydmeppuFC1mhCJ37NjOYfmn6psQVkKA=",
      },
    };

    widget.memberTable = createMemberTable();
  }

  @override
  render() => [
    FutureBuilder(
      future: Request.post(
        global.CoreStatic.coreConst.www.myApiBox.host,
        global.CoreStatic.coreConst.www.myApiBox.path,
        null,
        CoreStatic.coreConst.header.json,
        CoreStatic.coreVar.request,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            widget.memberTable.thing?.one?.any = Convert.convertListToMap(
              snapshot.data!,
            );

            return DefaultTable(fragment: widget.memberTable);
          default:
            return const CircularProgressIndicator();
        }
      },
    ),
  ];
}
