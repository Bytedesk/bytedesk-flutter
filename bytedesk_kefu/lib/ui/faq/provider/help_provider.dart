import 'package:bytedesk_kefu/blocs/help_bloc/bloc.dart';
import 'package:bytedesk_kefu/ui/faq/page/help_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpProvider extends StatelessWidget {
  final String? uid;
  const HelpProvider({Key? key, @required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (BuildContext context) => HelpBloc(),
      child: HelpPage(
        uid: uid,
      ),
    );
  }
}
