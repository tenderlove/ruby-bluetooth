// Include the Ruby headers and goodies #import <ruby.h>
#import <ruby.h>

#import <IOBluetooth/objc/IOBluetoothDeviceInquiry.h>
#import <IOBluetooth/IOBluetoothUserLib.h>

#import "ruby_bluetooth.h"

VALUE rbt_cBluetoothDevice = Qnil;

static VALUE rbt_scan(VALUE self) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BluetoothDeviceScanner *bds = [BluetoothDeviceScanner new];

    [bds startSearch];

    CFRunLoopRun();

    [pool release];

    return [bds devices];
}

@implementation BluetoothDeviceScanner

- (void) deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender
                        error:(IOReturn)error aborted:(BOOL)aborted {
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void) deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender
                          device:(IOBluetoothDevice*)device {
    VALUE name;
    const char * device_name = [[device name] UTF8String];

    if (device_name) {
        name = rb_str_new2(device_name);
    } else {
        name = rb_str_new2("(unknown)");
    }

    VALUE dev = rb_funcall(rbt_cBluetoothDevice, rb_intern("new"), 2,
            name,
            rb_str_new2([[device getAddressString] UTF8String]));

    rb_ary_push(_devices, dev);
}

- (void) deviceInquiryDeviceNameUpdated:(IOBluetoothDeviceInquiry*)sender
                                 device:(IOBluetoothDevice*)device
                       devicesRemaining:(uint32_t)devicesRemaining {
    // do something
}

- (void) deviceInquiryUpdatingDeviceNamesStarted:(IOBluetoothDeviceInquiry*)sender
                                devicesRemaining:(uint32_t)devicesRemaining {
    // do something
}

- (IOReturn) startSearch {
    IOReturn status;

    [self stopSearch];

    _inquiry = [IOBluetoothDeviceInquiry inquiryWithDelegate:self];
    _devices = rb_ary_new();

    [_inquiry setUpdateNewDeviceNames: TRUE];

    status = [_inquiry start];

    if (status == kIOReturnSuccess) {
        [_inquiry retain];

        _busy = TRUE;
    }

    return status;
}

- (void) stopSearch {
    if (_inquiry) {
        [_inquiry stop];

        [_inquiry release];
        _inquiry = nil;
    }
}

- (VALUE) devices {
    return _devices;
}
@end

void Init_ruby_bluetooth() {
    VALUE mBluetooth = rb_define_module("Bluetooth");

    VALUE cDevices = rb_define_class_under(mBluetooth, "Devices", rb_cObject);

    rb_undef_alloc_func(cDevices);
    rb_define_singleton_method(cDevices, "scan", rbt_scan, 0);

    rbt_cBluetoothDevice = rb_const_get(mBluetooth, rb_intern("Device"));
}

