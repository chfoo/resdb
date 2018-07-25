package resdb.adapter;

import haxe.io.Bytes;


interface TypeConverter<T> {
    function toBytes(input:T):Bytes;
    function fromBytes(input:Bytes):T;
}
