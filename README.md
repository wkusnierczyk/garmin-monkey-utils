# MonkeyUtils Barrel

A collection of utility modules for Monkey C (Garmin Connect IQ) development. 

This barrel provides:
* robust string manipulation;
* safe property retrieval to simplify app development.


> This barrel does not aim at exhaustive treatment of all functionality on `String` and `Property` objects.
>
> It was created and is maintained as a **Build What You Need** (BWYN) project, conceived while developing specific Garmin Connect IQ SDK projects (see [Garmin Watch Faces](https://github.com/wkusnierczyk/garmin-watch-faces)).
> It is offered _as is_, and may or may not grow in coverage over time.

---


## Table of Contents
1. [Installation](#installation)
2. [Configuration](#configuration)
3. [Usage](#usage)
4. [Documentation](#documentation)

## Installation

### 1. Add Submodule
Add this repository as a submodule to your project to keep it versioned and easy to update.

```bash
cd {your garmin project root}

git submodule add https://github.com/wkusnierczyk/garmin-monkey-utils.git barrels/MonkeyUtils
```

### 2. Build the Barrel
Before you can use it, you must build the `.barrel` file.

```bash
cd barrels/MonkeyUtils

# Build MonkeyUtils.barrel
make build
```

---

## Configuration

To make your app "see" the barrel, you must edit two files in your project root.

### `monkey.jungle`
Tell the compiler where to look for barrels. Add the `base.barrelPath` line:

```properties
project.manifest = manifest.xml

# Add the path to the directory containing the .barrel file
base.barrelPath = $(base.barrelPath);barrels/MonkeyUtils
```

### `manifest.xml`
Declare that your app depends on this specific barrel.

```xml
<iq:manifest version="3" xmlns:iq="[http://www.garmin.com/xml/connectiq](http://www.garmin.com/xml/connectiq)">
    <iq:application ...>
        
        <iq:depends>
            <!-- Use the appropriate version -->
            <iq:barrel module="MonkeyUtils" version="0.1.0"/>
        </iq:depends>

    </iq:application>
</iq:manifest>
```

---

## Usage

Once configured, you can import the module in your `.mc` files.

### Property Utilities
Safely retrieve properties without crashing on missing keys or null values.

```monkeyc
using MonkeyUtils.PropertyUtils;

// Inside your class
function onLoad() {
    // Returns the value of "MySetting" or false if it doesn't exist/is null
    var mySetting = PropertyUtils.getPropertyElseDefault("MySetting", false);
    
    System.println("Setting is: " + mySetting);
}
```

### String Utilities
Use `StringUtils` to split strings. You can choose between **Eager** (fast, more memory) or **Lazy** (slower, less memory) splitting.

```monkeyc
import MonkeyUtils.StringUtils;

function parseData() {
    var rawData = "10,20,30,40";
    
    // METHOD 1: Simple Array Split (Eager)
    // Allocates an Array containing all substrings immediately.
    var parts = StringUtils.split(rawData, ",");
    
    // METHOD 2: Lazy Splitter (Memory Efficient)
    // Allocates substrings only as requested. 
    // Uses less peak memory than EagerSplitter because it avoids the Array overhead,
    // though it still holds the "remaining" string in memory.
    // Note that the remaining string is shrinking with each call to next() 
    // (unlike in the EagerSplitter, which maintains the full array at all times).
    var splitter = new StringUtils.LazySplitter(rawData, ",");
    
    while(splitter.hasNext()) {
        var token = splitter.next();
        System.println("Token: " + token);
    }
}
```

## Documentation
To generate the full HTML API documentation for this barrel:

```bash
monkeydoc -o docs -f monkey.jungle source/**/*.mc
```
Open `docs/index.html` in your web browser to view the generated reference.