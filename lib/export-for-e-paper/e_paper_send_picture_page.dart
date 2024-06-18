import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iphone_bt_epaper/export-for-e-paper/server_delete-image_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;

import 'server_get-image.dart';
import 'server_image_delete_check_popup.dart';

class SendPictureSelect extends StatefulWidget {
  @override
  _SendPictureSelectState createState() => _SendPictureSelectState();
}

//アプリサーバー　古い順
class ImageItem {
  final String id;
  final String url;
  final String lastModified;
  final Widget imageWidget;

  ImageItem({required this.id, required this.url, required this.lastModified})
      : imageWidget = Image.network(url);
}

//アプリサーバー　新しい順
class ReversedData {
  final String idR;
  final String url;
  final String lastModifiedR;
  final Widget imageWidgetR;

  ReversedData(
      {required this.idR, required this.url, required this.lastModifiedR})
      : imageWidgetR = Image.network(url);
}

//取得データ日付順並び替え　用
class DateSort {
  final String idD;
  final String url;
  final String lastModifiedD;
  final Widget imageWidgetD;

  DateSort({required this.idD, required this.url, required this.lastModifiedD})
      : imageWidgetD = Image.network(url);
}
//サーバーデータ削除　用
class DelData {
  final String idDel;
  final String url;
  final String lastModifiedDel;
  final Widget imageWidgetDel;

  DelData({required this.idDel, required this.url, required this.lastModifiedDel})
      : imageWidgetDel = Image.network(url);
}

class _SendPictureSelectState extends State<SendPictureSelect> {
  bool gridReverse = false; //表示順序切り替え

  List<ImageItem> imageItems = []; //サーバーデータ：古い順
  List<ReversedData> reverseData = []; //サーバーデータ：新しい順
  List<DateSort> dateSort = []; //日付並び替え
  List<DelData> delImageDataList = []; //サーバ画像削除
  final List<DelData> _delImageDataList = []; //サーバ画像削除
  bool isOn = false; //削除ボタン切り替え
  List<ImageItem> delImageItems = []; //削除データ：古い順
  final List<ImageItem> _delImageItems = []; //削除データ：古い順
  List<ReversedData> delReverseData = []; //削除データ選択:新しい順
  final List<ReversedData> _delReverseData = []; //削除データ選択:新しい順

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _delImageItems.addAll(delImageItems);
    _delReverseData.addAll(delReverseData);
    _delImageDataList.addAll(delImageDataList);
  }
