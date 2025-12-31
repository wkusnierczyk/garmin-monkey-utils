# MonkeyUtils

A robust, testable utility library for Garmin Connect IQ (Monkey C) development. 
This barrel provides functionality for string manipulation, array operations, and a unified iterator pattern to simplify collection processing.

> **Note** This barrel does not aim at exhaustive treatment of all functionality on `String` and `Property` objects.
> It was created and is maintained as a **Build What You Need** (BWYN) project, conceived while developing specific Garmin Connect IQ SDK projects (see [Garmin Watch Faces](https://github.com/wkusnierczyk/garmin-watch-faces)).
>
> `MonkeyUtils` is offered _as is_, and may or may not grow in coverage over time.

## Features

* **StringUtils**
    * Consistent Splitting: Handles leading/trailing empty tokens consistently (e.g., `":a:"` -> `["", "a", ""]`).
    * LazySplitter: Memory-efficient, iterator-based splitting for large strings.
    * EagerSplitter: Standard array-based splitting inheriting the same robust logic.
* **ArrayUtils**
    * Deep Equality: `equal()` checks content deep equality (recursive), unlike standard identity checks.
    * ArrayIterator: Iterate over standard arrays using the unified `Iterator` interface.
* **ContainerUtils**
    * Iterator Interface: A polymorphic contract allowing you to write generic logic that consumes data from Arrays, Strings, or custom collections interchangeably.
* **PropertyUtils**:
    * Convenience functionality to load properties with resorting to defaults upon failure.
    * `getPropertyElseDefault()` safely retrieves Application Properties, handling missing keys or API exceptions by returning a fallback value.
* **Tested**: unit-tested with matrix verification against edge cases.


## Installation

### Option A: As a Monkey Barrel (Recommended)

1.  Download the latest `MonkeyUtils.barrel` from the [Releases](../../releases) page.
2.  Place the file in your project's root directory (or a `barrels/` subfolder).
3.  Open your project in VS Code.
4.  Run the command: `Monkey C: Configure Monkey Barrels`.
5.  Select `MonkeyUtils.barrel` from the list.

Alternatively, edit your `manifest.xml` manually through the UI or directly in the XML code:
```xml
<iq:barrels>
    <iq:barrel filename="MonkeyUtils.barrel" />
</iq:barrels>
```

### Option B: As a Git Submodule

If you prefer source integration:

1.  Add this repo as a submodule:
    ```bash
    git submodule add (https://github.com/wkusnierczyk/garmin-monkey-utls.git) modules/MonkeyUtils
    ```
2.  Add the source paths to your `monkey.jungle`:
    ```properties
    # Add MonkeyUtils source to your project
    base.sourcePath = source;modules/MonkeyUtils/source
    ```

## Usage

### 1. String Splitting

Consistent behavior for Eager (fast) or Lazy (memory-efficient) splitting.

```monkeyc
import MonkeyUtils;

// 1. Static (Eager) - Simple & standard
var parts = StringUtils.split("A,B,C", ","); 

// 2. Lazy Iterator - Best for long strings or memory constraints
var splitter = new StringUtils.LazySplitter("A,B,C", ",");
while (splitter.hasNext()) {
    System.println(splitter.next()); // Prints "A", then "B", then "C"
}
```

### 2. Iterators & Polymorphism

Use the unified `Iterator` interface to process any collection generically.

```monkeyc
import MonkeyUtils;

// Convert a standard Array into an Iterator
var myData = ["One", "Two", "Three"];
var iter = ArrayUtils.getIterator(myData);

processItems(iter);

// Works with Splitters too!
var splitIter = new StringUtils.EagerSplitter("One,Two,Three", ",");
processItems(splitIter);

// Generic processor that doesn't care about the source
function processItems(iter as ContainerUtils.Iterator) {
    while (iter.hasNext()) {
        System.println(iter.next());
    }
}
```

### 3. Array Deep Equality

Standard Monkey C `equals` often checks reference identity. Use `ArrayUtils` for content verification.

```monkeyc
var a = [1, [2, 3]];
var b = [1, [2, 3]];

// Returns true only if content matches recursively
if (ArrayUtils.equal(a, b)) {
    System.println("Arrays are identical in content!");
}
```

### 4. Safe Property Access

Retrieve settings safely without crashing on missing keys.

```monkeyc
import MonkeyUtils;

// Retrieve "my_setting_id". If it doesn't exist (or throws an error), return 10.
var limit = PropertyUtils.getPropertyElseDefault("my_setting_id", 10);

var name = PropertyUtils.getPropertyElseDefault("user_name", "Guest");
```

## Build & Test

This project uses a `Makefile` for building, testing, and packaging.

### Prerequisites
* Garmin Connect IQ SDK installed.
* `monkeyc` and `monkeydo` in your PATH.
* `jq` (for test data validation).

### Commands

| Command | Description |
| :--- | :--- |
| `make build` | Compiles the barrel file (`bin/MonkeyUtils.barrel`). |
| `make test` | Validates JSON data, builds tests, and runs the matrix test suite in the simulator. |
| `make clean` | Removes build artifacts (`bin/`, `gen/`). |
| `make docs` | Generates HTML documentation using `monkeydoc`. |



## License

[MIT License](LICENSE)

