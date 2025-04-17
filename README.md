# UART Communication Protocol for FPGA (VHDL)  

This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication protocol for an FPGA using VHDL in the Vivado design environment.  It provides a flexible and configurable UART module suitable for a variety of applications requiring serial communication.  

## Overview  

This project includes the following components:  

*   **UART Transmitter (uart_tx.vhd):**  Serializes data into a format suitable for transmission over a UART channel.  
*   **UART Receiver (uart_rx.vhd):**  Receives serial data from a UART channel and converts it into parallel data.  
*   **Top-Level Module (uart_top.vhd or similar):**  Instantiates and connects the transmitter and receiver modules, providing a high-level interface for data transfer.  
*   **Testbench (uart_tb.vhd):**  A comprehensive testbench for verifying the functionality of the UART module.  
*   **Constraints File (.xdc):** Specifies pin assignments and timing constraints for the target FPGA device.  
*   **Documentation (this README.md):**  Provides an overview of the project, instructions for usage, and details about the design.  

## Features  

*   **Configurable Baud Rate:** The baud rate can be easily adjusted by modifying a generic parameter.  
*   **Configurable Data Width:** Supports different data widths (e.g., 8 bits, 7 bits) via generic parameters.  
*   **Standard Start, Stop, and Data Bits:**  Implements the standard UART protocol with one start bit, one or two stop bits, and configurable data bits. (Parity options can be added in future)  
*   **Clear Signals:** Clear signals for transmit and receive for error handling.  
*   **VHDL Implementation:**  Implemented using VHDL for portability and maintainability.  
*   **Vivado Compatibility:**  Designed and tested within the Vivado design environment.  
*   **Comprehensive Testbench:** Includes a testbench for thorough verification of the UART module's functionality.  

## Files  

*   `uart_tx.vhd`: VHDL code for the UART transmitter.  
*   `uart_rx.vhd`: VHDL code for the UART receiver.  
*   `uart_top.vhd`: (Or similar name) VHDL code for the top-level module integrating the transmitter and receiver.  
*   `uart_tb.vhd`: VHDL code for the testbench.  
*   `constraints.xdc`:  Xilinx Design Constraints file for pin assignments and timing.  
*   `README.md`:  This file.  

## Prerequisites  

*   **Vivado:**  Xilinx Vivado Design Suite installed (version 20XX.X or later recommended).  
*   **FPGA Development Board:** An FPGA development board compatible with Vivado.  The specific board will influence the pin assignments in the `constraints.xdc` file.  
*   **Serial Communication Tool:** A serial communication tool (e.g., PuTTY, Tera Term) for interacting with the FPGA.  

## Getting Started  

1.  **Clone or Download the Repository:** Obtain the project files from the repository (e.g., GitHub).  

2.  **Open the Project in Vivado:** Open the Vivado Design Suite and create a new project or open the existing project file (if provided).  

3.  **Add Files to the Project:** Add all the VHDL source files (`.vhd`), the constraints file (`.xdc`), and the testbench file (`.vhd`) to the project.  Ensure the hierarchy is correctly set.  

4.  **Modify Constraints File (constraints.xdc):**  Crucially, modify the `constraints.xdc` file to match the pin assignments on your FPGA development board.  This includes:  
    *   **UART TX Pin:** Assign the correct FPGA pin to the `uart_tx` signal.  
    *   **UART RX Pin:** Assign the correct FPGA pin to the `uart_rx` signal.  
    *   **Clock Pin:**  Assign the correct FPGA pin to the clock signal used in the design.  
    *   **Reset Pin (if applicable):** Assign the correct FPGA pin to the reset signal, if used.  
    *   **Important**: Ensure you understand the voltage levels and pin compatibility of your board before assigning the pins.  Incorrect pin assignments can damage your FPGA.  

5.  **Simulation:**  
    *   Run the simulation to verify the functionality of the UART module.  
    *   Analyze the waveforms to ensure data is being transmitted and received correctly.  
    *   Modify the testbench (`uart_tb.vhd`) to add more test cases and thoroughly validate the design.  

6.  **Synthesis and Implementation:**  
    *   Synthesize the design to generate a netlist.  
    *   Implement the design to place and route the logic onto the FPGA.  

7.  **Generate Bitstream:** Generate the bitstream file that will be programmed onto the FPGA.  

