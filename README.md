# UART Communication Protocol for FPGA (VHDL)

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication protocol for an FPGA using VHDL in the Vivado design environment. It provides a configurable UART module with both transmitter and receiver functionality.

## Overview

This project includes the following components:

* **BaudGenerator (BaudGenerator.vhd):** Generates the baud rate clock signals for both transmitter and receiver.
* **TransmitterUART (TransmitterUART.vhd):** Handles serialization and transmission of data.
* **ReceiverUART (ReceiverUART.vhd):** Receives and deserializes incoming serial data.
* **UART (UART.vhd):** Top-level module that integrates the baud generator, transmitter, and receiver.
* **Testbenches:**
  * UART_tb.vhd: Main testbench for the complete UART system
  * TransmitterUART_tb.vhd: Dedicated testbench for the transmitter
  * ReceiverUART_tb.vhd: Dedicated testbench for the receiver
  * BaudGeneratorTB.vhd: Dedicated testbench for the baud generator

## Features

* **Configurable Baud Rate:** Default 9600 baud, configurable via generics
* **System Clock:** Designed for 20MHz input clock
* **Data Format:** 8 data bits, 1 parity bit, 1 stop bit
* **Error Detection:** Parity checking for received data
* **Status Signals:** TX and RX status indicators
* **Independent Testing:** Separate testbenches for each module
* **Vivado Project:** Complete Vivado 2024.2 project structure

## Implementation

The design is implemented for the AMD/Xilinx KV260 SOM board (xck26-sfvc784-2LV-c). Key signals:

* Clock input (CLK)
* Reset input (RESET)
* Transmitter interface (TX_START, TX_DATA_IN[7:0], TX_STATUS, TX_OUT)
* Receiver interface (RX_IN, RX_STATUS, RX_DATA_OUT[7:0])

## Getting Started

1. Clone this repository
2. Open Vivado 2024.2
3. Open the project file: UART.xpr
4. Run simulation using provided testbenches
5. Synthesize and implement the design
6. Generate bitstream for KV260 board

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

Edgar Nyandoro, Engineer.
Contact: [edgarchebe@gmail.com](mailto:edgarchebe@gmail.com)
