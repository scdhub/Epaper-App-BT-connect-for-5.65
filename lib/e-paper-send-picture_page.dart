import 'package:flutter/material.dart';
import 'appserver.dart';
import 'package:transparent_image/transparent_image.dart';


class SendPictureSelect extends StatefulWidget{
  @override
  _SendPictureSelectState createState() => _SendPictureSelectState();
}

class _SendPictureSelectState extends State<SendPictureSelect>{
  bool _isLoading = true; //imageが表示される

  @override
  Widget build(BuildContext context) {
    return
      // MaterialApp(
      //   home:
        Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        title: Text('Image List',style:TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width:double.infinity,
    height: double.infinity,
    color:Colors.black,
    child:GridView.builder(

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 1.0, // Spacing between columns
          mainAxisSpacing: 1.0, // Spacing between rows
        ),
        itemCount: savedPhoto.length * 10, // Display 3 images per row
        itemBuilder: (context, index) {
          final photoIndex = index % savedPhoto.length; // Get the correct photo index
          return GestureDetector(
    onTap:(){

      var value = savedPhoto[photoIndex];
      Navigator.pop(context, value);

            // onTap:() async{
            //   final byteData = await savedPhoto[photoIndex].detectIpAddress.toString();
            //   if(byteData != null){
            //     Navigator.of(context).pop();
            //   }
            },
              child:Container(

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child:
            // Image.network(savedPhoto[photoIndex].detectIpAddress.toString()),

                    Center(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: savedPhoto[photoIndex].detectIpAddress.toString(),
                      ),
                    ),
              ),
          );
        },
      ),
        ),
        // ),
    );
  }
}

// class AppServer {
//   final String id;
//   final Uri detectIpAddress;
//
//   AppServer({required this.id,required String detectIpAddress}): detectIpAddress = Uri.parse(detectIpAddress);
// }
//
// List<AppServer> savedPhoto = [
//   AppServer(id: '1',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png'),
//   AppServer(id: '2',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png'),
//   AppServer(id: '3',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/a73a8b28b53d8d01cf76.png'),
//   AppServer(id: '4',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/683514c5660dbe52f5ba.png'),
// ];