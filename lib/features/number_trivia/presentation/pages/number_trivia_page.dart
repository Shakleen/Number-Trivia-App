import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:number_trivia/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number trivia'),
      ),
      body: _PageBody(),
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              // Top half
              SizedBox(height: 20),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start searching!');
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.numberTrivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                },
              ),
              SizedBox(height: 20),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

