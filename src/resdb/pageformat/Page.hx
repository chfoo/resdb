package resdb.pageformat;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;


/**
    A segment of data in the database.
**/
class Page implements Serializable  {
    public function new() {
    }

    /**
        Deserialize the given input into this instance.
    **/
    public function load(input:BytesInput) {
    }

    /**
        Serialize this page into output.
    **/
    public function save(output:BytesOutput) {
    }
}
