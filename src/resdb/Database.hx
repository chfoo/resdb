package resdb;

import haxe.ds.Option;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import resdb.pageformat.RecordPage;
import resdb.pageformat.MetaPage;
import resdb.ds.Cache;


/**
    Client interface to the key-value record store.
**/
class Database {
    @:allow(resdb.Cursor)
    var store:PageStore;

    @:allow(resdb.Cursor)
    var metaPage:MetaPage;

    @:allow(resdb.Cursor)
    var recordPageCache:Cache<Int,RecordPage>;

    /**
        @param config Database configuration.
        @param store PageStore instance that contains the actual pages.
    **/
    public function new(config:DatabaseConfig, store:PageStore) {
        this.store = store;
        recordPageCache = new Cache(config.pageCache);

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
