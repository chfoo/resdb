package resdb.adapter;

import haxe.io.Bytes;
import haxe.ds.Option;


/**
    Helper class for static extension of databases with integer keys.
**/
class IntAdapter {
    /**
        Adds a record to be processed (with integer key).

        See `PagePacker.addRecord()`.
    **/
    public static function intAddRecord(pagePacker:PagePacker, key:Int, value:Bytes) {
        pagePacker.addRecord(IntConverter.intToBytes(key), value);
    }

    /**
        Returns the associated value to the given (integer) key.

        See `Database.get()`.
    **/
    public static function intGet(database:Database, key:Int):Option<Bytes> {
        return database.get(IntConverter.intToBytes(key));
    }

    /**
        Returns a cursor.

        See `Database.cursor()`.
    **/
    public static function intCursor(database:Database):IntCursor {
        return new IntCursor(database.cursor());
    }
}


/**
    Cursor adapter that uses integer keys.
**/
class IntCursor extends CursorAdapter<Int,Bytes> {
    public function new(cursor:Cursor) {
        super(cursor, new IntConverter(), new IdentityConverter());
    }
}
