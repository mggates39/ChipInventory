# Contributing to Chip Inventory

You can contribute to Chip Inventory by updating/enhancing existing data, or by adding new parts definitions. Parts are specified using [YAML](http://yaml.org).

## File naming

One YAML file should represent one part, or a family of parts that all share a common pinout and roughly similar specifications. By convention, file names contain *only* uppercase letters, numbers, and hyphens `-`. If the properly-formatted part name contains lowercase letters or other characters (examples: ATmega328P, uPD7720), it can be specified with a `name` property (see below).

File contents should consist of 7-bit ASCII characters only. All special characters should be escaped with HTML entities.

## Definition syntax
At the root of the file should be a dictionary with the following fields:

#### `type`

Required. This identifed the type of component being descirbed in this file.  It can be one of the following values:
- `IC` - Integrated Circuit
- `Cap` - Capacitor
- `CN` - Capacitor Network
- `Diode` - Diode
- `Res` - Resistor
- `RN` - Resistor Network
- `Transisstor` - Transistor
- `Inductor` - Inductor
- `Xtal` - Crystal
- `Jack` - Connector Jack
- `Plug` - Connector Plug
- `XFMR` - Transformer
- `Fuse` - Fuse
- `Wire` - Wire
- `Switch` - Switch
- `Socket` - Socket

#### `subtype`
Optional.  The sub-type is used to distenguish between major features or attributes of a given type and as such are type dependent:
- Capacitor
  - `Ceramic` - Ceramic Capacitor
  - `Electrolytic` - Polarized Electrolytic Capacitor
  - `Film` - Film Capacitor
  - `Polymer` - Polymer Capacitor
  - `Super Cap` - Polarized Super Capacitor
  - `Tantalum` - Polarized Tantalum Capacitor
  - `Trimmer` - Trimmer Capacitor
  - `Variable` - Variable Capacitor
- Capacitor Network
  - `Ceramic` - Ceramic Capacitor
  - `Film` - Thick Film Capacitor
  - `Poly` - Polypropylene Capacitor
- Diode
  - `General` - General
  - `LED` - Light Emitting Diode
  - `Schotkey` - Schotkey
  - `Zener` - Zener
- Fuse
  - `Fast Blow` - Fast Blow
  - `Medium Blow` - Medium Blow
  - `Slow Blow` - Slow Blow
- Integrated Circuit
  - `4000` - 4000 series of chips
  - `5400` - 5400 series of chips
  - `7400` - 7400 series of chips
  - `Analog` - Analog Support chips
  - `Atmel` - Atmel AVR MCU
  - `Audio` - Audio chips
  - `Driver` - Signal or bus driver chips
  - `I2C` - I2C Support chips
  - `LED Display` - LED Segmented Display
  - `Linear` - Linear chips
  - `MAX` - Maxim Communication Line Driver Chips
  - `Memory` - Memory chips
  - `MPU` - Micro Processor Unit chips
  - `Op Amp` - Operational Amplifiers
  - `Optical` - Optical Support Chips
  - `PIA` - Peripheral Interface Adapter chips 
  - `PIC` - PIC Micro-controller
  - `Power` - Power related chips
  - `Sensor` - Data Collection chips
  - `Timer` - Timer and related chips
  - `UART` - UART Support Chips
  - `Video` - Video related
- Connector Jack
  - `Gold` - Gold Leads
  - `Tin` - Tin Leads
- Connector Plug
  - `Gold` - Gold Leads
  - `Tin` - Tin Leads
- Resistor
  - `Carbon` - Carbon Composite Resistor
  - `Carbon Film` - Carbon Film Resistor
  - `Metal Film` - Metal Film Resistor
  - `Photo` - Photo Resistor
  - `Thermistor` - Thermistor
  - `Variable` - Variable Resistor
  - `Wire Wound` - Wire Wound Resistor
- Resistor Network
  - `Bussed` - Bussed Common
  - `Decade Resistor` - Decade Resistor
  - `Dual Terminator` - Dual-line termination
  - `Isolated` - Individual resistors
  - `R2R Ladder` - R–2R ladder D to A Conversion
  - `Voltage Divider` - Series with taps
- Socket
  - `Gold` - Gold Leads
  - `Tin` - Tin Leads
  - `TIn-Lead` - Tin-Lead Leads
- Switch
  - `Momentary` - Momentary
  - `Rotary` - Rotary
  - `Slide` - Slide
  - `Toggle` - Toggle
- Transistor
  - `BJT` - Bipolar Junction Transistor 
  - `FET` - Field Effect Transistor
  - `JFET` - Junction Field Effect Transistor
  - `MOSFET` - Metal-Oxide-Semiconductor Field-Effect Transistor
- Wire
  - `F/F` - Female to Female
  - `F/M` - Female to Male
  - `M/M` - Male to Male
  - `Solid` - Solid Core
  - `Stranded` - Stranded Core
- Crystal
  - `OCXO` - Oven-Controlled Crystal Oscillator
  - `TCXO` - Temperature-Compensated Crystal Oscillator
  - `VCTCXO` - Voltage-Controlled Temperature-Compensated Crystal Oscillator
  - `VCXO` - Voltage-Controlled Crystal Oscillator)


#### `name`

Optional. Use if the properly-formatted part name is different from the filename. For example, `ATMEGA168.yaml` defines `name: ATmega168` because filenames should only include uppercase letters.

#### `description`

Required. A one-line description of the part, such as: `"8-bit shift register with 3-state output register"`.

#### `package`

Required. This field indicates how the pin diagram of this part should be drawn. The allowed values used in this database depend on the component type:
- Capacitor
  - `Axial` - Leads on the ends
  - `Chassis` - Chassis mount
  - `Radial` - Leads on the edges
  - `SMD` - Surface Mount Device
