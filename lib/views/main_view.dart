import "package:flutter/material.dart";
import "package:poducts/main.dart";
import "package:poducts/utils/enums.dart";
import "package:poducts/view_models/podcats_view_model.dart";
import "package:poducts/views/list_view_item.dart";
import "package:provider/provider.dart";
import 'dart:developer' as dev show log;

class MainView extends StatefulWidget {
  MainView(this.providerContext, this.podcastViewModel, {Key? key})
      : super(key: key);

  BuildContext providerContext;
  PodcastViewModel podcastViewModel;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final PodcastViewModel podcastViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PodcastViewModel>(widget.providerContext);
    if(widget.podcastViewModel.getFirstCall) {
      dev.log("here ---------------------->");
      widget.podcastViewModel.getData();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Crime Junkie Podcast"),
        ),
        body: (() {
              if (widget.podcastViewModel.getIsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              } else {
                switch (widget.podcastViewModel.getError) {
                  case AppErrors.NO_ERROR:
                    {
                      return  ListView.builder(
                              cacheExtent: double.infinity,
                              addAutomaticKeepAlives:true,
                              itemCount: widget.podcastViewModel.getDataCount(),
                              itemBuilder: (context, index) {
                                return ListViewItem(
                                  id: widget.podcastViewModel.getIdByIndex(index),
                                  title: widget.podcastViewModel.getTitleByIndex(index),
                                  description: widget.podcastViewModel.getDescriptionByIndex(index),
                                  publicationDate: widget.podcastViewModel.getPublicationDateByIndex(index),
                                  audioDuration: widget.podcastViewModel.getDurationByIndex(index),
                                  audioLink: widget.podcastViewModel.getAudioLinkByIndex(index),
                                  playedDuration: widget.podcastViewModel.getPlayedDurationByIndex(index),
                                );
                              }
                            );
                    }
                  case AppErrors.UNABLE_TO_LOAD_DATA:
                    {
                      return Center(
                        child: Column(
                          children: [
                            const Text(
                                "unable to load the data please check your internet connection!"),
                            TextButton(
                                onPressed: () {
                                  widget.podcastViewModel.getData();
                                },
                                child: const Text("click here to try again")),
                             // todo: for test remove
                          ],
                        ),
                      );
                    }
                  case AppErrors.UNABLE_TO_LOAD_DATA_LOCALLY:
                    return const Center(
                        child: Text("this a fatal error : source local database please report the error to the developer"));
                }
              }
            }())
    );
  }
}
