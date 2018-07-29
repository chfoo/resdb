package resdb.adapter;

import haxe.io.Bytes;


/**
    Serializes/deserializes integers in big-endian byte order.
**/
class IntConverter implements TypeConverter<Int> {
    public function new() {
    }

    public static function intToBytes(input:Int):Bytes {
        var bytes = Bytes.alloc(4);
        bytes.set(0, (input >> 24) & 0xff);
        bytes.set(1, (input >> 16) & 0xff);
        bytes.set(2, (input >> 8) & 0xff);
        bytes.set(3, input & 0xff);
        return bytes;
    }

    public function toBytes(input:Int):Bytes {
        return intToBytes(input);
    }

    public static function bytesToInt(input:Bytes):Int {
        if (input.length != 4) {
            throw "Bytes not length 4";
        }

        return input.get(0) << 24
            | input.get(1) << 16
            | input.get(2) << 8
            | input.get(3);
    }

    public function fromBytes(input:Bytes):Int {
        return bytesToInt(input);
    }
}
