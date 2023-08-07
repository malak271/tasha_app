import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../shared/components/components.dart';
import '../network/local/chache_helper.dart';
import 'login_screen.dart';

class BoardingModel{
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController=PageController();

  List<BoardingModel> model=[
    BoardingModel(
        title: 'تعرف على أفضل الفنادق في منطقتك \n واحجز يومك بأفضل الاسعار',
        image: 'assets/images/onBoarding1.png',
        body: 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، \n  لقد تم توليد هذا النص من مولد النص العربى \n من مولد النص العربي'
    ),
    BoardingModel(
        title: 'تعرف على أفضل الفنادق في منطقتك \n واحجز يومك بأفضل الاسعار',
        image: 'assets/images/onBoarding1.png',
        body: 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة \n ، لقد تم توليد هذا النص من مولد النص العربى \n من مولد النص العربي'
    ),
    BoardingModel(
        title: 'تعرف على أفضل الفنادق في منطقتك \n واحجز يومك بأفضل الاسعار',
        image: 'assets/images/onBoarding1.png',
        body: 'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة \n ، لقد تم توليد هذا النص من مولد النص العربى \n من مولد النص العربي'
    ),
  ];

  bool isLast=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: boardController,
              itemBuilder:(context,index)=> buildItem(model[index]),
              itemCount: model.length,
              onPageChanged: (index){
                if(index==model.length-1){
                  setState(() {
                    isLast=true;
                  });
                }else{
                  setState(() {
                    isLast=false;
                  });
                }
              },
            ),
          ),
          SizedBox(height: 20.h,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: model.length,
                  effect:ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      dotHeight: 6.h,
                      expansionFactor: 4,
                      spacing: 5,
                      dotWidth: 8.w,
                      activeDotColor: HexColor('FFC010')
                  ) ,
                ),
                Spacer(),
                FloatingActionButton(onPressed: (){
                  if(isLast){
                    CacheHelper.saveData( key:'OnBoarding', value: true)
                        .then((value){
                      if(value){
                        navigateAndFinish(context,LoginScreen());
                      }
                    });
                  }else{
                    boardController.nextPage(
                        duration: Duration(
                            milliseconds: 750
                        ),
                        curve: Curves.fastLinearToSlowEaseIn);
                  }
                },child: Icon(Icons.arrow_forward_sharp),),
              ],
            ),
          ),
          SizedBox(height: 20.h,),
        ],
      ) ,
    );
  }

  Widget buildItem(BoardingModel model)=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(child: Image(image: AssetImage('${model.image}'),)),
      Padding(
       padding: const EdgeInsets.all(20.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Text('${model.title}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
           SizedBox(height: 20.h,),
           Text('${model.body}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: HexColor('A2A2A2')),),
         ],
       ),
     )
    ],
  );
}
