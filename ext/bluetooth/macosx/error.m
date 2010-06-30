#import "ruby_bluetooth.h"
#import <IOKit/IOKitLib.h>

extern VALUE rbt_mBluetooth;
extern VALUE rbt_cBluetoothError;

VALUE errors;

void rbt_check_status(IOReturn status, NSAutoreleasePool *pool) {
    if (status != kIOReturnSuccess || status != noErr) {
        [pool release];

        rb_funcall(rbt_cBluetoothError, rb_intern("raise"), 1, INT2NUM(status));
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

    // IOKit
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

    // Bluetooth
    add_error(kBluetoothHCIErrorUnknownHCICommand, "UnknownHCICommand",
            "unknown HCI command");
	add_error(kBluetoothHCIErrorNoConnection, "NoConnection", "no connection");
    add_error(kBluetoothHCIErrorHardwareFailure, "HardwareFailure",
            "hardware failure");
	add_error(kBluetoothHCIErrorPageTimeout, "PageTimeout", "page timeout");
    add_error(kBluetoothHCIErrorAuthenticationFailure,
            "AuthenticationFailure", "authentication failure");
	add_error(kBluetoothHCIErrorKeyMissing, "KeyMissing", "key missing");
	add_error(kBluetoothHCIErrorMemoryFull, "MemoryFull", "memory full");
	add_error(kBluetoothHCIErrorConnectionTimeout, "ConnectionTimeout",
            "connection timeout");
    add_error(kBluetoothHCIErrorMaxNumberOfConnections,
            "MaxNumberOfConnections", "maximum number of connections");
    add_error(kBluetoothHCIErrorMaxNumberOfSCOConnectionsToADevice,
            "MaxNumberOfSCOConnectionsToADevice",
            "maximum number of synchronous connections to a device");
    add_error(kBluetoothHCIErrorACLConnectionAlreadyExists,
            "ACLConnectionAlreadyExists", "ACL connection already exists");
    add_error(kBluetoothHCIErrorCommandDisallowed, "CommandDisallowed",
            "command disallowed");
    add_error(kBluetoothHCIErrorHostRejectedLimitedResources,
            "HostRejectedLimitedResources",
            "host rejected, limited resources");
    add_error(kBluetoothHCIErrorHostRejectedSecurityReasons,
            "HostRejectedSecurityReasons", "host rejected, security reasons");
    add_error(kBluetoothHCIErrorHostRejectedRemoteDeviceIsPersonal,
            "HostRejectedRemoteDeviceIsPersonal",
            "host rejected, remote device is personal");
	add_error(kBluetoothHCIErrorHostTimeout, "HostTimeout", "host timeout");
    add_error(kBluetoothHCIErrorUnsupportedFeatureOrParameterValue,
            "UnsupportedFeatureOrParameterValue",
            "unsupported feature or parameter value");
    add_error(kBluetoothHCIErrorInvalidHCICommandParameters,
            "InvalidHCICommandParameters", "invalid HCI command parameters");
    add_error(kBluetoothHCIErrorOtherEndTerminatedConnectionUserEnded,
            "OtherEndTerminatedConnectionUserEnded",
            "the other end terminated the connection, by user");
    add_error(kBluetoothHCIErrorOtherEndTerminatedConnectionLowResources,
            "OtherEndTerminatedConnectionLowResources",
            "the other end terminated the connection, low resources");
    add_error(kBluetoothHCIErrorOtherEndTerminatedConnectionAboutToPowerOff,
            "OtherEndTerminatedConnectionAboutToPowerOff",
            "the other end terminated the connection, about to power off");
    add_error(kBluetoothHCIErrorConnectionTerminatedByLocalHost,
            "ConnectionTerminatedByLocalHost",
            "connection terminated by local host");
	add_error(kBluetoothHCIErrorRepeatedAttempts, "RepeatedAttempts",
            "repeated attempts");
	add_error(kBluetoothHCIErrorPairingNotAllowed, "PairingNotAllowed",
            "pairing is not allowed");
	add_error(kBluetoothHCIErrorUnknownLMPPDU, "UnknownLMPPDU",
            "unknown LMP PDU");
    add_error(kBluetoothHCIErrorUnsupportedRemoteFeature,
            "UnsupportedRemoteFeature", "unsupported remote feature");
	add_error(kBluetoothHCIErrorSCOOffsetRejected, "SCOOffsetRejected",
            "SCO offset rejected");
    add_error(kBluetoothHCIErrorSCOIntervalRejected, "SCOIntervalRejected",
            "SCO interval rejected");
	add_error(kBluetoothHCIErrorSCOAirModeRejected, "SCOAirModeRejected",
            "SCO air mode rejected");
    add_error(kBluetoothHCIErrorInvalidLMPParameters, "InvalidLMPParameters",
            "invalid LMP parameters");
	add_error(kBluetoothHCIErrorUnspecifiedError, "UnspecifiedError",
            "unspecified error");
    add_error(kBluetoothHCIErrorUnsupportedLMPParameterValue,
            "UnsupportedLMPParameterValue",
            "unsupported LMP parameter value");
    add_error(kBluetoothHCIErrorRoleChangeNotAllowed, "RoleChangeNotAllowed",
            "role change not allowed");
	add_error(kBluetoothHCIErrorLMPResponseTimeout, "LMPResponseTimeout",
            "LMP response timeout");
    add_error(kBluetoothHCIErrorLMPErrorTransactionCollision,
            "LMPErrorTransactionCollision",
            "LMP error transaction collision");
	add_error(kBluetoothHCIErrorLMPPDUNotAllowed, "LMPPDUNotAllowed",
            "LMP DU not allowed");
    add_error(kBluetoothHCIErrorEncryptionModeNotAcceptable,
            "EncryptionModeNotAcceptable", "encryption mode not acceptable");
	add_error(kBluetoothHCIErrorUnitKeyUsed, "UnitKeyUsed", "unit key used");
	add_error(kBluetoothHCIErrorQoSNotSupported, "QoSNotSupported",
            "QoS not supported");
	add_error(kBluetoothHCIErrorInstantPassed, "InstantPassed",
            "instant passed");
    add_error(kBluetoothHCIErrorPairingWithUnitKeyNotSupported,
            "PairingWithUnitKeyNotSupported",
            "pairing with unit key not supported");
    add_error(kBluetoothHCIErrorHostRejectedUnacceptableDeviceAddress,
            "HostRejectedUnacceptableDeviceAddress",
            "host rejected, unacceptable device address");
    add_error(kBluetoothHCIErrorDifferentTransactionCollision,
            "DifferentTransactionCollision",
            "different transaction collision");
    add_error(kBluetoothHCIErrorQoSUnacceptableParameter,
            "QoSUnacceptableParameter",
            "Qos unacceptable parameter");
	add_error(kBluetoothHCIErrorQoSRejected, "QoSRejected",
            "QoS rejected");
    add_error(kBluetoothHCIErrorChannelClassificationNotSupported,
            "ChannelClassificationNotSupported",
            "channel classification not supported");
    add_error(kBluetoothHCIErrorInsufficientSecurity, "InsufficientSecurity",
            "insufficient security");
    add_error(kBluetoothHCIErrorParameterOutOfMandatoryRange,
            "ParameterOutOfMandatoryRange",
            "parameter out of mandatory range");
	add_error(kBluetoothHCIErrorRoleSwitchPending, "RoleSwitchPending",
            "role switch pending");
    add_error(kBluetoothHCIErrorReservedSlotViolation,
            "ReservedSlotViolation", "reserved slot violation");
    add_error(kBluetoothHCIErrorRoleSwitchFailed, "RoleSwitchFailed",
            "role switch failed");
    add_error(kBluetoothHCIErrorExtendedInquiryResponseTooLarge,
            "ExtendedInquiryResponseTooLarge",
            "extended inquiry response too large");
    add_error(kBluetoothHCIErrorSecureSimplePairingNotSupportedByHost,
            "SecureSimplePairingNotSupportedByHost",
            "secure simple pairing not supported by host");
}

