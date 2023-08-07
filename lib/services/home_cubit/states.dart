//story
abstract class StoryStates {}

class StoryInitialState extends StoryStates {}

class GetStoriesLoadingState extends StoryStates {}

class GetStoriesSuccessState extends StoryStates {}

class GetStoriesErrorState extends StoryStates {
  final String error;

  GetStoriesErrorState(this.error);
}

//advertising
abstract class AdvertisingStates {}

class AdvertisingInitialState extends AdvertisingStates{}

class GetAdvertisingLoadingState extends AdvertisingStates{}

class GetAdvertisingSuccessState extends AdvertisingStates{}

class GetAdvertisingErrorState extends AdvertisingStates{
  final String error;

  GetAdvertisingErrorState(this.error);
}


//Section images
abstract class HomeSectionStates {}

class HomeSectionInitialState extends HomeSectionStates{}

class GetSectionImagesLoadingState extends HomeSectionStates {}

class GetSectionImagesSuccessState extends HomeSectionStates {}

class GetSectionImagesErrorState extends HomeSectionStates {
  final String error;

  GetSectionImagesErrorState(this.error);
}


