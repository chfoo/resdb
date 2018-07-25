package resdb.adapter;

import haxe.io.Bytes;


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
