class TrustDevice {
  final String trustName;
  final String trustIpAddress;

  TrustDevice({required this.trustName, required this.trustIpAddress});
}

class ScanDevice{
  final String scanName;
  final String scanIpAddress;

  ScanDevice({required this.scanName, required this.scanIpAddress});
}

class DetectDevice {
  final String detectName;
  final String detectIpAddress;

  DetectDevice({required this.detectName , required this.detectIpAddress});
}

List<DetectDevice> devices = [
  DetectDevice(detectName:'Device 1',detectIpAddress: '192,168,1.1'),
  DetectDevice(detectName:'Device 2',detectIpAddress: '192,168,1.2'),
  DetectDevice(detectName:'Device 3',detectIpAddress: '192,168,1.3'),
  DetectDevice(detectName:'Device 4',detectIpAddress: '192,168,1.4'),
  DetectDevice(detectName:'Device 5',detectIpAddress: '192,168,1.5'),
  DetectDevice(detectName:'Device 6',detectIpAddress: '192,168,1.6'),
  DetectDevice(detectName:'Device 7',detectIpAddress: '192,168,1.7'),
  DetectDevice(detectName:'Device 8',detectIpAddress: '192,168,1.8'),
  DetectDevice(detectName:'Device 9',detectIpAddress: '192,168,1.9'),
];