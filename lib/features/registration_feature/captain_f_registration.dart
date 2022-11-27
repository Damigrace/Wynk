
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wynk/features/landing_pages/captain_online.dart';
import 'package:wynk/features/wynk-pass/wynk_sub_page.dart';
import 'package:wynk/main.dart';
import 'package:wynk/utilities/models/data_confirmation.dart';
import 'package:wynk/services.dart';
import 'package:wynk/utilities/constants/colors.dart';
import 'package:wynk/utilities/constants/textstyles.dart';
import 'package:wynk/utilities/models/lists.dart';
import 'package:wynk/utilities/widgets.dart';
import '../../controllers.dart';
import '../landing_pages/captain_home.dart';
Map? userData;

class CaptainFRegistration extends StatefulWidget {
  Map<String, dynamic> ass;
  Map<String, dynamic> carType;
  Map<String, dynamic> carModel;
   CaptainFRegistration({Key? key,required this.ass,required this.carModel, required this.carType}) : super(key: key);

  @override
  State<CaptainFRegistration> createState() => _CaptainFRegistrationState();
}

class _CaptainFRegistrationState extends State<CaptainFRegistration> {
  int? chosenCarType;
  bool showSpinner=false;
  bool isHaveCar = false;
  String? selectedCarBrand;
  String? selectedCarModel;
  String? selectedCarYear;
  String? selectedColor;
  String? selectedCAssociation;
  String? Capacity;
  String? driverLicense;
  String? frontImage;
  String? backImage;
  String? carInspection;
  String? vehicleLicense;
  String? vehicleRegistration;
  int? selectedV;
  int? capTypeSelectedRadio;
  int? carTypeSelectedRadio;
  int? capacitySelectedRadio;
  int? carModelSelectedRadio;
  bool isVisible = true;
  late Map<String, dynamic> associations;
  late Map<String, dynamic> carTypes;
   Map<String, dynamic>? carModels;
     void getCModel(Map<String, dynamic> map){
    carModels =  map;
    carModelList = carModels!['message'] as List;
    carModelLength = carModelList!.length;

  }
  void getRegDetails() {
    associations = widget.ass;
    carTypes = widget.carType;
    assTypeList = associations['message'] as List;
    carTypeList = carTypes['message'] as List;
    assTypeLength = assTypeList.length;
    carTypeLength = carTypeList.length;
  }
 late List assTypeList;
  late List carTypeList;
   List? carModelList;
  late int assTypeLength;
  late int carTypeLength;
   int? carModelLength;
   @override

