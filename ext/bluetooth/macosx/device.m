#import "ruby_bluetooth.h"

static IOBluetoothDevice *rbt_device_get(VALUE self) {
    BluetoothDeviceAddress address;
    IOBluetoothDevice *device;
    VALUE address_bytes;
    char * tmp = NULL;

    address_bytes = rb_funcall(self, rb_intern("address_bytes"), 0);

    if (RSTRING_LEN(address_bytes) != 6) {
        VALUE inspect = rb_inspect(address_bytes);
        rb_raise(rb_eArgError, "%s doesn't look like a bluetooth address",
                 StringValueCStr(inspect));
    }

    tmp = StringValuePtr(address_bytes);

    memcpy(address.data, tmp, 6);

    device = [IOBluetoothDevice withAddress: &address];

    return device;
}

VALUE rbt_device_request_name(VALUE self) {
    IOBluetoothDevice *device;
    IOReturn status;
    VALUE name;
    NSAutoreleasePool *pool;

    pool = [[NSAutoreleasePool alloc] init];

    device = rbt_device_get(self);

    status = [device remoteNameRequest: nil];

    if (status != kIOReturnSuccess)
        return Qnil;

    name = rb_str_new2([[device name] UTF8String]);

    [pool release];

    return name;
}

