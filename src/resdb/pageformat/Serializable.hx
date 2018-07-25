package resdb.pageformat;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;


interface Serializable {
    function load(input:BytesInput):Void;
    function save(output:BytesOutput):Void;
}
