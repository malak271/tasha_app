// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginModelAdapter extends TypeAdapter<LoginModel> {
  @override
  final int typeId = 0;

  @override
  LoginModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginModel(
      rv: fields[0] as int?,
      msg: fields[1] as String?,
      userVM: fields[2] as UserVM?,
      token: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LoginModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.rv)
      ..writeByte(1)
      ..write(obj.msg)
      ..writeByte(2)
      ..write(obj.userVM)
      ..writeByte(3)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserVMAdapter extends TypeAdapter<UserVM> {
  @override
  final int typeId = 1;

  @override
  UserVM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserVM(
      userID: fields[0] as int?,
      userName: fields[1] as String?,
      sectionType: fields[2] as String?,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      addressDetails: fields[5] as String?,
      city: fields[6] as String?,
      cityName: fields[7] as String?,
      addressID: fields[8] as int?,
      addressName: fields[9] as String?,
      country: fields[10] as int?,
      countryName: fields[11] as String?,
      mobileNumber: fields[12] as String?,
      gender: fields[13] as int?,
      genderName: fields[14] as String?,
      birthDate: fields[15] as String?,
      password: fields[16] as String?,
      email: fields[17] as String?,
      faceBookID: fields[18] as String?,
      googleID: fields[19] as String?,
      active: fields[20] as bool?,
      createDate: fields[21] as String?,
      photo: fields[22] as String?,
      fcmToken: fields[23] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserVM obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.sectionType)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.addressDetails)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.cityName)
      ..writeByte(8)
      ..write(obj.addressID)
      ..writeByte(9)
      ..write(obj.addressName)
      ..writeByte(10)
      ..write(obj.country)
      ..writeByte(11)
      ..write(obj.countryName)
      ..writeByte(12)
      ..write(obj.mobileNumber)
      ..writeByte(13)
      ..write(obj.gender)
      ..writeByte(14)
      ..write(obj.genderName)
      ..writeByte(15)
      ..write(obj.birthDate)
      ..writeByte(16)
      ..write(obj.password)
      ..writeByte(17)
      ..write(obj.email)
      ..writeByte(18)
      ..write(obj.faceBookID)
      ..writeByte(19)
      ..write(obj.googleID)
      ..writeByte(20)
      ..write(obj.active)
      ..writeByte(21)
      ..write(obj.createDate)
      ..writeByte(22)
      ..write(obj.photo)
      ..writeByte(23)
      ..write(obj.fcmToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserVMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
