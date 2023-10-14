import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:poducts/utils/audio_handler.dart';
import 'package:poducts/view_models/podcats_view_model.dart';
import 'package:poducts/views/main_view.dart';
import 'package:provider/provider.dart';

void main() async{
   final  _audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'douma.kamal.poducts.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
   MyApp.audioHandler = _audioHandler;
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static  MyAudioHandler? audioHandler;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.purple,
            textTheme: const TextTheme(
                bodyText2: TextStyle(color:Colors.white)
            ),
            scaffoldBackgroundColor: const Color(0XFF120C28)
        ),
        home: ChangeNotifierProvider<PodcastViewModel>(
          create: (context) => PodcastViewModel(),
          child: Consumer<PodcastViewModel>(
            builder: (context, model, child) {
              return MainView(context,model);
            },
          ),
        )
    );
  }
}



