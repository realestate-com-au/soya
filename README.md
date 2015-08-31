# Soya

YAML/JSON file toolkit

## Introduction

Soya is a program designed to work with YAML and JSON files in a flexible manner that I hope will be useful for configuration
management.

## License

Copyright (c) 2015 REA-Group

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## System Requirements

- Ruby 1.9.3 (or higher). See: <https://www.ruby-lang.org>
- Rubygem safe_yaml 1.0.4 (or higher). See: <https://github.com/dtao/safe_yaml>

## License

This code is copyrighted under the MIT license.

## Installation

    $ gem install safe_yaml -v 1.0.4
    $ gem install soya
    $ soya -h

## Tutorial with examples

### How do I view the usage information?

    $ soya -h
    Usage: soya [OPTION]... [FILE]...

        -C, --canonical                  Output in a canonical order.
        -s, --[no-]strict                Strict mode (error on duplicate keys)
        -f, --from=format                Input/from file format [json, yaml (default)]
        -t, --to=format                  Output/to file format [json, yaml (default)]

        -D, --define=PATH=EXPRESSION ... Define an element
        -c, --copy=DEST=SRC ...          Copy a source subtree path to a destination path
        -e, --extract=PATH               Output the subtree under PATH
        -d, --delete=PATH ...            Deletes the subtree under PATH
        -i, --insert=PATH                Insert the entire tree under PATH

        -v, --verbose                    Verbose mode
        -V, --version                    Display version
        -h, --help                       Display help

    Processing order: merge, definition, copying, extraction, deletion, insertion
    PATH is a dot-delimited list of keys.

    $ soya -V
    soya 0.9.1


### Let's create a sample file

    $ echo '{"brand":"Hyundai","model":"i30","year":2014,"engine":{"type":"Nu","capacity":1.8},"options":{"camera":true,"gps":false},"service_history":[{"datetime":"2014-07-10T03:12:51Z","cost":0.0,"odometer":2952},{"datetime":"2015-04-21T23:41:03Z","cost":199.95,"odometer":10937}]}' > car.json

### JSON to YAML conversion

#### Reading from standard input.

    $ cat car.json | soya -f json -t yaml | tee car.yaml
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937

### YAML to JSON conversion

#### Reading from filename

    $ soya -f yaml -t json car.yaml
    {
      "brand": "Hyundai",
      "model": "i30",
      "year": 2014,
      "engine": {
        "type": "Nu",
        "capacity": 1.8
      },
      "options": {
        "camera": true,
        "gps": false
      },
      "service_history": [
        {
          "datetime": "2014-07-10T03:12:51Z",
          "cost": 0.0,
          "odometer": 2952
        },
        {
          "datetime": "2015-04-21T23:41:03Z",
          "cost": 199.95,
          "odometer": 10937
        }
      ]
    }