- Capacitor Network
  - `SIP` - Single In-line Package
  - `SMD` - Surface Mount Device
  - `THD` - Through Hole Device
- Diode
  - `Axial` - Leads on the ends
  - `Radial` - Leads on the edges
  - `SMD` - Surface Mount Device
  - `SOD` - Small Outline Diode
  - `TO-XX` - Transistor Outline
- Fuse
  - `Axial` - Leads on the ends
  - `Clamp` - Fuse Clamp
  - `Radial` - Leads on the edges
  - `SMD` - Surface Mount Device
  - `THD` - Through Hole Device
- Integrated Circuit
  - `DIP` - Dual In-Line Package
  - `PGA` - Pin Grid Array
  - `PLCC` - Plastic Leaded Chip Carrier
  - `QFN` - Quad Flat No-Leads Package
  - `QFP` - Quad Flat Package
  - `QIP` - Quad in-line package
  - `SIP` - Single In-line Package
  - `SOIC` - Small Outline Integrated Circuit
  - `SOP` - Small Outline Package
- Inductor
  - `Axial` - Leads on the ends
  - `Radial` - Leads on the edges
  - `THD` - Through Hole Device
- Jack
  - `SIP` - Single In-line Package
  - `SMD` - Surface Mount Device
  - `THD` - Through Hole Device
- Plug
  - `SIP` - Single In-line Package
  - `SMD` - Surface Mount Device
  - `THD` - Through Hole Device
- Resistor
  - `Axial` - Leads on the ends
  - `Chassis` - Chassis mount
  - `MELF` - Metal Electrode Leadless Face
  - `Radial` - Leads on the edges
  - `SMD` - Surface Mount Device
  - `THD` - Through Hole Device
- Resistor Network
  - `DIP` - Dual In-Line Package
  - `SIP` - Single In-line Package
  - `SMD` - Surface Mount Device
  - `SOP` - Small Outline Package
  - `THD` - Through Hole Device
- Socket
  - `DIP` - Dual In-Line Package
  - `PLCC` - Plastic Leaded Chip Carrier
  - `SIP` - Single In-line Package
  - `SOIC` - Small Outline Integrated Circuit
- Switch
  - `THD` - Through Hole Device
- Transisstor
  - `SMD` - Surface Mount Device
  - `SOT` - Small Outline Transistor
  - `THD` - Through Hole Device
  - `TO-XX` - Transistor Outline
  - Wire
  - `Axial` - Leads on the ends
- Transformer
  - `THD` - Through Hole Device
- Crystal
  - `DIP` - Dual In-Line Package
  - `Radial` - Leads on the edges
  - `SMD` - Surface Mount Device
  - `THD` - Through Hole Device

#### `pincount`

Required. The total number of pins.

#### `family`

Optional. For integrated circuits only. If the part belongs to a large family, like the 7400 or 4000 series, it can be specified with this parameter. It is currently unused by Chip Inventory but could be used by other frontends to group parts by family. Currently defined families include `7400`, `4000`, `linear`, and `Atmel`.

#### `datasheet`

Required. The URL of an up-to-date version of the manufacturer&apos;s datasheet.

#### `aliases`

Optional. If similar parts share this pinout, you can specify an array of their names. For example, `ATMEGA168.yaml` defines `aliases: [ATmega48, ATmega88, ATmega328P]`. This *must* be an array, even if there is only one alias.

#### `pins`

Required. An array of pin definitions. The number of elements must match the indicated `pincount`. See the section "Pin definitions."

#### `specs`

Optional. An array of spec definitions. See the section "Spec definitions".

#### `notes`

Optional. An array of additional explanatory notes.

## Pin definitions

Each pin definition is a dictionary with three fields:

#### `num`

Required. The pin number. I suppose this is redundant, but it could theoretically be used to specify a non-numeric pin number. (lol)

#### `sym`

Required. The pin symbol. Typically all-uppercase. In the case of a single-supply part, the supply pin should be `Vcc` and the ground pin should be `GND`. Unused pins should be written as `NC` for "no connection." May contain spaces, and subscript/overbar characters. See "Subscripts and overbars."

#### `desc`

Required. Short description of the pin function. By convention, the first word is not capitalized. May contain subscript/overbar characters.


## Spec definitions

The `specs` array can be used to define a small table of basic specifications. Each definition is a dictionary with the following fields:

#### `param`

Required. Parameter name, such as `"Supply voltage"` or `"Slew rate"`.

#### `value`

Required. Parameter value. An array can be used to specify multiple values, like a minimum and maximum, e.g. `[8 (min), 36 (max)]`

#### `unit`

Optional. Parameter unit, like `V` or `mA`. Non-ASCII units should be written with HTML entities; e.g. `&Omega;` instead of &Omega;.


## Subscripts and overbars

Chip Inventory recognizes special syntax for overbars and subscripts in pin definitions, spec definitions, and notes.

#### Subscripts

If a sequence of non-whitespace characters is preceded by two underscores, it will be displayed as a subscript. Example: `D__0` becomes D<sub>0</sub>, `V__REF` becomes V<sub>REF</sub>.

#### Overbars

Tildes can be used to add overbars to characters. If a sequence of non-whitespace characters is preceded by a tilde, a line will be drawn above them. Example: `~OE` becomes <span style="text-decoration: overline;">OE</span>.

To add an overbar to a portion of a word, surround it with tildes. Example: `~RESET~/SYNC` becomes <span style="text-decoration: overline;">RESET</span>/SYNC, and `~CP~__0` becomes <span style="text-decoration: overline;">CP</span><sub>0</sub>

To include a literal tilde in the definition, use the HTML entity `&#126;`. If for some bizarre reason you want two or more literal underscores next to each other, use the HTML entity for underscore: `&#95;`.