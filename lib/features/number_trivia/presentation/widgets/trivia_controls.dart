import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_event.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputStr = "";
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            _dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text("Search"),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: _dispatchConcrete,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: RaisedButton(
                child: Text("Get Random"),
                onPressed: _dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
      GetTriviaForConcreteNumber(inputStr),
    );
  }

  void _dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(
      GetTriviaForRandomNumber(),
    );
  }
}
