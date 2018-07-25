package resdb;

import haxe.ds.Option;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import resdb.pageformat.RecordPage;

/**
    Navigates and retrieves key-values records.

    By default, the cursor is pointing to the first record in the
    database.
**/
class Cursor {
    var database:Database;
    var currentPageID:Int;
    var currentPage:RecordPage;
    var currentArrayIndex:Int;

    public function new(database:Database) {
        this.database = database;

        loadPage(database.metaPage.firstPageID);
    }

    function loadPage(pageID:Int) {
        var pageBytes = database.store.getPage(pageID);
        currentPage = new RecordPage();
        currentPage.load(new BytesInput(pageBytes));

        currentPageID = pageID;
        currentArrayIndex = 0;
    }

    /**
        Navigates to the first key in the database and returns that key.
    **/
    public function first():Bytes {
        loadPage(database.metaPage.firstPageID);

        return key();
    }

    /**
        Navigates to the last key in the database and returns that key.
    **/
    public function last():Bytes {
        loadPage(database.metaPage.lastPageID);
        currentArrayIndex = currentPage.records.length - 1;

        return key();
    }

    /**
        Navigates to the nearest key that is equal or less to the given
        key and returns that key.
    **/
    public function find(key:Bytes):Option<Bytes> {
        switch findPage(key) {
            case Some(pageID):
                loadPage(pageID);
                currentArrayIndex = findRecordIndex(key);
                return Some(currentPage.records[currentArrayIndex].key);
            case None:
                return None;
        }
    }

    function findPage(key:Bytes):Option<Int> {
        for (index in 0...database.metaPage.pageKeyRanges.length) {
            var pageID = database.metaPage.firstPageID + index;
            var pageKeyRange = database.metaPage.pageKeyRanges[index];

            if (pageKeyRange.startKey.compare(key) <= 0
                    && pageKeyRange.endKey.compare(key) >= 0) {
                return Some(pageID);
            }
        }

        return None;
    }

    function findRecordIndex(key:Bytes):Int {
        var candidateIndex = 0;

        for (index in 0...currentPage.records.length) {
            var record = currentPage.records[index];

            if (key.compare(record.key) >= 0) {
                candidateIndex = index;
            } else {
                break;
            }
        }

        return candidateIndex;
    }

    /**
        Navigates to the previous key and returns it.
    **/
    public function previous():Option<Bytes> {
        if (currentArrayIndex - 1 >= 0) {
            currentArrayIndex -= 1;
        } else if (currentPageID - 1 >= database.metaPage.firstPageID) {
            loadPage(currentPageID - 1);
            currentArrayIndex = currentPage.records.length - 1;
        } else {
            return None;
        }

        return Some(key());
    }

    /**
        Navigates the next key and returns it.
    **/
    public function next():Option<Bytes> {
        if (currentArrayIndex + 1 < currentPage.records.length) {
            currentArrayIndex += 1;
        } else if (currentPageID + 1 <= database.metaPage.lastPageID) {
            loadPage(currentPageID + 1);
        } else {
            return None;
        }

        return Some(key());
    }

    /**
        Returns the key of the current record.
    **/
    public function key():Bytes {
        return currentPage.records[currentArrayIndex].key;
    }

    /**
        Returns the value of the current record.
    **/
    public function value():Bytes {
        return currentPage.records[currentArrayIndex].value;
    }

    /**
        Navigates to the given key and returns it if it exists.
    **/
    public function get(key:Bytes):Option<Bytes> {
        switch find(key) {
            case Some(cursorKey):
                if (key.compare(cursorKey) == 0) {
                    return Some(value());
                } else {
                    return None;
                }
            case None:
                return None;
        }
    }
}
