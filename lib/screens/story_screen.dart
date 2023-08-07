import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story/story_page_view/story_page_view.dart';
import 'package:tasha_app/models/story_model.dart';
import 'package:tasha_app/services/home_cubit/home_cubit.dart';
import 'package:tasha_app/services/home_cubit/states.dart';

import '../shared/components/components.dart';

class StoryScreen extends StatelessWidget {
  int storyId;
  StoryScreen({required this.storyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>StoryCubit()..getStories(),
      child: BlocConsumer<StoryCubit,StoryStates>(
          builder: (context,state){
           StoryModel? storyModel = StoryCubit.getCubit(context).storyModel;
           if(storyModel!=null) {
             return StoryPageView(
          itemBuilder: (context, pageIndex, storyIndex) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black),
                ),
                Positioned.fill(
                  child: getCachedImage(
                      imageUrl: 'http://tasha.accessline.ps/${storyModel.data![pageIndex].details![storyIndex].fileName}',
                      imageBuilder: (context,imageProvider)=>
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55, right: 10),
                  child: Row(
                    children: [
                      getCachedImage(
                          imageUrl: 'http://tasha.accessline.ps/${storyModel.data![pageIndex].details![0].fileName}',
                          imageBuilder: (BuildContext context, ImageProvider<Object> imageProvider)=>Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:imageProvider,
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                            ),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${storyModel.data![pageIndex].iD}',
                        style:const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          storyLength: (pageIndex) {
            return storyModel.data![pageIndex].details!.length;
          },
          pageLength: storyModel.data!.length,
          onPageLimitReached: () {
            Navigator.pop(context);
          },
        );
           }
           return Container();
      },
          listener: (context,state){}),
    );

  }
}
