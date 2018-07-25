package resdb.adapter;

import haxe.ds.Option;


class CursorAdapter<K,V> {
    var cursor:Cursor;
    var keyConverter:TypeConverter<K>;
    var valueConverter:TypeConverter<V>;

    public function new(cursor:Cursor, keyConverter:TypeConverter<K>,
            valueConverter:TypeConverter<V>) {
        this.cursor = cursor;
        this.keyConverter = keyConverter;
        this.valueConverter = valueConverter;
    }

    public function first():K {
        return keyConverter.fromBytes(cursor.first());
    }

    public function last():K {
        return keyConverter.fromBytes(cursor.last());
    }

    public function find(key:K):Option<K> {
        switch cursor.find(keyConverter.toBytes(key)) {
            case Some(result):
                return Some(keyConverter.fromBytes(result));
            case None:
                return None;
        }
    }

    public function previous():Option<K> {
        switch cursor.previous() {
            case Some(key):
                return Some(keyConverter.fromBytes(key));
            case None:
                return None;
        }
    }

    public function next():Option<K> {
        switch cursor.next() {
            case Some(key):
                return Some(keyConverter.fromBytes(key));
            case None:
                return None;
        }
    }

    public function key():K {
        return keyConverter.fromBytes(cursor.key());
    }

    public function value():V {
        return valueConverter.fromBytes(cursor.value());
    }

    public function get(key:K):Option<V> {
        switch cursor.get(keyConverter.toBytes(key)) {
            case Some(result):
                return Some(valueConverter.fromBytes(result));
            case None:
                return None;
        }
    }
}
