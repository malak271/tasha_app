import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tasha_app/screens/story_screen.dart';
import 'package:tasha_app/screens/search_screen.dart';
import 'package:tasha_app/services/home_cubit/home_cubit.dart';
import 'package:tasha_app/services/home_cubit/states.dart';
import 'package:tasha_app/services/shared_cubit/shared_cubit.dart';
import 'package:tasha_app/services/shared_cubit/shared_states.dart';
import 'package:tasha_app/shared/components/components.dart';

import '../services/home_cubit/states.dart';
import '../shared/components/Constants.dart';
import '../shared/components/Constants.dart';

class HomeScreen extends StatelessWidget {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/images/appbar.png'),
          fit: BoxFit.cover,
        ),
        toolbarHeight: 140,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('أهلا و سهلا',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18)),
                    Text('في تطبيق طشة',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => StoryCubit()..getStories(),
          ),
          BlocProvider(
            create: (BuildContext context) =>
                AdvertisingCubit()..getAdvertising(),
          ),
          BlocProvider(
            create: (BuildContext context) =>
                HomeSectionCubit()..getSectionImages(),
          ),
        ],
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: () {
            // StoryCubit.getCubit(context).getStories();
            // AdvertisingCubit.getCubit(context).getAdvertising();
            // HomeSectionCubit.getCubit(context).getSectionImages();
            _refreshController.refreshCompleted();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                BlocBuilder<StoryCubit, StoryStates>(
                  builder: (BuildContext context, state) {
                    print('builder 1');
                    if (state is GetStoriesErrorState) return Container();
                    return Container(
                      height: 90,
                      padding: EdgeInsets.only(right: 10),
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              buildStory(context, state, index),
                          separatorBuilder: (context, index) => SizedBox(
                                width: 10,
                              ),
                          itemCount: StoryCubit.getCubit(context)
                                  .storyModel
                                  ?.data
                                  ?.length ??
                              4),
                    );
                  },
                ),
                BlocBuilder<AdvertisingCubit, AdvertisingStates>(
                  builder: (BuildContext context, state) {
                    print('builder 2');
                    if (state is GetAdvertisingErrorState) return Container();
                    return BlocProvider(
                      create: (BuildContext context) => SharedCubit(),
                      child: BlocBuilder<SharedCubit, SharedStates>(
                        builder: (context, state) => Stack(
                          children: [
                            BlocBuilder<SharedCubit, SharedStates>(
                              builder: (context, state) =>
                                  CarouselSlider.builder(
                                      itemCount:
                                          AdvertisingCubit.getCubit(context)
                                                  .advertisingModel
                                                  ?.data
                                                  ?.length ??
                                              0,
                                      itemBuilder: (context, index, realIndex) {
                                        final urlImage =
                                            AdvertisingCubit.getCubit(context)
                                                .advertisingModel
                                                ?.data?[index]
                                                .fileName;
                                        return buildImage(
                                            urlImage, index, context, state);
                                      },
                                      options: CarouselOptions(
                                          height: 154,
                                          autoPlay: true,
                                          viewportFraction: .9,
                                          onPageChanged: (index, reason) {
                                            SharedCubit.getCubit(context)
                                                .changeActiveIndex(index);
                                          })),
                            ),
                            Positioned.fill(
                              child: Align(
                                child: buildIndicator(context),
                                alignment: Alignment.bottomCenter,
                              ),
                              bottom: 5,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<HomeSectionCubit, HomeSectionStates>(
                  builder: (context, state) {
                    print('builder 3');
                    if (state is GetSectionImagesErrorState) return Container();
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey[100],
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Align(
                              child: Text('إذهب إلى'),
                              alignment: AlignmentDirectional.topStart),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  buildSectionItem(context, state, index),
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 10,
                                  ),
                              itemCount: 3),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<StoryCubit, StoryStates>(builder: (context, state) {
                  if (state is GetStoriesErrorState)
                    return BlocBuilder<AdvertisingCubit, AdvertisingStates>(
                        builder: (context, state) {
                      if (state is GetAdvertisingErrorState)
                        return BlocBuilder<HomeSectionCubit, HomeSectionStates>(
                            builder: (context, state) {
                          if (state is GetSectionImagesErrorState)
                            return DefaultButton(
                                function: () {
                                  StoryCubit.getCubit(context).getStories();
                                  AdvertisingCubit.getCubit(context)
                                      .getAdvertising();
                                  HomeSectionCubit.getCubit(context)
                                      .getSectionImages();
                                },
                                text: 'reload');
                          return Container();
                        });
                      return Container();
                    });
                  return Container();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStory(context, state, index) {
    if (state is GetStoriesLoadingState)
      return Container(
        height: 90,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.white,
          child: CircleAvatar(
            radius: 30,
          ),
        ),
      );
    return InkWell(
      onTap: () async {
        navigateTo(
            context,
            StoryScreen(
              storyId: index,
            ));
      },
      child: Container(
        height: 90,
        child: Column(
          children: [
            DottedBorder(
              color: HexColor('FFC010'),
              strokeWidth: 2,
              dashPattern: [5, 5],
              borderType: BorderType.Circle,
              child: getCachedImage(
                  imageUrl:
                      'http://tasha.accessline.ps/${StoryCubit.getCubit(context).storyModel!.data![index].details![0].fileName}',
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 30,
                        backgroundImage: imageProvider,
                      )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(context) {
    return AnimatedSmoothIndicator(
      count:
          AdvertisingCubit.getCubit(context).advertisingModel?.data?.length ??
              0,
      activeIndex: SharedCubit.getCubit(context).activeIndex,
      effect: ExpandingDotsEffect(
          activeDotColor: Colors.white, dotHeight: 9, dotWidth: 9),
    );
  }

  Widget buildImage(String? urlImage, int index, context, state) {
    if (state is GetAdvertisingLoadingState)
      return Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.white,
          child: Container(
            height: 154,
            color: Colors.grey,
          ));
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: getCachedImage(
        imageUrl: "http://tasha.accessline.ps$urlImage",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSectionItem(context, state, index) {
    if (state is GetSectionImagesLoadingState)
      return Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.white,
          child: Container(
            height: 100,
            color: Colors.grey,
          ));
    return InkWell(
      child: Container(
        height: 100,
        padding: EdgeInsets.all(15),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.darken),
            image: CachedNetworkImageProvider(
              'http://tasha.accessline.ps${HomeSectionCubit.getCubit(context).images[index + 1]}',
            ),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.centerRight,
        child: Text(
          sectionsTitles[index + 1] ?? '',
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: () {
        navigateTo(
            context,
            SearchScreen(
              sectionTypeID: index + 1,
            ));
      },
    );
  }
}
