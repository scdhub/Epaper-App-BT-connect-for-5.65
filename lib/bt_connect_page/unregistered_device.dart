//未登録デバイス
import 'package:flutter/material.dart';

import '../devices_data.dart';
import 'trust-devices_popup.dart';

class UnregisteredDevice extends StatefulWidget {
  final List<ScanDevice> scanDevices;
  final List<TrustDevice> trustDevices;
  // final Function saveStringList;
  final Function(ScanDevice) addTrustDevice;

  const UnregisteredDevice({
    super.key,
    required this.trustDevices,
    required this.scanDevices,
    required this.addTrustDevice,
    /*required this.saveStringList*/
  });

  @override
  State<UnregisteredDevice> createState() => _UnregisteredDeviceState();
}

class _UnregisteredDeviceState extends State<UnregisteredDevice> {
  @override
  Widget build(BuildContext context) {
    return widget.scanDevices.isNotEmpty
        ? Expanded(
      child: ListView.builder(
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
                  builder: (context) => TrustDevices_popup(
                          scanName: widget.scanDevices[index].scanName,
                          scanIpAddress: widget
                              .scanDevices[index].scanIpAddress
                              .toString(),
                          onOk: () {
                            setState(() {
                              // //OKを押したら、scanデバイスのデータを登録する。
                              widget
                                  .addTrustDevice(widget.scanDevices[index]);
                            });
                          }),
                );
              },

              //未登録デバイス
              child: Container(
                height: 50,
                // color: Colors.blue,
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: const [
                  // BoxShadow(
                  //   offset: Offset(0, 5),
                  //   color: Colors.grey,
                  // ),
                  // ],
                ),


                //Rowで並べて　→　空のアイコン（空にする方法を探す）
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                const Padding(
                padding: EdgeInsets.only(left: 10),
                    // child: Column(children: [
                    // 未登録デバイスのアイコン　左側表示
                    // const Padding(
                      // padding: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        Icons.device_unknown, // 未登録デバイスのアイコン
                        size: 25,
                        color: Colors.grey, // 未登録の雰囲気を出す色
                      ),
                ),
                    // ),

                    // デバイス名 & IPアドレスは中央寄りにする
                    Expanded(
                      //接続可能なデバイス名
                      child: Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.center,
                          children: [
                            Text(
                            widget.scanDevices[index].scanName.isEmpty
                                ? 'デバイス名　不明'
                                : widget.scanDevices[index].scanName,
                            // devicesList[index].platformName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Text(
                            widget.scanDevices[index].scanIpAddress.toString(),
                            // devicesList[index].remoteId.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    const SizedBox(width: 48),
                    // アイコンのサイズと同じ幅を確保してspaceBetweenで空間をそろえる
                  ],
                ),
              ),
            );
          }
        },
      ),
    )
        : Container(); // scanDevicesがない場合は表示しない
    // : Container(
    //     color: Colors.white54,
    //     alignment: Alignment.topCenter,
    //     width: MediaQuery.of(context).size.width,
    //     height: 25,
    //     child: const Text(
    //       'スキャンを開始して、未登録デバイスを表示してください。',
    //       style: TextStyle(color: Colors.red, fontSize: 13),
    //     ),
    //   );
  }
}
