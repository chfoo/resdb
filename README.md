Resdb
=====

Resdb is a read-only, key-value database using a resource embedding system for Haxe. It can be used for querying moderately sized datasets in a portable manner.


Getting started
---------------

Requires Haxe 3 or 4.

Install the library using haxelib:

        haxelib install resdb

Alternatively, you may install the lastest git version:

        haxelib git resdb <URL of this repository>


### Packing records into pages

Resdb stores the records into separate resources called pages. To prepare the records, use a page packer:

```haxe
var pagePacker = new PagePacker({name: "myDatabase"});
```

Then add your records:

```haxe
pagePacker.addRecord(Bytes.ofString("key1"), Bytes.ofString("value1"));
pagePacker.addRecord(Bytes.ofString("key2"), Bytes.ofString("value2"));
```

The database should be prepared outside the runtime of your program. You can do this during compile time with an initialization macro.

A helper function that uses Haxe's resource system is provided:

```haxe
class MyDatabase {
    #if macro
    public static function packAndEmbed() {
        // ...
        // Your page packer code
        // ...

        ResourceHelper.addResource(pagePacker);
    }
    #end
}
```

Then, add the following compile time option:

```
--macro MyDatabase.packAndEmbed()
```

### Compiler performance

If your IDE uses compiler completion services, you may want to use conditional compilation to skip embedding the resources to avoid slowing down the completion service:

```haxe
#if !embed_resources
return;
#else
// Your page packer code
```

Then, specify `-D embed_resources` argument when building to a target.


### Accessing the database

When you need to access your database in your program, you need to obtain the appropriate page store. When using Haxe's system, a helper function is provided:

```haxe
var database = ResourceHelper.getDatabase({name: "myDatabase"});
```

You can then retrieve a record's value using a key:

```haxe
switch database.get(Bytes.ofString("key1")) {
    case Some(value):
        trace('Value = $value');
    case None:
        trace("Not found");
}
```

### Cursors

Cursors provide a way to navigate and query records by key in sorted order. You can create a cursor from your database instance:

```haxe
var cursor = database.cursor();
```

Then you can navigate in order, or to the first or last key:

```haxe
var firstKey = cursor.first();
var lastKey = cursor.last();

switch cursor.next() {
    case Some(nextKey):
        trace('Got next $nextKey');
    case None:
        trace("At last key");
}

switch cursor.previous() {
    case Some(previousKey):
        trace('Got next $previousKey');
    case None:
        trace("At last key");
}
```

You can get the current record that the cursor points to:

```haxe
var key = cursor.key();
var value = cursor.value();
```

To query for a key, use the `find()` method:

```haxe
var resultKey = cursor.find(Bytes.ofString("key5"));
```

The `find()` method will return the nearest key that is equal or less than the given key. The ordering is determined by `Bytes.compare`. In the example above, given a database containing keys `"key2", "key4", "key8"`, the resulting key will be `"key4"`.


### Adapters

While the underlying database uses `Bytes`, it may be more useful to use alternative types. By using `CursorAdapter`, and static extensions, you can bring your own wrappers and serializers.

The library includes `IntAdapter` that allows the use of integer `Int` as keys:

```haxe
using resdb.adapter.IntAdapter;

var database = ResourceHelper.getDatabase("myDatabase");
var result = database.intGet(123);
trace(result);

var cursor = database.intCursor();
var findResult = cursor.find(456);
trace(findResult);
```

Database format
---------------

The database stores records into pages. When the page packer processes the records, it sorts them by key, and fills pages with the serialized data. Records are not equally distributed and pages are filled up sequentially without splitting a record. As such, the maximum page size dictates how large a record may be.

Once all the records are packed and serialized into pages, the ranges of the records for each page are collected and serialized as the first page. The ranges serve as an index for looking up the appropriate page with the given key.
