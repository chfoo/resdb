package resdb.pageformat;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.Int64;


class Record implements Serializable {
    public var key:Bytes;
    public var value:Bytes;

    public function new() {
    }

    public function load(input:BytesInput) {
        var keyLength = input.readInt32();
        key = input.read(keyLength);

        var valueLength = input.readInt32();
        value = input.read(valueLength);
    }

    public function save(output:BytesOutput) {
        output.writeInt32(key.length);
        output.write(key);

        output.writeInt32(value.length);
        output.write(value);
    }

    public function totalLength():Int {
        return 4 + key.length + 4 + value.length;
    }
}
