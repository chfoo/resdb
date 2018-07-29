package resdb.pageformat;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;


/**
    Interface for serializing pages.
**/
interface Serializable {
    function load(input:BytesInput):Void;
    function save(output:BytesOutput):Void;
}
