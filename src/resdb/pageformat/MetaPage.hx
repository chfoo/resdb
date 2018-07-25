package resdb.pageformat;

import haxe.DynamicAccess;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import org.msgpack.MsgPack;


class MetaPage extends Page implements Serializable {
    public var keyCount:Int;
    public var firstPageID:Int;
    public var lastPageID(get, never):Int;
    public var pageKeyRanges:Array<IndexRange>;

    function get_lastPageID():Int {
        return firstPageID + pageKeyRanges.length - 1;
    }

    override public function load(input:BytesInput) {
        super.load(input);

        var doc:DynamicAccess<Any> = MsgPack.decode(input.readAll());
        keyCount = doc.get("keyCount");
        firstPageID = doc.get("firstPageID");
        pageKeyRanges = doc.get("pageKeyRanges");
    }

    override public function save(output:BytesOutput) {
        super.save(output);

        output.write(MsgPack.encode({
            keyCount: keyCount,
            firstPageID: firstPageID,
            pageKeyRanges: pageKeyRanges
        }));
    }
}


typedef IndexRange = {
    startKey:Bytes,
    endKey:Bytes
};
