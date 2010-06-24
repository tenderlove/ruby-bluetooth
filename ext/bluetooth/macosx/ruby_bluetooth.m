#import "ruby_bluetooth.h"

VALUE rbt_cBluetoothDevice = Qnil;

void Init_bluetooth() {
    VALUE mBluetooth = rb_define_module("Bluetooth");

    VALUE cDevices = rb_define_class_under(mBluetooth, "Devices", rb_cObject);

    rb_undef_alloc_func(cDevices);
    rb_define_singleton_method(cDevices, "scan", rbt_scan, 0);

    rbt_cBluetoothDevice = rb_const_get(mBluetooth, rb_intern("Device"));
}

