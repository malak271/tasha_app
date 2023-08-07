import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tasha_app/models/my_reservations_model.dart';
import 'package:tasha_app/services/reservation_cubit/reservation_cubit.dart';
import 'package:tasha_app/services/reservation_cubit/reservation_states.dart';
import 'package:tasha_app/shared/components/components.dart';
import 'package:tasha_app/styles/theme.dart';

class ReservationsScreen extends StatelessWidget {

  // List<String> images =[];
      // 'https://img.freepik.com/free-psd/plant-lover-template-psd-care-guide_53876-137807.jpg?w=740&t=st=1661501662~exp=1661502262~hmac=78a145aa9a64b276413ad7be992dcf4daab7d7a4441687da3ef7785bed6b2785';

  @override
  Widget build(BuildContext context) {
    List<MyReservationsModel>? myReservations;
    return Scaffold(
      body: BlocProvider(
        create: (context) => MyReservationsCubit()..getMyReservations(),
        child: BlocConsumer<MyReservationsCubit, MYReservationStates>(
          builder: (context, state) {
            if(myReservations != null) {
              return ListView.builder(
              itemBuilder: (context, index){
                return buildItem(context,myReservations![index]);
              },
              itemCount: myReservations!.length,
            );
            }
            return Container();
          },
          listener: (context, state) {
            if (state is GetMyReservationSuccessState)
              myReservations = MyReservationsCubit.getCubit(context).myReservationModel;
            // if(state is GetMyReservationImageSuccessState)
            //   images=MyReservationsCubit.getCubit(context).images;
          },
        ),
      ),
    );
  }

  Widget buildItem(context,MyReservationsModel data) {
    String img='https://img.freepik.com/free-psd/plant-lover-template-psd-care-guide_53876-137807.jpg?w=740&t=st=1661501662~exp=1661502262~hmac=78a145aa9a64b276413ad7be992dcf4daab7d7a4441687da3ef7785bed6b2785';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: HexColor('F2F2F2')),
            boxShadow: [
              BoxShadow(
                color: HexColor('F2F2F2'),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image(
                      image: NetworkImage(img),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.sectionName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: MyColor.getColor()),
                      ),
                      Text(' بداية الحجز ${data.reservationDateFrom}',
                          style: TextStyle(color: HexColor('787878'))),
                      Text('نهاية الحجز ${data.reservationDateTo}',
                          style: TextStyle(color: HexColor('787878'))),
                      Text('تكلفة الحجز ${data.totalAmount}',
                          style: TextStyle(color: HexColor('787878'))),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DefaultButton(
                  function: () {},
                  text: '${data.statusName}',
                  backGroundColor: HexColor('65B95C'),
                  borderColor: HexColor('65B95C'),
                  width: 125,
                  height: 28)
            ],
          ),
        ),
      ),
    );
  }


}


enum StatusNames { WAITING, APPROVED, REJECT }

Color chooseToastColor(StatusNames state) {
  Color color;

  switch (state) {
    case StatusNames.APPROVED:
      color = HexColor('65B95C');
      break;
    case StatusNames.REJECT:
      color = Colors.red;
      break;
    case StatusNames.WAITING:
      color = HexColor('C9C9C9');
      break;
  }

  return color;
}
