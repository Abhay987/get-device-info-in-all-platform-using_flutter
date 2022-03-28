
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceDetailDemo extends StatefulWidget {


  @override
  _DeviceDetailDemoState createState() => _DeviceDetailDemoState();
}

class _DeviceDetailDemoState extends State<DeviceDetailDemo> {
  String? deviceName;
  //String? deviceVersion;
  String? identifier;
  final DeviceInfoPlugin deviceInfoPlugin =DeviceInfoPlugin();
  AndroidDeviceInfo? buildAnd;
  Future<void> _deviceDetails() async{

    try {
      if (Platform.isAndroid) {
         buildAnd = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = buildAnd?.model;
         // deviceVersion =build.version.toString();
          identifier = buildAnd?.androidId;
        });
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = data.name;
          //deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor;
        });//UUID for iOS
      }else if(kIsWeb){
        WebBrowserInfo webInfo=await deviceInfoPlugin.webBrowserInfo;
        deviceName=webInfo.browserName.toString();
        identifier=webInfo.vendor.toString()+webInfo.userAgent.toString()+webInfo.hardwareConcurrency.toString();
      }
      else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
        deviceName=linuxInfo.name;
        identifier = linuxInfo.machineId;
      }
    } on PlatformException {
      debugPrint('Failed to get platform version');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Device Details"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
              _deviceDetails();
              },
              child: const Text("Get Details",
                style: TextStyle(color: Colors.black),),
            ),
                Column(
                  children: [
                    const SizedBox(height: 30,),
                    Text("Device Name:- $deviceName",style: const TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold)),
                     /*   const SizedBox(height: 30,),
                          Text("Device Version:- $deviceVersion",style:const TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold)),*/
                    const SizedBox(height: 30,),
                    Text("Device Identifier:- $identifier",style: const TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold)),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

