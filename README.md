# UART (Universal Asynchronous Receiver Transmitter) using Verilog HDL

## 📌 Overview

This project implements a basic UART (Universal Asynchronous Receiver Transmitter) protocol using Verilog HDL. The design includes a UART Transmitter, UART Receiver, Baud Rate Generator, Top Module integration, and a SystemVerilog testbench for simulation and verification.

---

## 🚀 Features

- UART Transmitter (TX)
- UART Receiver (RX)
- Baud Rate Generator
- UART Top Module
- Loopback Communication
- FSM-Based Design
- 8-bit Data Transmission
- Start Bit & Stop Bit
- SystemVerilog Testbench
- EPWave Simulation

---

## 📂 Project Structure

```
UART-Protocol-Verilog/
│── baud_gen.sv
│── uart_tx.sv
│── uart_rx.sv
│── uart_top.sv
│── uart_tb.sv
│── README.md
```

---

## 🏗️ Block Diagram

```
        +-----------+
        | Baud Gen  |
        +-----+-----+
              |
              |
      +-------v-------+
      |    UART TX    |
      +-------+-------+
              |
        Serial Line
              |
      +-------v-------+
      |    UART RX    |
      +-------+-------+
              |
          Parallel Data
```

---

## ⚙️ Modules

### 1. Baud Rate Generator
Generates the baud tick required for UART communication.

### 2. UART Transmitter
Converts 8-bit parallel data into serial data using a Finite State Machine (FSM).

### 3. UART Receiver
Receives serial data and reconstructs the original 8-bit parallel data.

### 4. UART Top Module
Integrates the UART TX and UART RX using an internal loopback connection.

### 5. Testbench
Verifies UART functionality using simulation and waveform analysis.

---

## 🛠️ Tools Used

- Verilog HDL
- SystemVerilog
- EDA Playground
- EPWave

---

## 📖 Concepts Used

- Finite State Machines (FSM)
- Shift Registers
- Counters
- Serial Communication
- RTL Design
- Digital Logic Design

---

## 🔮 Future Enhancements

- 16x Oversampling
- Parity Bit Support
- Configurable Stop Bits
- FIFO Integration
- Error Detection

---

## 👩‍💻 Author

**Shafiya Siddiqua R**
