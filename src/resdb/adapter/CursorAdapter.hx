package resdb.adapter;

import haxe.ds.Option;


/**
    Wraps a cursor to convert keys and values to different types.

    This is useful for automatically serializing and deserializing your
    keys or values.
**/
class CursorAdapter<K,V> {
    var cursor:Cursor;
    var keyConverter:TypeConverter<K>;
    var valueConverter:TypeConverter<V>;

    /**
        If a key or value does not need to be converted, use
        `IdentityConverter`.

        @param cursor The cursor object to be wrapped.
        @param keyConverter Convertor to be used for serializing the keys
            of the records.
        @param valueConverter Convertor to be used for serializing the values
            of the records.
    **/
    public function new(cursor:Cursor, keyConverter:TypeConverter<K>,
            valueConverter:TypeConverter<V>) {
        this.cursor = cursor;
        this.keyConverter = keyConverter;
        this.valueConverter = valueConverter;
    }

    /**
        Navigates to the first key in the database and returns that key.

        See `Cursor.first()`
    **/
    public function first():K {
        return keyConverter.fromBytes(cursor.first());
    }

    /**
        Navigates to the last key in the database and returns that key.

        See `Cursor.last()`
    **/
    public function last():K {
        return keyConverter.fromBytes(cursor.last());
    }

    /**
        Navigates to the nearest key and returns that key.

        See `Cursor.find()`
    **/
    public function find(key:K):Option<K> {
        switch cursor.find(keyConverter.toBytes(key)) {
            case Some(result):
                return Some(keyConverter.fromBytes(result));
            case None:
                return None;
        }
    }

    /**
        Navigates to the previous key and returns it.

        See `Cursor.previous()`
    **/
    public function previous():Option<K> {
        switch cursor.previous() {
            case Some(key):
                return Some(keyConverter.fromBytes(key));
            case None:
                return None;
        }
    }

    /**
        Navigates the next key and returns it.

        See `Cursor.next()`
    **/
    public function next():Option<K> {
        switch cursor.next() {
            case Some(key):
                return Some(keyConverter.fromBytes(key));
            case None:
                return None;
        }
    }

    /**
        Returns the key of the current record.

        See `Cursor.key()`
    **/
    public function key():K {
        return keyConverter.fromBytes(cursor.key());
    }

    /**
        Returns the value of the current record.

        See `Cursor.value()`
    **/
    public function value():V {
        return valueConverter.fromBytes(cursor.value());
    }

    /**
        Navigates to the given key and returns it if it exists.

        See `Cursor.get()`
    **/
    public function get(key:K):Option<V> {
        switch cursor.get(keyConverter.toBytes(key)) {
            case Some(result):
                return Some(valueConverter.fromBytes(result));
            case None:
                return None;
        }
    }
}
