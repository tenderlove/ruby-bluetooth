#import "ruby_bluetooth.h"

VALUE rbt_cBluetoothDevice = Qnil;

void Init_bluetooth() {
    VALUE mBluetooth = rb_define_module("Bluetooth");

    rb_define_singleton_method(mBluetooth, "scan", rbt_scan, 0);

    rbt_cBluetoothDevice = rb_const_get(mBluetooth, rb_intern("Device"));

    rb_define_method(rbt_cBluetoothDevice, "request_name", rbt_request_name, 0);
}

