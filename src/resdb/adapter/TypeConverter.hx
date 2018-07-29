package resdb.adapter;

import haxe.io.Bytes;


/**
    Serializes and deserializes data.
**/
interface TypeConverter<T> {
    function toBytes(input:T):Bytes;
    function fromBytes(input:Bytes):T;
}
