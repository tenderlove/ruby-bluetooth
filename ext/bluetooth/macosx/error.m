#import "ruby_bluetooth.h"
#import <IOKit/IOKitLib.h>

extern VALUE rbt_mBluetooth;
extern VALUE rbt_cBluetoothError;

VALUE errors;

void rbt_check_status(IOReturn status, NSAutoreleasePool *pool) {
    if (status != kIOReturnSuccess || status != noErr) {
        [pool release];

        rb_funcall(rbt_cBluetoothError, rb_intern("raise"), INT2NUM(status));
    }
}

void add_error(IOReturn status, const char *name, const char *message) {
    VALUE klass;
    VALUE value;

    klass = rb_define_class_under(rbt_mBluetooth, name, rbt_cBluetoothError);
    value = rb_ary_new3(2, klass, rb_str_new2(message));
    rb_hash_aset(errors, INT2NUM(status), value);
}

void init_rbt_error() {
    VALUE tmp;

    errors = rb_const_get(rbt_mBluetooth, rb_intern("ERRORS"));

    tmp = rb_ary_new3(2, rbt_cBluetoothError, rb_str_new2("general error"));
    rb_hash_aset(errors, INT2NUM(kIOReturnError), tmp);

    add_error(kIOReturnNoMemory,         "NoMemory",
            "can't allocate memory");
    add_error(kIOReturnNoResources,      "NoResources",
            "resource shortage");
    add_error(kIOReturnIPCError,         "IPCError",
            "error during IPC");
    add_error(kIOReturnNoDevice,         "NoDevice",
            "no such device");
    add_error(kIOReturnNotPrivileged,    "NotPrivileged",
            "privilege violation");
    add_error(kIOReturnBadArgument,      "BadArgument",
            "invalid argument");
    add_error(kIOReturnLockedRead,       "LockedRead",
            "device read locked");
    add_error(kIOReturnLockedWrite,      "LockedWrite",
            "device write locked");
    add_error(kIOReturnExclusiveAccess,  "ExclusiveAccess",
            "exclusive access and device already open");
    add_error(kIOReturnBadMessageID,     "BadMessageID",
            "sent/received messages had different msg_id");
    add_error(kIOReturnUnsupported,      "Unsupported",
            "unsupported function");
    add_error(kIOReturnVMError,          "VMError",
            "misc. VM failure");
    add_error(kIOReturnInternalError,    "InternalError",
            "internal error");
    add_error(kIOReturnIOError,          "IOError",
            "General I/O error");
    add_error(kIOReturnCannotLock,       "CannotLock",
            "can't acquire lock");
    add_error(kIOReturnNotOpen,          "NotOpen",
            "device not open");
    add_error(kIOReturnNotReadable,      "NotReadable",
            "read not supported");
    add_error(kIOReturnNotWritable,      "NotWritable",
            "write not supported");
    add_error(kIOReturnNotAligned,       "NotAligned",
            "alignment error");
    add_error(kIOReturnBadMedia,         "BadMedia",
            "Media Error");
    add_error(kIOReturnStillOpen,        "StillOpen",
            "device(s) still open");
    add_error(kIOReturnRLDError,         "RLDError",
            "rld failure");
    add_error(kIOReturnDMAError,         "DMAError",
            "DMA failure");
    add_error(kIOReturnBusy,             "Busy",
            "Device Busy");
    add_error(kIOReturnTimeout,          "Timeout",
            "I/O Timeout");
    add_error(kIOReturnOffline,          "Offline",
            "device offline");
    add_error(kIOReturnNotReady,         "NotReady",
            "not ready");
    add_error(kIOReturnNotAttached,      "NotAttached",
            "device not attached");
    add_error(kIOReturnNoChannels,       "NoChannels",
            "no DMA channels left");
    add_error(kIOReturnNoSpace,          "NoSpace",
            "no space for data");
    add_error(kIOReturnPortExists,       "PortExists",
            "port already exists");
    add_error(kIOReturnCannotWire,       "CannotWire",
            "can't wire down physical memory");
    add_error(kIOReturnNoInterrupt,      "NoInterrupt",
            "no interrupt attached");
    add_error(kIOReturnNoFrames,         "NoFrames",
            "no DMA frames enqueued");
    add_error(kIOReturnMessageTooLarge,  "MessageTooLarge",
            "oversized msg received on interrupt port");
    add_error(kIOReturnNotPermitted,     "NotPermitted",
            "not permitted");
    add_error(kIOReturnNoPower,          "NoPower",
            "no power to device");
    add_error(kIOReturnNoMedia,          "NoMedia",
            "media not present");
    add_error(kIOReturnUnformattedMedia, "UnformattedMedia",
            "media not formatted");
    add_error(kIOReturnUnsupportedMode,  "UnsupportedMode",
            "no such mode");
    add_error(kIOReturnUnderrun,         "Underrun",
            "data underrun");
    add_error(kIOReturnOverrun,          "Overrun",
            "data overrun");
    add_error(kIOReturnDeviceError,      "DeviceError",
            "the device is not working properly!");
    add_error(kIOReturnNoCompletion,     "NoCompletion",
            "a completion routine is required");
    add_error(kIOReturnAborted,          "Aborted",
            "operation aborted");
    add_error(kIOReturnNoBandwidth,      "NoBandwidth",
            "bus bandwidth would be exceeded");
    add_error(kIOReturnNotResponding,    "NotResponding",
            "device not responding");
    add_error(kIOReturnIsoTooOld,        "IsoTooOld",
            "isochronous I/O request for distant past!");
    add_error(kIOReturnIsoTooNew,        "IsoTooNew",
            "isochronous I/O request for distant future");
    add_error(kIOReturnNotFound,         "NotFound",
            "data was not found");
    add_error(kIOReturnInvalid,          "Invalid",
            "should never be seen");
}