  void initState() {
    // TODO: implement initState
    super.initState();
   getRegDetails();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    assTypeCont.clear();
    carModelCont.clear();
    carTypeCont.clear();
    driverLicenseCont.clear();
    carColorController.clear();
    carYearController.clear();
    capacityCont.clear();
    licensePlateController.clear();
    ownerFullNameCont.clear();
    frontImageController.clear();
    backImageController.clear();
    inspectionController.clear();
    vehicleLicenseController.clear();
    vehicleRegistrationController.clear();
  }
  File? imageFile;
  String? path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding:   EdgeInsets.only(top:15.h,left:36.w ,right: 36.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(this.context),
                SizedBox(height: 33.h),
                Text('Add Your Vehicle...',style: kTextStyle1),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 62.h),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  AddTypeInputBox(
                                    function: ()async{
                                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                                      if(result != null){
                                        File file = File(result.files.single.path!);
                                        final bytes = await File(file.path).readAsBytes();
                                        driverLicense = base64Encode(bytes);
                                        driverLicenseCont.text = file.path;
                                      }
                                    },
                                    hintText: 'Driver License Number',
                                    controller: driverLicenseCont,
                                    textInputType: TextInputType.emailAddress)])
                        ),
                        GestureDetector(
                          onTap: ()async{
                            //final associations = await getAssociation();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setPopState) {
                                        return AlertDialog(
                                          title: Text('Select Association Type'),
                                          content:
                                          Container(
                                            width: 10.w,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: assTypeLength,
                                                itemBuilder: (context,index){
                                                  return ListTile(
                                                    title: Text(
                                                        associations['message']
                                                        [index]['name']),
                                                    trailing: Radio<int?>(
                                                      activeColor: kYellow,
                                                      value: index,
                                                      groupValue: capTypeSelectedRadio,
                                                      onChanged: (value){
                                                        setPopState((){
                                                          capTypeSelectedRadio = value;
                                                        });
                                                        setState(() {
                                                          assTypeCont.text = associations['message'][value]['name'];

                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  );
                                                }),
                                          )
                                        );
                                      },
                                    );
                                  });

                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.h),
                              height: 61.h,
                              width: double.infinity,
                              decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: kGrey1),
                                  color: kWhite),
                              child:Row(children: [
                                SizedBox(width: 18.w,),
                                Expanded(
                                  child: TextField(
                                      readOnly: true,
                                      onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                      autofocus: true,
                                      style: kTextStyle5,
                                      decoration:   InputDecoration.collapsed(
                                          hintText: 'Select Association Type',
                                          hintStyle: const TextStyle(fontSize: 15,
                                              color: kBlack1
                                          )),
                                      controller: assTypeCont),
                                ),
                                Icon(
                                    Icons.keyboard_arrow_down_sharp
                                )
                              ],
                              )
                          ),
                        ),//association type

                        SizedBox(height: 33.h),
                        Text('Car Details',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)
                              ),
                                activeColor: kYellow,
                                value: isHaveCar, onChanged:(value){
                              setState(() {
                                isHaveCar = value!;
                              });
                            }),
                          ),
                            SizedBox(width: 10.w),
                            Text('I don’t have a car',style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400),),

                          ],),
                        SizedBox(height: 10.h),
                        Row(children: [
                          Flexible(
                            flex:5,
                            child: GestureDetector(
                              onTap: ()async{
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            void Function(void Function())
                                            setPopState) {
                                          return AlertDialog(
                                            title: Text('Car Brand'),
                                            content: Container(
                                              width: 100.w,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: carTypeLength,
                                                  itemBuilder: (context,index){
                                                    return ListTile(
                                                      title: Text(
                                                          carTypes['message']
                                                          [index]['name']),
                                                      trailing: Radio<int?>(
                                                        activeColor: kYellow,
                                                        value: index,
                                                        groupValue: carTypeSelectedRadio,
                                                        onChanged: (value)async{
                                                          chosenCarType = value;
                                                          setPopState((){
                                                            carTypeSelectedRadio = value;
                                                          });
                                                          setState(() {
                                                            carTypeCont.text = carTypes['message'][value]['name'];
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          );
                                        },
                                      );
                                    });

                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  height: 61.h,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: kGrey1),
                                      color: kWhite),
                                  child:Row(children: [
                                    SizedBox(width: 18.w,),
                                    Expanded(
                                      child: TextField(
                                          readOnly: true,
                                          autofocus: true,
                                          style: kTextStyle5,
                                          decoration:   InputDecoration.collapsed(
                                              hintText: 'Car Brand',
                                              hintStyle: const TextStyle(fontSize: 15,
                                                  color: kBlack1
                                              )),
                                          controller: carTypeCont),
                                    ),
                                    Icon(
                                        Icons.keyboard_arrow_down_sharp
                                    )
                                  ],
                                  )
                              ),
                            ), //car type
                          ),
                          SizedBox(width:7.w),
                          Flexible(
                            flex: 5,
                            child: Material(
                              borderRadius: BorderRadius.circular(7),
                              elevation: 4,
                              child: Container(
                                  height: 61.h,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: kGrey1),
                                      color: kWhite),
                                  child:Row(children: [
                                    SizedBox(width: 18.w,),
                                    Expanded(
                                      child: TextField(
                                        onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                        autofocus: true,
                                        keyboardType:TextInputType.text,
                                        style: kTextStyle5,
                                        decoration:   InputDecoration.collapsed(
                                            hintText: 'Car Color',
                                            hintStyle: const TextStyle(fontSize: 15,
                                                color: kBlack1
                                            )),
                                        controller: carColorController,),
                                    )
                                  ],
                                  )
                              ),
                            ),
                          ),],),
                        Row(children: [
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              onTap: ()async{
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            void Function(void Function())
                                            setPopState) {
                                          return FutureBuilder(
                                              future: getCarModel(chosenCarType!),
                                              builder: (context,snapshot){
                                            if(snapshot.hasData){
                                              getCModel(snapshot.data as Map<String,dynamic>);
                                              return AlertDialog(
                                                  title:
                                                  Text('Car Model'),
                                                  content:  Container(
                                                    width: 100.w,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: carModelLength,
                                                        itemBuilder: (context,index){
                                                          return ListTile(
                                                            title: Text(
                                                                carModels!['message']
                                                                [index]['name']),
                                                            trailing: Radio<int?>(
                                                              activeColor: kYellow,
                                                              value: index,
                                                              groupValue: carModelSelectedRadio,
                                                              onChanged: (value){
                                                                setPopState((){
                                                                  carModelSelectedRadio = value;
                                                                });
                                                                setState(() {
                                                                  carModelCont.text = carModels!['message'][value]['name'];
                                                                });
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          );
                                                        }),
                                                  )
                                              );
                                            }
                                            else{
                                              return  Container(child:
                                                SpinKitCubeGrid(
                                                  color: kYellow,
                                                ));
                                            }
                                          });
                                        },
                                      );
                                    });

                              },
                              child: Container(
                                  height: 61.h,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: kGrey1),
                                      color: kWhite),
                                  child:Row(children: [
                                    SizedBox(width: 18.w,),
                                    Expanded(
                                      child: TextField(
                                          readOnly: true,
                                          onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                          autofocus: true,
                                          style: kTextStyle5,
                                          decoration:   InputDecoration.collapsed(
                                              hintText: 'Car Model',
                                              hintStyle: const TextStyle(fontSize: 15,
                                                  color: kBlack1
                                              )),
                                          controller: carModelCont),
                                    ),
                                    Icon(
                                        Icons.keyboard_arrow_down_sharp
                                    )
                                  ],
                                  )
                              ),
                            ),
                          ),
                          SizedBox(width:7.w),
                          Expanded(
                            flex: 4,
                            child: Material(
                              borderRadius: BorderRadius.circular(7),
                              elevation: 4,
                              child: Container(
                                  height: 61.h,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: kGrey1),
                                      color: kWhite),
                                  child:Row(children: [
                                    SizedBox(width: 18.w,),
                                    Expanded(
                                      child: TextField(
                                        onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                        autofocus: true,
                                        keyboardType:TextInputType.numberWithOptions(),
                                        style: kTextStyle5,
                                        decoration:   InputDecoration.collapsed(
                                            hintText: 'Car Year',
                                            hintStyle: const TextStyle(fontSize: 15,
                                                color: kBlack1
                                            )),
                                        controller: carYearController,),
                                    )
                                  ],
                                  )
                              ),
                            )
                          ),],),
                        Row(children: [
                          Flexible(
                            flex:4,
                            child: GestureDetector(
                              onTap: ()async{
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            void Function(void Function())
                                            setPopState) {
                                          return AlertDialog(
                                              title: Text('Capacity'),
                                              content:  Container(
                                                width: 100.w,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: 10,
                                                    itemBuilder: (context,index){
                                                      return ListTile(
                                                        title: Text('${index + 1} Sitter'),
                                                        trailing: Radio<int?>(
                                                          activeColor: kYellow,
                                                          value: index,
                                                          groupValue: capacitySelectedRadio,
                                                          onChanged: (value)async{
                                                            setPopState((){
                                                              capacitySelectedRadio = value;
                                                            });
                                                            setState(() {
                                                              String sitter = '${index + 1} Sitter';
                                                              capacityCont.text = sitter;
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                      );
                                                    }),
                                              )
                                          );
                                        },
                                      );
                                    });

                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.h),
                                  height: 61.h,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: kGrey1),
                                      color: kWhite),
                                  child:Row(children: [
                                    SizedBox(width: 18.w,),
                                    Expanded(
                                      child: TextField(
                                          readOnly: true,
                                          autofocus: true,
                                          style: kTextStyle5,
                                          decoration:   InputDecoration.collapsed(
                                              hintText: 'Capacity',
                                              hintStyle: const TextStyle(fontSize: 15,
                                                  color: kBlack1
                                              )),
                                          controller: capacityCont),
                                    ),
                                    Icon(
                                        Icons.keyboard_arrow_down_sharp
                                    )
                                  ],
                                  )
                              ),
                            ), //car type
                          ),
                          SizedBox(width:7.w),
                          Flexible(
                            flex: 6,
                            child: Material(
                              borderRadius: BorderRadius.circular(7),
                              elevation: 4,
                              child: Container(
                                  height: 61.h,
                                  width: double.infinity,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: kGrey1),
                                      color: kWhite),
                                  child:Row(children: [
                                    SizedBox(width: 18.w,),
                                    Expanded(
                                      child: TextField(
                                        onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                        autofocus: true,
                                        keyboardType:TextInputType.text,
                                        style: kTextStyle5,
                                        decoration:   InputDecoration.collapsed(
                                            hintText: 'License Plate',
                                            hintStyle: const TextStyle(fontSize: 15,
                                                color: kBlack1
                                            )),
                                        controller: licensePlateController,),
                                    )
                                  ],
                                  )
                              ),
                            ),
                          ),],),
                        Material(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 4,
                          child: Container(
                              height: 61.h,
                              width: double.infinity,
                              decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: kGrey1),
                                  color: kWhite),
                              child:Row(children: [
                                SizedBox(width: 18.w,),
                                Expanded(
                                  child: TextField(
                                    onEditingComplete:()=> FocusScope.of(context).nextFocus(),
                                    autofocus: true,
                                    keyboardType:TextInputType.text,
                                    style: kTextStyle5,
                                    decoration:   InputDecoration.collapsed(
                                        hintText: 'Owner\'s Full Name',
                                        hintStyle: const TextStyle(fontSize: 15,
                                            color: kBlack1
                                        )),
                                    controller: ownerFullNameCont,),
                                )
                              ],
                              )
                          ),
                        ),
                        SizedBox(height: 25.h,),
                        Text('Car Images',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  function: ()async{
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                    if(result != null){
                                      File file = File(result.files.single.path!);
                                      final bytes = await File(file.path).readAsBytes();
                                      frontImage = base64Encode(bytes);
                                      frontImageController.text = file.path;
                                    }
                                  },
                                  hintText: 'Front Image',
                                  controller: frontImageController,
                                  textInputType: TextInputType.name,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  function: ()async{
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                    if(result != null){
                                      File file = File(result.files.single.path!);
                                      final bytes = await File(file.path).readAsBytes();
                                      backImage = base64Encode(bytes);
                                      backImageController.text = file.path;
                                    }
                                  },
                                  hintText: 'Back Image',
                                  controller: backImageController,
                                  textInputType: TextInputType.name,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  function: ()async{
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                    if(result != null){
                                      File file = File(result.files.single.path!);
                                      final bytes = await File(file.path).readAsBytes();
                                      carInspection = base64Encode(bytes);
                                      inspectionController.text = file.path;
                                    }
                                  },
                                  hintText: 'Car Inspection',
                                  controller: inspectionController,
                                  textInputType: TextInputType.name,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  function: ()async{
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                    if(result != null){
                                      File file = File(result.files.single.path!);
                                      final bytes = await File(file.path).readAsBytes();
                                      vehicleLicense = base64Encode(bytes);
                                      vehicleLicenseController.text = file.path;
                                    }
                                  },
                                  hintText: 'Vehicle License',
                                  controller: vehicleLicenseController,
                                  textInputType: TextInputType.name,
                                ),])
                        ),
                        Padding(
                            padding:  EdgeInsets.only(top: 9.h,bottom: 32.h),
                            child: Flex(
                                direction: Axis.horizontal,
                                children: [ AddTypeInputBox(
                                  function: ()async{
                                   FilePickerResult? result = await FilePicker.platform.pickFiles();
                                   if(result != null){
                                     File file = File(result.files.single.path!);
                                     final bytes = await File(file.path).readAsBytes();
                                     vehicleRegistration = base64Encode(bytes);
                                     vehicleRegistrationController.text = file.path;
                                   }
                                  },
                                  hintText: 'Vehicle Registration',
                                  controller: vehicleRegistrationController,
                                  textInputType: TextInputType.name,
                                ),])
                        ),
                        Padding(
                          padding:  EdgeInsets.only(bottom: 25.h),
                          child: Row(children: [
                            Radio<int>(
                              activeColor: kYellow,
                              toggleable: true,
                              onChanged: (value) {
                                setState(() {
                                  if(selectedV==0){selectedV=1;}else{selectedV=0;}
                                });
                              }, groupValue: selectedV, value: 1,

                            ),
                            Text('I accept Wynk\'s',style: TextStyle(fontSize: 15.sp),),
                            TextButton(onPressed: (){}, child: Text('Terms & Conditions',
                                style: TextStyle(fontSize: 15.sp,color: kYellow)))
                          ],),
                        ),
                        SizedBox(
                          height: 51.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: kBlue),
                            onPressed: () async {
                              showDialog(barrierDismissible: false,
                                  context: context, builder: (context){
                                return Container(child: SpinKitCircle(color: kYellow,),);});
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('capRegStat', true);
                              context.read<FirstData>().checkCapRegStat(true);
                              String assTyp = assTypeCont.text==''?'normal':assTypeCont.text;
                              final response = await captainFinalReg(
                                  assTyp,
                                  carTypeCont.text,
                                  carModelCont.text,
                                  carColorController.text,
                                  carYearController.text,
                                  licensePlateController.text,
                                  capacityCont.text,
                                  ownerFullNameCont.text,
                                  driverLicense,
                                  frontImage,
                                  backImage,
                                  carInspection,
                                  vehicleLicense,
                                  vehicleRegistration,
                                  context);
                              showToast(response['message']);
                              Navigator.pop(context);
                              // if(response['statusCode'] == 200){
                              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const WynkPassHome()
                              //   ));
                              // }
                              final passNum = await passDetail();
                              context.read<PassSubDetails>().prepaidPasses.clear();
                              context.read<PassSubDetails>().postpaidPasses.clear();
                              final passes = passNum['message'] as List;
                              for(Map<String, dynamic> pass in passes){
                                WhiteWynkPass passModel = WhiteWynkPass(
                                  subType: 'post-paid',
                                  amount: pass['amount'],
                                  passName: pass['pass_name'],
                                  passId: pass['pass_id'],
                                  duration: pass['duration'],);
                                if(pass['pass_type'] == '1'){context.read<PassSubDetails>().savePrepaidPass(passModel);}
                                if(pass['pass_type'] == '2'){context.read<PassSubDetails>().savePostpaidPass(passModel);}
                                }
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const WynkPassHome()
                              ));
                            },
                            child: Text('Continue',style: TextStyle(fontSize: 18.sp,color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 81.h,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}