package resdb.adapter;

import haxe.io.Bytes;


/**
    Converter that leaves data unchanged.

    This intended to be used in `CursorAdapter` for a key/value that uses bytes.
**/
class IdentityConverter implements TypeConverter<Bytes> {
    public function new() {
    }

    public function toBytes(input:Bytes):Bytes {
        return input;
    }

    public function fromBytes(input:Bytes):Bytes {
        return input;
    }
}
