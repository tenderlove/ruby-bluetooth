#import <Cocoa/Cocoa.h>

#import <IOBluetooth/IOBluetoothUserLib.h>
#import <IOBluetooth/objc/IOBluetoothDevice.h>

#import <ruby.h>

VALUE rbt_scan(VALUE);

VALUE rbt_device_request_name(VALUE);

@class IOBluetoothDeviceInquiry;

@interface BluetoothDeviceScanner : NSObject {
	IOBluetoothDeviceInquiry *      _inquiry;
	BOOL                            _busy;
	VALUE                           _devices;
}

- (void) stopSearch;
- (IOReturn) startSearch;
- (VALUE) devices;
@end

