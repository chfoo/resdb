package resdb;

import haxe.io.BytesOutput;
import resdb.pageformat.Page;
import resdb.pageformat.RecordPage;
import resdb.pageformat.MetaPage;
import resdb.pageformat.Record;
import haxe.io.Bytes;


/**
    Serializes and packs records into pages.

    This class is typically called outside the runtime environment, such
    as in initialization macro, to prepare the pages to be stored into
    a resource embedding system.

    The page size should be large enough to store the largest record. The
    default page size is 8 KB. All the records are processed in memory.
    Typically, this won't be a concern unless you are storing a huge amount or
    massively large records.
**/
class PagePacker {
    var records:Array<Record>;
    public var config(default, null):DatabaseConfig;

    public function new(config:DatabaseConfig) {
        this.config = config;
        records = [];
    }

    /**
        Adds a record to be processed.
    **/
    public function addRecord(key:Bytes, value:Bytes) {
        var record = new Record();
        record.key = key;
        record.value = value;

        records.push(record);
    }

    /**
        Processes and returns an array of bytes representing pages.
    **/
    public function packPages():Array<Bytes> {
        if (records.length == 0) {
            throw "At least 1 record required.";
        }

        sortRecords();

        var pages:Array<Page> = [];
        var metaPage = addMetaPage(pages);
        var currentRecordPage = new RecordPage();
        var currentSpaceRemaining = config.pageSize;

        function pushNewPage() {
            pages.push(currentRecordPage);
            metaPage.pageKeyRanges.push({
                startKey: currentRecordPage.records[0].key,
                endKey: currentRecordPage.records[currentRecordPage.records.length - 1].key,
            });
            currentRecordPage = new RecordPage();
            currentSpaceRemaining = config.pageSize;
        }

        for (record in records) {
            if (record.totalLength() > config.pageSize) {
                throw "Record too large for current page size.";
            }

            if (record.totalLength() > currentSpaceRemaining) {
                pushNewPage();
            }

            currentRecordPage.records.push(record);
            currentSpaceRemaining -= record.totalLength();
        }
        pushNewPage();

        return serializePages(pages);
    }

    function sortRecords() {
        records.sort(function (recordA, recordB) {
            return recordA.key.compare(recordB.key);
        });
    }

    function addMetaPage(pages:Array<Page>) {
        var metaPage = new MetaPage();

        metaPage.keyCount = records.length;
        metaPage.firstPageID = 1;
        metaPage.pageKeyRanges = [];

        pages.push(metaPage);

        return metaPage;
    }

    function serializePages(pages:Array<Page>) {
        var serializedPages = [];

        for (page in pages) {
            var output = new BytesOutput();
            page.save(output);
            serializedPages.push(output.getBytes());
        }

        return serializedPages;
    }
}
