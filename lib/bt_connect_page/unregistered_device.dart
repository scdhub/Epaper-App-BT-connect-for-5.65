//未登録デバイス
import 'package:flutter/material.dart';

import '../devices_data.dart';
import 'trust-devices_popup.dart';

class UnregisteredDevice extends StatefulWidget {

  final List<ScanDevice> scanDevices;
  final List<TrustDevice> trustDevices;
  // final Function saveStringList;
  final Function(ScanDevice) addTrustDevice;

  const UnregisteredDevice({required this.trustDevices,required this.scanDevices, required this.addTrustDevice, /*required this.saveStringList*/});

  @override
  _UnregisteredDeviceState createState() => _UnregisteredDeviceState();
}

class _UnregisteredDeviceState extends State<UnregisteredDevice> {
  @override
  Widget build(BuildContext context) {
    return  widget.scanDevices.isNotEmpty
        ? Expanded(
      child:ListView.builder(
        itemCount: widget.scanDevices.length,
        itemBuilder: (context, index) {
          if (widget.trustDevices.any((device) =>
          device.trustName == widget.scanDevices[index].scanName &&
              device.trustIpAddress ==
                  widget.scanDevices[index].scanIpAddress)) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      TrustDevices_popup(
                          scanName: widget.scanDevices[index].scanName,
                          scanIpAddress: widget.scanDevices[index].scanIpAddress.toString(),
                          onOk: () {
                            setState(() {
                              // //OKを押したら、scanデバイスのデータを登録する。
                              widget.addTrustDevice(widget.scanDevices[index]);
                            });
                          }),
                );
              },
              child: Container(
                  height: 50,
                  // color: Colors.blue,
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black12,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  child:Column(children: [
                    Text(
                      widget.scanDevices[index].scanName.isEmpty
                          ?'デバイス名　不明'
                          :widget.scanDevices[index].scanName,
                      // devicesList[index].platformName,
                      style:
                      TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.scanDevices[index].scanIpAddress.toString(),
                      // devicesList[index].remoteId.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ])),
            );
          }
        },
      ),
    )
        : Container(
      color: Colors.black45,
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: 25,
      child:Text(
        'スキャンを開始して、未登録デバイスを表示してください',
        style: TextStyle(color: Colors.red,fontSize: 15),
      ),

    );
  }
}