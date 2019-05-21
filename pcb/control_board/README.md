# FPGA Multi-Effect Guitar Pedal
Carson Robles

## Control Board
The main function of this board is to hold all components of the project including: the FPGA board, the data converter module, control knobs, foot switches, and enable LEDs.

### Status
In fabrication.

## Board Images
### Power System Schematic
![Alt text](img/sch_power.png?raw=true "Power System")
Schematic of the power supply that the system runs on. The board accepts 12V in through the onboard barrel jack and produces a regulated 5V supply to power the entire system.

### Effect Enables and Settings Schematic
![Alt text](img/sch_effect_enable_pots.png?raw=true "Effect Settings and Enables")
Schematic of the effect enables and settings potentiometers. These include the 5 foot switches used to enable and disable individual effects. Each effect also includes 2 potentiometer knobs that allow the user to modify each effect to their liking.

### FPGA Board Connections and Analog Mux Schematic
![Alt text](img/sch_cmod_analog_mux.png?raw=true "FPGA Board and Analog Mux")
The FPGA is mounted onto the control board via 2 24 pin headers. The analog mux allows only one potentiometer voltage to pass at a time that the FPGA can read using its onboard ADC. The FPGA cycles through which potentiometer value it reads and updates its saved values when a new value is read. The output of the analog mux is filtered and divided down to the range that the onboard ADC can handle, 3.3V.

### Data Converter Module Connections
![Alt text](img/sch_data_converters.png?raw=true "Data Converter Module")
The data converter module is also mounted to the control board via a Digilent PMOD header (2x6 pin header). This header is routed to I/O pins on the FPGA.
