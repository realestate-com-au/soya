# Soya
YAML/JSON file toolkit

## Introduction
Soya is a program designed to work with YAML and JSON files in a flexible manner that I hope will be useful for configuration
management.

## System Requirements
- Ruby 1.9.3 (or higher). See: <https://www.ruby-lang.org>
- Rubygem safe_yaml 1.0.4 (or higher). See: <https://github.com/dtao/safe_yaml>

## License

This code is copyrighted under the MIT license.

## Installation

    $ gem install safe_yaml -v 1.0.4
    $ ./soya -h

## Tutorial with examples

### How do I view the usage information?

    $ soya -h
    Usage: soya [OPTION]... [FILE]...

        -s, --[no-]strict                Strict mode (error on duplicate keys)
        -f, --from=format                Input/from file format [json, yaml (default)]
        -t, --to=format                  Output/to file format [json, yaml (default)]

        -D, --define=KEY=VALUE           Define an element
        -c, --copy=DEST=SRC              Copy an element
        -e, --extract=KEY                Only output a sub-tree
        -i, --insert=KEY                 Output everything under a common-key

        -v, --verbose                    Verbose mode
        -V, --version                    Display version
        -h, --help                       Display help

    Processing order: merge, definition, copying, extraction, insertion

    $ soya -V
    soya 0.5


### Let's create a sample file
    $ echo '{"brand":"Hyundai","model":"i30","year":2014,"engine":{"type":"Nu","capacity":1.8},"options":{"camera":true,"gps":false},"service_history":[{"datetime":"2014-07-10T03:12:51Z","cost":0.0,"odometer":2952},{"datetime":"2015-04-21T23:41:03Z","cost":199.95,"odometer":10937}]}' > car.json

### JSON to YAML conversion

#### Reading from standard input.

    $ cat car.json | soya -f json -t yaml > car.yaml
    $ cat car.yaml
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

YAML is the default input and output format.

This program also follows standard Unix conventions such as:

- Input from standard-input; regular-output to standard-output and warnings/errors to standard-error.
- Return code is zero on success and non-zero on errors.
- If an input filename (or definition expression) is provided, then the program won't try to read from standard-input.
- An option of "`--`" (double-dash) stops further command-line argument processing (which lets you use filenames that start with a dash).
- The filename of "`-`" (dash) means read from standard-input.
- If you really want to use "`-`" as a filename, then either prepend it  with "`./`" or the filename's absolute path.

So here's a basic example where "`soya`" acts like "`cat`".

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