8.  **Program the FPGA:** Program the bitstream onto your FPGA development board.  

9.  **Establish Serial Communication:**  
    *   Connect your FPGA board to your computer using a serial communication cable (e.g., USB-to-UART adapter).  
    *   Open your serial communication tool (PuTTY, Tera Term, etc.).  
    *   Configure the serial communication settings (baud rate, data bits, parity, stop bits) to match the configuration of your UART module (specified via generics).  The default is often 115200 baud, 8 data bits, no parity, 1 stop bit (115200-8-N-1).  
    *   Send and receive data to test the UART communication.  

## Design Details  

*   **Baud Rate Generation:** The UART transmitter and receiver modules typically use a clock divider to generate the required baud rate clock from the FPGA's system clock. The frequency divider value is usually determined by a generic parameter.  

*   **Data Framing:** The UART protocol uses start, data, and stop bits to frame the serial data. The transmitter inserts these bits, and the receiver detects and removes them.  

*   **Synchronization:** The receiver synchronizes to the incoming serial data stream using the start bit.  Oversampling techniques may be used to improve the accuracy of the receiver.  

## Generics (Configuration)  

The following generics may be available in the UART transmitter and receiver modules:  

*   `CLK_FREQ`: System clock frequency in Hz.  (e.g., `CLK_FREQ => 100000000` for 100 MHz).  
*   `BAUD_RATE`: Desired baud rate (e.g., `BAUD_RATE => 115200`).  
*   `DATA_WIDTH`: Number of data bits (e.g., `DATA_WIDTH => 8`).  
*   `STOP_BITS`: Number of stop bits (e.g., `STOP_BITS => 1` or `STOP_BITS => 2`).  (Often, `STOP_BITS => 1` is used)  
*   `OVERSAMPLE`: Oversampling factor for the receiver (e.g., `OVERSAMPLE => 16`). This determines how many times the incoming signal is sampled per bit period.  Higher values improve noise immunity but require a faster clock.  

**Important:**  Ensure the clock frequency, baud rate, data width, and stop bit settings in your VHDL code and your serial communication tool match exactly. Mismatches will result in communication errors.  

## Testbench Details  

The testbench (`uart_tb.vhd`) typically includes the following:  

*   **Clock Generation:** Generates a clock signal for the UART module.  
*   **Reset Signal (if applicable):**  Asserts a reset signal to initialize the UART module.  
*   **Stimulus Generation:** Generates test data to be transmitted through the UART transmitter.  
*   **Response Verification:**  Checks the data received by the UART receiver against the expected data.  
*   **Error Reporting:** Reports any errors detected during the simulation.  

## Future Enhancements  

*   **Parity Bit Support:** Add support for parity bits (even, odd, mark, space) to improve error detection.  
*   **FIFO Buffers:**  Implement FIFO (First-In, First-Out) buffers in the transmitter and receiver to handle data buffering.  
*   **Flow Control:** Implement flow control mechanisms (e.g., RTS/CTS, XON/XOFF) to prevent data overflow.  
*   **DMA Interface:** Add a DMA (Direct Memory Access) interface for high-speed data transfer.  
*   **Interrupt Generation:** Implement interrupt generation for specific events (e.g., data received, transmit buffer empty).  

## Troubleshooting  

*   **No Data Received:**  
    *   Verify the pin assignments in the `constraints.xdc` file.  
    *   Check the clock frequency and baud rate settings.  
    *   Ensure the serial communication tool is configured correctly.  
    *   Verify the voltage levels on the UART TX and RX lines.  

*   **Data Corruption:**  
    *   Check the data width and stop bit settings.  
    *   Verify the clock signal is stable and has the correct frequency.  
    *   Increase the oversampling factor (if applicable).  

*   **Simulation Errors:**  
    *   Review the VHDL code for syntax errors or logical errors.  
    *   Examine the simulation waveforms to identify the source of the error.  

## License  

This project is licensed under the MIT License. See the `LICENSE` file for details.  

## Contributing  

Contributions are welcome! Please feel free to submit pull requests or open issues for bug fixes, new features, or improvements.  

## Author  

Edgar Nyandoro, Engineer  

## Contact
[edgarchebe@gmail.com](mailto:edgarchebe@gmail.com)


  
