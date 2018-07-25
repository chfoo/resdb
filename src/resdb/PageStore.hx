package resdb;

import haxe.io.Bytes;


/**
    Interface to the resource mechanism.
**/
interface PageStore {
    function getPage(page:Int):Bytes;
}