As an aside, did you know that YAML-1.2 is a superset of JSON (See: <https://en.wikipedia.org/wiki/JSON#YAML>)

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

    $ cat car_base.yaml | soya - car_service_history.yaml
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

Whoops, I made a mistake in the above example. I included the key "`brand`" key twice. Notice that the merging occurs in order that
the files are loaded.

### Merging multiple files (strict mode)

In the circumstance that there are clashing keys, I might want an error (along with a non-zero return code) instead.

    $ cat car_base.yaml | soya -s - car_service_history.yaml
    soya: duplicate keys: brand
    $ echo $?
    1
    $ sed -i -e '/^brand/d' car_service_history.yaml
    $ cat car_base.yaml | soya -s - car_service_history.yaml
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

### Definitions

I've also got a GPS and baby-seats which I can install/uninstall on-demand, so I don't really want to put it into a file. I'd
rather set it (and a bunch of other options) on the command-line. Why yes, I give my cars numeric names and versions, doesn't
everyone?

    $ soya -Doptions.gps=true -Doptions.baby_seat=2 '-Dname="123456789"' -Dversion="'1.2'" -Dodometer=1.36312e4
    ---
    options:
      gps: true
      baby_seat: 2
    name: '123456789'
    version: '1.2'
    odometer: 13631.2

Note that the "`true`" value and number are correctly auto-detected (likewise for "`null`" and "`false`"). And string values can 
be quoted (using either single or double quotes) to force it to be interpreted as a string. Just make sure that your quotes aren't
consumed by your command-shell (eg "`bash`"). Also note that floating-point numbers can be defined using scientific notation.

In fact, you can even define arrays. Nonetheless, there are limitations of the expression-syntax. But if you want a solution that 
can cover all corner cases, then you're better off writing raw JSON. Think of this as a 90% solution that is significantly more
readable.

### Copying

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

If you're only interested in part of the output (or even a single value), you can output just that part. Note that this (and many
other things) can also be done by the very cool tool "`jq`" (see: <https://stedolan.github.io/jq/>).

    $ soya -e engine car.yaml
    ---
    type: Nu
    capacity: 1.8
    $ soya -t json -e service_history.0 car.yaml
    {
      "datetime": "2014-07-10T03:12:51Z",
      "cost": 0.0,
      "odometer": 2952
    }
    $ soya -t json -e service_history.1.cost car.yaml
    199.95

### Insertion
You can also I can move the output under a specific key.

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

TODO: It's something which I can easily add, though I don't see any use-cases for it.

### Burger-with-the-lot

The above techniques interoperate pretty well. The only major piece of information is the order of evaluation:

1. Files are loaded in the order provided and merged.
1. Then expression definitions are created.
1. Then copying occurs.
1. Followed by extraction
1. With insertion occurring last.

Let me move from the world of cars onto a fictional example of configuring MailPile (see: <https://www.mailpile.is/>) for 
deployment using a fictional tool called shipper when using Jenkins (see: <https://www.jenkins-ci.org/>) into a datacentre. See 
sample files under the "`doc`" directory Yes, this example is just a tad contrived and is therefore unnecessarily complicated. 
Tough, you wanted the Burger-with-the-Lot, that means you get the unholy combination of beetroot, pineapples, pickles and eggs -- 
bon appétit.

    $ BUILD_NUMBER=123
    $ env=production
    $ epoch=1
    $ soya -c "datacentre.default=datacentre.${env}" "all_datacentre_config.yaml" > "all_datacentre_config_with_default.yaml"
    $ soya -e "datacentre.default" -i datacentre "all_datacentre_config_with_default.yaml" > "${env}.yaml"
    $ soya -i "application.mailpile.environment" "mailpile_config_${env}.yaml" > mailpile_config.yaml
    $ soya -s "${env}.yaml" mailpile.yaml mailpile_config.yaml > shipper.yaml
    $ soya -f yaml -t json -Dapplication.mailpile.version="'${epoch}.${BUILD_NUMBER}'" shipper.yaml > shipper.json
    $ shipper -c shipper.json deploy

This tool was written with configuration management in mind. It aims to encourage the Unix-like pipe-processing of configuration 
files. I've tried to refrain (except in the Burger-with-the-Lot example) from providing any best-practice on how this should be 
done. That is, I've provided the mechanism without dictating (or even favouring) any policy (see:
<https://en.wikipedia.org/wiki/Separation_of_mechanism_and_policy>).

## History and Philosophy

I initially wanted to write a program that converted between YAML and JSON. That was due to my desire to use YAML as my 
AWS-CloudFormation template language (due to YAML's support of comments), but I still wanted to be able to easily use JSON
templates from online discussions.

Over time, the problem space expanded. I should possibly split this into multiple programs, that's the Unix-way after all. But 
managing half-a-dozen scripts seems like it'd be a pain-in-the-posterior. And the various functionality seems to complement each 
other pretty well.

The background of the copying functionality was my desire to take advantage of anchors/references within the YAML specification. 
But given the lack of JSON support, I made it a copy action instead. This is a pattern in this program. While it supports both 
JSON and YAML, it fundamentally caters to the lowest-common-denominator (which is JSON) when deciding what's valid/invalid (eg 
data-types). It's undoubtedly a sign that I should have one program that translates between JSON/YAML and a different one which 
does everything else (with YAML only). But this current program solves my problem pretty well right now, though I take bribes of
chocolate.

## Improvements and TODO

Before hitting version 1.0, I'd like feedback on the names of the options. Naming things well is an extraordinarily difficult 
problem. But since the option names is the program's interface, I prefer to get it right sooner rather than later.

The documentation should also be improved. And I need to write some unit tests covering the many corner-case improvements I've 
managed to slip in. But neither of these two are as urgent.

I suspect that there are bugs in more obscure uses of this program. I know that defining expressions with an array/hash inside 
an another array doesn't work. That said, I doubt there's a practical use of even defining one-dimensional arrays (from the 
command-line). I only added it because it was easy and cool.

Overall, I suspect I've covered 99% of the common use cases. And in the spirit of "Worse-is-Better" (see: 
<https://www.dreamsongs.com/RiseOfWorseIsBetter.html>), I think I can leave those corner cases unresolved for now.