YAML is the default input and output format. Therefore, both "`-f`" and "`-t`" are optional. Furthermore, because YAML-1.2 is a
strict superset of JSON (See: <https://en.wikipedia.org/wiki/JSON#YAML>), "`-f`" is only used if you want to be explicit or you
want to ensure that a YAML file cannot be loaded because it's supposed to be a JSON file.

### Merging multiple files

You know what. I'd like to separate the car details (which is immutable) from the car's service history (which changes regularly).
Let's split it for ease of maintainance.

    $ cat car_base.yaml
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    $ cat car_service_history.yaml
    ---
    brand: test brand remove before commit
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937

But when using it, I want to merge it back:

    $ soya car_base.yaml car_service_history.yaml
    ---
    brand: test brand remove before commit
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937

Whoops, I made a mistake in the above example. I included the "`brand`" key twice. Notice that the merging occurs in the same
order that the files are loaded.

### Merging multiple files (strict mode)

In the circumstance that there are clashing keys, I might want an error (along with a non-zero return code) instead of overwriting
silently.

    $ cat car_service_history.yaml | soya -s car_base.yaml -
    soya: duplicate key: brand
    $ echo $?
    1
    $ grep -v '^brand: ' car_service_history.yaml | soya -s car_base.yaml -
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937

This program also follows standard Unix conventions such as:

- Input from standard-input (by default); regular-output to standard-output and warnings/errors to standard-error.
- Return code is zero on success and non-zero on errors.
- If even a single input filename (or a single definition expression) is provided, then the program won't try to read from standard-input.
- An option of "`--`" (double-dash) stops further command-line argument processing (which lets you use filenames that start with a dash).
- The filename of "`-`" (dash) means read from standard-input.
- If you really want to use "`-`" as a filename, then either prepend it  with "`./`" or the filename's absolute path.
- You can specify as many input filenames as you want (dependent on OS limits).

Here's a basic example where "`soya`" acts like "`cat`".

    $ cat car.yaml | soya
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937

    ## See doc directory for the sample files
    $ cat third.yaml | soya first.yaml second.yaml - fourth.yaml fifth.yaml
    ---
    first: 1
    common: 5
    second: 2
    third: 3
    fourth: 4
    fifth: 5

### Canonisation

While you should never depend on the ordering of elements within a hash (map/associative-array). There are times where it's helpful
to have the hash come out in a deterministic ordering for the purposes of comparing multiple runs. Soya supports the sorting of
hash keys. In the future (and between soya versions), the sort order might change, but it should always remain deterministic for a
specific soya version.

    $ soya car.yaml
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937

    $ soya -C car.yaml
    ---
    brand: Hyundai
    engine:
      capacity: 1.8
      type: Nu
    model: i30
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937
    year: 2014

### Definitions

I've also got a GPS and baby-seats which I can install/uninstall on-demand, so I don't really want to put it into a file. I'd
rather set it (and a bunch of other definitions) on the command-line. (Why yes, I give my cars numeric-like names/versions, doesn't
everyone?)

    $ soya -Doptions.gps=true -Doptions.baby_seat=2 '-Dname="123"' -Dversion="'1.2'" -Dodometer=1.36312e4 '-Dcups=[1,"two"]'
    ---
    options:
      gps: true
      baby_seat: 2
    name: '123'
    version: '1.2'
    odometer: 13631.2
    cups:
    - 1
    - two

Note that the "`true`" value and number are correctly auto-detected (likewise for "`null`" and "`false`"). And string values can
be quoted (using either single or double quotes) to force it to be interpreted as a string. Just make sure that your quotes aren't
consumed by your command-shell (eg "`bash`"). Also note that floating-point numbers can be defined using scientific notation.

You can also have multiple definitions and they can contain arrays/objects in JSON-like syntax. Nonetheless, there are currently
limitations of the expression-syntax. But if you want a solution that can cover all corner cases, then you're better off writing
raw JSON. Think of this as a 90% solution that is significantly more readable.

### Copying

You can also copy an entire subtree to another path. In the case below, the "`options`" subtree is copied to "`extra.addons`". Note
that subsequent modifications to "`options`" will not affect "`extra.addons`". You can also have multiple copy options.

    $ soya -c extra.addons=options car.yaml
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false
    service_history:
    - datetime: '2014-07-10T03:12:51Z'
      cost: 0.0
      odometer: 2952
    - datetime: '2015-04-21T23:41:03Z'
      cost: 199.95
      odometer: 10937
    extra:
      addons:
        camera: true
        gps: false

### Extraction

If you're only interested in part of the output (or even a single value), you can output just that subtree/value. You can also
extract an element of an array (indices begin from zero). Note that this (and much more) can be (better) done by the very cool tool
"`jq`" (see: <https://stedolan.github.io/jq/>). I've also been told that JMESPath (see: <http://jmespath.org/>) is cool, though
I've never used it myself.

    $ soya -e engine car.yaml
    ---
    type: Nu
    capacity: 1.8
    $ soya -t json -e service_history.[0] car.yaml
    {
      "datetime": "2014-07-10T03:12:51Z",
      "cost": 0.0,
      "odometer": 2952
    }
    $ soya -t json -e service_history.[1].cost car.yaml
    199.95

### Insertion

You can also move the output to beneath a specific path.

    $ soya -i lee.alice car.yaml
    ---
    lee:
      alice:
        brand: Hyundai
        model: i30
        year: 2014
        engine:
          type: Nu
          capacity: 1.8
        options:
          camera: true
          gps: false
        service_history:
        - datetime: '2014-07-10T03:12:51Z'
          cost: 0.0
          odometer: 2952
        - datetime: '2015-04-21T23:41:03Z'
          cost: 199.95
          odometer: 10937

### Deletion

You can also remove the subtree beneath a specific path. Like extraction, arrays are also supported. You can also have multiple
delete options.

    $ soya -dservice_history car.yaml
    ---
    brand: Hyundai
    model: i30
    year: 2014
    engine:
      type: Nu
      capacity: 1.8
    options:
      camera: true
      gps: false

### Burger-with-the-lot

The above techniques interoperate pretty independently. The only major piece of information is the order of evaluation:

1. Files are loaded in the order provided and merged.
1. Definitions are evaluated.
1. Copying is performed.
1. Extraction occurs.
1. Followed by any deletion.
1. With insertion occurring last.

Let me move from the world of cars onto a fictional example of configuring MailPile (see: <https://www.mailpile.is/>) for
deployment using a fictional tool called shipper when using Jenkins (see: <https://www.jenkins-ci.org/>) into a data-centre. See
sample files under the "`doc`" directory. Yes, this example is just a tad contrived and is therefore unnecessarily complicated.
That's what a Burger-with-the-Lot means -- bon appétit.

    $ BUILD_NUMBER=123
    $ env=production
    $ epoch=1
    $ soya -c "tmp=datacentre.${env}" -e "tmp" -i datacentre "all_datacentre_config.yaml" > "${env}.yaml"
    $ soya -i "application.mailpile.environment" "mailpile_config_${env}.yaml" > mailpile_config.yaml
    $ soya -s "${env}.yaml" mailpile.yaml mailpile_config.yaml > shipper.yaml
    $ soya -f yaml -t json -Dapplication.mailpile.version="'${epoch}.${BUILD_NUMBER}'" shipper.yaml > shipper.json
    $ shipper -c shipper.json deploy

This tool was written with configuration management in mind. It aims to encourage the Unix-like pipe-processing of configuration
files and templates. I've refrain from providing any best-practice on how this should be done. That is, I've provided the mechanism
without dictating (or even favouring) any policy (see: <https://en.wikipedia.org/wiki/Separation_of_mechanism_and_policy>).

## History and Philosophy

I initially wanted to write a program that converted between YAML and JSON. That was due to my desire to use YAML as my
AWS-CloudFormation template language (due to YAML's support of comments), but I still wanted to be able to easily use JSON
templates from online search results.

Over time, the problem space expanded. I should possibly split this into multiple programs, that's the Unix-way after all. But
managing half-a-dozen scripts seems like it'd be a pain-in-the-posterior. And the various functionality seems to complement each
other pretty well.

The background of the copying functionality was my desire to take advantage of anchors/references within the YAML specification.
But given the lack of JSON support, I made it a copy action instead. This is a pattern in this program. While it supports both
JSON and YAML, it fundamentally caters to the lowest-common-denominator (which is JSON) when deciding what's valid/invalid (eg
data-types). It's undoubtedly a sign that I should have one program that translates between JSON/YAML and a different one which
does everything else (with YAML only). But this current program solves my problem pretty well right now, though I accept chocolate
bribes.

YAML is a complex specification. And I'm pretty sure that there are bugs in more obscure uses of this program. That said, I suspect
I've covered 99% of the common use cases. And in the spirit of "Worse-is-Better" (see:
<https://www.dreamsongs.com/RiseOfWorseIsBetter.html>), I think I can leave those corner cases unresolved for now.
