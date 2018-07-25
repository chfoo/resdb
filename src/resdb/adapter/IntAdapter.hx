package resdb.adapter;

import haxe.io.Bytes;
import haxe.ds.Option;


class IntAdapter {
    public static function intAddRecord(pagePacker:PagePacker, key:Int, value:Bytes) {
        pagePacker.addRecord(IntConverter.intToBytes(key), value);
    }

    public static function intGet(database:Database, key:Int):Option<Bytes> {
        return database.get(IntConverter.intToBytes(key));
    }

    public static function intCursor(database:Database):IntCursor {
        return new IntCursor(database.cursor());
    }
}


class IntCursor extends CursorAdapter<Int,Bytes> {
    public function new(cursor:Cursor) {
        super(cursor, new IntConverter(), new IdentityConverter());
    }
}
