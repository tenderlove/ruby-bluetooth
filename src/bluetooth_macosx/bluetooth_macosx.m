// Include the Ruby headers and goodies #import <ruby.h>
#import <ruby.h>

#import <IOBluetooth/objc/IOBluetoothDeviceInquiry.h>
#import <IOBluetooth/IOBluetoothUserLib.h>

#import "bluetooth_macosx.h"

struct bluetooth_device_struct {
	VALUE addr;
	VALUE name;
};

VALUE bt_module;
VALUE bt_device_class;
VALUE bt_devices_class;
BOOL BUSY = false;

static VALUE bt_device_new(VALUE self, VALUE name, VALUE addr) {
    struct bluetooth_device_struct *bds;

    VALUE obj = Data_Make_Struct(self,
            struct bluetooth_device_struct, NULL,
            free, bds);

    rb_iv_set(obj, "@name", name);
    rb_iv_set(obj, "@addr", addr);

    return obj;
}

// Scan local network for visible remote devices
static VALUE bt_devices_scan(VALUE self) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BluetoothDeviceScanner *bds = [BluetoothDeviceScanner new];

    [bds startSearch];

    CFRunLoopRun();

    [pool release];

    return [bds foundDevices];
}

@implementation BluetoothDeviceScanner

- (void) deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender {
    rb_p(rb_str_new2("complete"));

    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void) deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender
                        error:(IOReturn)error aborted:(BOOL)aborted {
    rb_p(rb_str_new2("complete"));

    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void) deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender {
    rb_p(rb_str_new2("device found"));
}

- (void) deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender
                          device:(IOBluetoothDevice*)device {

    const BluetoothDeviceAddress* addressPtr = [device getAddress];

    NSString* deviceAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
             addressPtr->data[0],
             addressPtr->data[1],
             addressPtr->data[2],
             addressPtr->data[3],
             addressPtr->data[4],
             addressPtr->data[5]];
//
//    VALUE bt_dev = bt_device_new(bt_device_class,
//            rb_str_new2("unknown"),
//            rb_str_new2([deviceAddressString UTF8String]));
//
//
//    rb_ary_push(_foundDevices, bt_dev);
    rb_p(rb_str_new2([deviceAddressString UTF8String]));
}

- (void) deviceInquiryDeviceNameUpdated:(IOBluetoothDeviceInquiry*)sender {
    rb_p(rb_str_new2("name updated"));
}

- (void) deviceInquiryDeviceNameUpdated:(IOBluetoothDeviceInquiry*)sender
                                 device:(IOBluetoothDevice*)device
                       devicesRemaining:(uint32_t)devicesRemaining {
    rb_p(rb_str_new2("name updated"));
}

- (void) deviceInquiryStarted:(IOBluetoothDeviceInquiry*)sender {
    rb_p(rb_str_new2("started"));
}

- (void) deviceInquiryUpdatingDeviceNamesStarted:(IOBluetoothDeviceInquiry*)sender {
    rb_p(rb_str_new2("updating names started"));
}

- (void) deviceInquiryUpdatingDeviceNamesStarted:(IOBluetoothDeviceInquiry*)sender
                                devicesRemaining:(uint32_t)devicesRemaining {
    rb_p(rb_str_new2("updating names started"));
}

- (IOReturn) startSearch {
    IOReturn status;

    [self stopSearch];

    _foundDevices = rb_ary_new();

    _inquiry = [IOBluetoothDeviceInquiry inquiryWithDelegate:self];

    [_inquiry setInquiryLength: 5];
    [_inquiry setUpdateNewDeviceNames: FALSE];

    status = [_inquiry start];

    if (status == kIOReturnSuccess) {
        [_inquiry retain];

        _busy = TRUE;
    }

    rb_p(rb_str_new2("starting"));

    return status;
}

- (void) stopSearch {
    if (_inquiry) {
        [_inquiry stop];
        [_inquiry release];
        _inquiry = nil;

        rb_p(rb_str_new2("stopped"));
    }
}

- (BOOL) isBusy {
    return _busy;
}

- (VALUE) foundDevices {
    return _foundDevices;
}
@end

void Init_ruby_bluetooth() {
    bt_module = rb_define_module("Bluetooth");

    // Bluetooth::Devices
    bt_devices_class = rb_define_class_under(bt_module, "Devices", rb_cObject);

    rb_undef_method(bt_devices_class, "initialize");
    rb_define_singleton_method(bt_devices_class, "scan", bt_devices_scan, 0);

    // Bluetooth::Device
    bt_device_class = rb_define_class_under(bt_module, "Device", rb_cObject);

    rb_define_singleton_method(bt_device_class, "new", bt_device_new, 2);

    rb_define_attr(bt_device_class, "addr", Qtrue, Qfalse);
    rb_define_attr(bt_device_class, "name", Qtrue, Qfalse);
}

