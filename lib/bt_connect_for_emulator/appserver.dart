class AppServer {
  final String id;
  final Uri detectIpAddress;

  AppServer({required this.id,required String detectIpAddress}): detectIpAddress = Uri.parse(detectIpAddress);
}

List<AppServer> savedPhoto = [
  AppServer(id: '1',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png'),
  AppServer(id: '2',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png'),
  AppServer(id: '3',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/a73a8b28b53d8d01cf76.png'),
  AppServer(id: '4',detectIpAddress: 'https://storage.googleapis.com/cms-storage-bucket/683514c5660dbe52f5ba.png'),
];