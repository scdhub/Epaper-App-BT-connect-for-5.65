class PreTrustDevice {
  final String trustName;
  final String trustIpAddress;

  PreTrustDevice({required this.trustName, required this.trustIpAddress});
}

class PreScanDevice {
  final String scanName;
  final String scanIpAddress;

  PreScanDevice({required this.scanName, required this.scanIpAddress});
}

class PreDetectDevice {
  final String detectName;
  final String detectIpAddress;

  PreDetectDevice({required this.detectName, required this.detectIpAddress});
}

List<PreDetectDevice> devices = [
  PreDetectDevice(detectName: 'Device 1', detectIpAddress: '192,168,1.1'),
  PreDetectDevice(detectName: 'Device 2', detectIpAddress: '192,168,1.2'),
  PreDetectDevice(detectName: 'Device 3', detectIpAddress: '192,168,1.3'),
  PreDetectDevice(detectName: 'Device 4', detectIpAddress: '192,168,1.4'),
  PreDetectDevice(detectName: 'Device 5', detectIpAddress: '192,168,1.5'),
  PreDetectDevice(detectName: 'Device 6', detectIpAddress: '192,168,1.6'),
  PreDetectDevice(detectName: 'Device 7', detectIpAddress: '192,168,1.7'),
  PreDetectDevice(detectName: 'Device 8', detectIpAddress: '192,168,1.8'),
  PreDetectDevice(detectName: 'Device 9', detectIpAddress: '192,168,1.9'),
];
