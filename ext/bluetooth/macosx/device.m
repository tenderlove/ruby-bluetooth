#import "ruby_bluetooth.h"

//extern VALUE rbt_cBluetoothDevice;

VALUE rbt_request_name(VALUE self) {
    BluetoothDeviceAddress b_address;
    IOBluetoothDevice *device;
    IOReturn status;
    char * tmp = NULL;
    VALUE name, v_address;
    NSAutoreleasePool *pool;

    v_address = rb_funcall(self, rb_intern("address_bytes"), 0);

    if (RSTRING_LEN(v_address) != 6) {
        VALUE inspect = rb_inspect(v_address);
        rb_raise(rb_eArgError, "%s doesn't look like a bluetooth address",
                 StringValueCStr(inspect));
    }

    tmp = StringValuePtr(v_address);

    memcpy(b_address.data, tmp, 6);

    pool = [[NSAutoreleasePool alloc] init];

    device = [IOBluetoothDevice withAddress: &b_address];

    status = [device remoteNameRequest: nil];

    if (status != kIOReturnSuccess)
        return Qnil;

    name = rb_str_new2([[device name] UTF8String]);

    [pool release];

    return name;
}