//選択した画像の✔の表示、非表示
  void  _selectDelImageItems(dynamic media) {
      bool isSelected = _delImageItems.any((element) => element.id == media.id);
      setState(() {
        if (isSelected) {
          _delImageItems.removeWhere(
                  (element) => element.id == media.id);
          _delImageDataList.removeWhere(
              (element) => element.idDel == media.id
          );
        } else {
          _delImageItems.add(media);
List<ImageItem> addImage =[];
          for (var items in _delImageItems) {
if(media.any((mediaItem) => items.id == mediaItem.id)) {
  addImage.add(items);
  for (var item in addImage) {
    _delImageDataList.add(
        DelData(
          idDel: item.id,
          url: item.url,
          lastModifiedDel: item.lastModified,

        ));
  }
}
          }
        }
      });
      print(_delImageDataList);
  }
  void  _selectDelReversedData(dynamic reversedImage) {
    bool isSelected = _delReverseData.any((element) =>
    element.idR ==
        reversedImage.idR);
    setState(() {
      if (isSelected) {
        _delReverseData.removeWhere(
                (element) => element.idR == reversedImage.idR);
        _delImageDataList.removeWhere(
                (element) => element.idDel ==reversedImage.idR
        );
      } else {
        _delReverseData.add(reversedImage);
        List<ReversedData> addReversedImage =[];
        for (var items in _delReverseData) {
          if(reversedImage.any((mediaItem) => items.idR == mediaItem.idR)) {
            addReversedImage.add(items);
            for (var item in addReversedImage) {
              _delImageDataList.add(
                  DelData(
                    idDel: item.idR,
                    url: item.url,
                    lastModifiedDel: item.lastModifiedR,

                  ));
            }
          }
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom:PreferredSize(
            child:Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width:MediaQuery.of(context).size.width /2,
                  height: 40,
                  color:Colors.redAccent,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                  Text(isOn?'削除 ON ':'削除 OFF',style:TextStyle(color:Colors.white,fontSize: 20)),
                  SizedBox(width: 10,),
                  Switch(
                    value:isOn,
                    onChanged: (value) {
                      setState(
                            () {
                          isOn = value;
                        },
                      );
                    },
                  ),
                ],),
                ),
                    InkWell(
                      onTap:(){
                        setState(() {
                          gridReverse = !gridReverse;
                          _delImageItems.clear();//追加
                          _delReverseData.clear();//追加
                        });
                      },
                      child:Container(
                        color:Colors.blueAccent,
                        width:MediaQuery.of(context).size.width /2,
                        height: 40,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                                gridReverse ? '古い順' : '新しい順',
                                style:TextStyle(color:Colors.white,fontSize:20,)
                            ),
                            Icon(
                              Icons.swap_vertical_circle_outlined,
                              color: Colors.white,

                            ),
                          ],),
                      ),
                      ),

                    // ),
            ],),
            ),
            preferredSize: Size.fromHeight(56)),//高さ

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Image List',textAlign: TextAlign.center,),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
      isOn?//削除機能ON
    Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black,
    child: imageItems.isEmpty
           ? NonServerPictureMess()//サーバーに画像がない場合のメッセージ表示￥
           : ServerImageDelGridView(
           imageItems: gridReverse ? imageItems : reverseData,
           selectedMedias: gridReverse ? _delImageItems : _delReverseData,
           selectMedia: gridReverse ? _selectDelImageItems: _selectDelReversedData,
           scrollController: _scrollController,
           gridReverse: gridReverse,
             delImageDataList: delImageDataList,
            )
    )
     : Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: FutureBuilder(
          future: getImage(
              imageItems: imageItems,
              reverseData: reverseData,
              dateSort: dateSort
          ),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // 非同期処理が完了したら画像を表示
              if (imageItems.isEmpty) {
                return NonServerPictureMess();

              } else {
                return
                    // gridReverse ?
                    GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3マスずつ表示
                    crossAxisSpacing: 1.0, // 縦幅
                    mainAxisSpacing: 1.0, // 横幅
                  ),
                  itemCount:gridReverse ? imageItems.length : reverseData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final photoIndex = index % imageItems.length;
                    final photoIndexR = index % reverseData.length;
                    return
                      GestureDetector(
                      onTap: gridReverse
                          ? () {
                              var value = imageItems[photoIndex];
                              selectImageCheckDialog(
                                context: context,
                                imageUrl: value.url,
                                onSendOK: (){
                                  Navigator.pop(context);
                                        Navigator.pop(context);
                                }
                              );
                            }
                          : () {
                              var value = reverseData[photoIndexR];
                              selectImageCheckDialog(
                                context: context,
                                imageUrl: value.url,
                                  onSendOK: (){
                                    Navigator.pop(context);
                                          Navigator.pop(context);
                                  }
                              );
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        child: Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: gridReverse
                                ? imageItems[index].url
                                : reverseData[index].url,
                          ),
                        ),
                      ),
                    );

                  },
                );
              }
            } else {
              // 非同期処理中はローディングインジケータを表示
              return Center(child: CircularProgressIndicator()
                  // Container(color: Colors.white,width:30,height: 30,)
                  );
            }
          },
        ),


      ),

      floatingActionButton:
      isOn?
      _delImageDataList.isNotEmpty
          ? FloatingActionButton(
        onPressed: () async{
          for (var item in _delImageDataList) {
            print('ID: ${item.idDel}, URL: ${item.url}, Last Modified: ${item.lastModifiedDel}');
          }
          showDialog(
            context: context,
            builder: (context) =>
                ServerImageDelCheckPopup(selectDelImage:_delImageDataList),
          );
        },
        backgroundColor: Colors.lightGreenAccent,
        // Display check icon
        child: const Icon(Icons.add_task_outlined),
      )
      :null
          :null
    );
  }
}

// class DialogHelper{
void selectImageCheckDialog(
    {required BuildContext context, required String imageUrl,required Function onSendOK}) {
  showDialog(
    barrierDismissible: false, //dialog以外の部分をタップしても消えないようにする。
    context: context,
    builder: (context) =>
        Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AlertDialog(
            title: Text('選択画像を転送しますか？',
                style: TextStyle(
                  fontSize: 20,
                )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: imageUrl,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: Text("キャンセル"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    onSendOK();
                    Navigator.pop(context);

                  }),
            ],
          ),
        ],
      ),
      // ),
    ),
  );
}
// }

Future<void> ePaperSend({
  required BuildContext context,
}) async {
  Timer? _timer;
  _timer = Timer(Duration(seconds: 3), () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  });
  await showDialog(
    // barrierDismissible:false,//dialog以外の部分をタップしても消えないようにする。
    context: context,
    builder: (context) =>

        Center(
      child:
          AlertDialog(
        title: Text('E-paperに配信中',
            style: TextStyle(
              fontSize: 20,
            )),
        content: Container(
            width: 30,
            height: 30,
            child: Center(
              child: CircularProgressIndicator(),
            )),

      ),
    ),
  );
}



class NonServerPictureMess extends StatelessWidget{

    @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.warning_amber_outlined,color: Colors.white38,size: 300,),
                Text(
                  '　　登録画像がありません\n\nまずは画像を登録しましょう！',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ])
      ),
    );
  }
}


