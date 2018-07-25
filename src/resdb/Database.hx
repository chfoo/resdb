package resdb;

import haxe.ds.Option;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import resdb.pageformat.MetaPage;


/**
    Client interface to the key-value record store.
**/
class Database {
    @:allow(resdb.Cursor)
    var store:PageStore;

    @:allow(resdb.Cursor)
    var metaPage:MetaPage;

    /**
        @param store PageStore instance that contains the actual pages.
    **/
    public function new(store:PageStore) {
        this.store = store;

        metaPage = new MetaPage();
        metaPage.load(new BytesInput(store.getPage(0)));
    }

    /**
        Returns the associated value to the given key.
    **/
    public function get(key:Bytes):Option<Bytes> {
        var cursor = new Cursor(this);
        return cursor.get(key);
    }

    /**
        Returns the number of keys in the database.
    **/
    public function count():Int {
        return metaPage.keyCount;
    }

    /**
        Returns a cursor for more reading records in an advanced manner.
    **/
    public function cursor():Cursor {
        return new Cursor(this);
    }
}
