#import <Cocoa/Cocoa.h>

#import <IOBluetooth/IOBluetoothUserLib.h>
#import <IOBluetooth/objc/IOBluetoothDevice.h>

// Forwards
@class IOBluetoothDeviceInquiry;

@interface BluetoothDeviceScanner : NSObject {
	IOBluetoothDeviceInquiry *      _inquiry;
	BOOL                            _busy;
	VALUE                           _foundDevices;
}

- (void) stopSearch;
- (IOReturn) startSearch;
- (BOOL) isBusy;
- (VALUE) foundDevices;
@end
