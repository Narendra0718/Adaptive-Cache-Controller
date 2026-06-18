
# Adaptive Cache Controller with Workload-Aware Cache Management

Adaptive 4-Way Set Associative Cache Controller implemented in **Verilog HDL** that dynamically switches between **FIFO** and **LRU** cache replacement policies based on the detected memory access pattern. The design was functionally verified using **Xilinx Vivado** and evaluated through FPGA synthesis, timing, power, and resource utilization analysis.

---

# Project Overview

Modern processors suffer from the **Memory Wall Problem**, where CPU performance grows much faster than memory speed. Cache memories reduce this latency, but a fixed replacement policy cannot efficiently handle every workload.

This project proposes an **Adaptive Cache Controller** capable of monitoring recent memory accesses and dynamically selecting the most suitable replacement policy.

Instead of always using FIFO or LRU, the controller analyzes memory behavior and switches automatically to improve cache performance.

---

# Motivation

Different applications exhibit different memory access patterns.

Examples include

- Multimedia streaming
- Database systems
- Embedded processors
- Machine Learning applications

A fixed replacement policy cannot provide the best performance for every workload.

This project solves this limitation by dynamically selecting the replacement algorithm according to workload characteristics.

---

# Features

- 4-Way Set Associative Cache
- FIFO Replacement Policy
- LRU Replacement Policy
- Dynamic Workload Detection
- Adaptive Policy Selection
- Hit/Miss Detection
- Cache Statistics Module
- Functional Verification
- FPGA Synthesis
- Timing Analysis
- Power Analysis

---

# Architecture Overview

The top-level architecture consists of four major modules.

- Main Memory
- Adaptive Selector
- Cache Controller
- Cache Statistics

The adaptive selector analyzes the workload and generates a mode signal that controls whether FIFO or LRU replacement is used.

---

# RTL Architecture

![Architecture](images/architecture_cache.png)

---

# RTL Modules

## Main Memory

- 256-byte memory model
- Provides data on cache miss
- Supplies requested data to cache controller

---

## Adaptive Selector

The adaptive selector monitors the recent address history.

It classifies accesses into:

- Streaming Accesses
- Repeated Accesses

Decision Logic

- Repeat Count > Stream Count → LRU
- Stream Count > Repeat Count → FIFO

---

## Cache Controller

Implements

- 4-way set associative cache
- Valid bits
- Tag memory
- Data memory
- Hit detection
- Miss handling
- Adaptive replacement

---

## FIFO Controller

- Circular replacement pointer
- Replaces oldest cache block
- Suitable for streaming workloads

---

## LRU Controller

- Maintains age information
- Replaces least recently used block
- Suitable for repeated accesses

---

## Cache Statistics

Maintains

- Hit Counter
- Miss Counter
- Total Access Counter

Used to calculate cache performance.

---

# Project Flow

1. CPU sends address
2. Cache checks all four ways
3. Hit → Data returned immediately
4. Miss → Main memory accessed
5. Adaptive selector determines workload
6. FIFO or LRU replacement executed
7. Cache statistics updated

---

# Functional Verification

RTL simulation was performed using **Xilinx Vivado Simulator**.

Three different workloads were tested.

---

# 1. Repetitive Workload

### Address Pattern

```
20 → 24 → 20 → 24 → 20 → 24 → 36 → 20
```

### RTL Waveform

![Repeated Waveform](images/repetitive_wl_waves.png)

### Console Output

![Repeated Console](images/repetitive_wl_cons.png)

### Results

| Parameter | Value |
|-----------|------:|
| Hits | 13 |
| Misses | 3 |
| Total Accesses | 16 |
| Hit Rate | 81.25% |

### Observation

Repeated accesses dominate.

The adaptive selector remains in **LRU mode**, producing the highest hit rate.

---

# 2. Streaming Workload

### Address Pattern

```
4 → 8 → 12 → 16 → 20 → 24 → 28 → 32
```

### RTL Waveform

![Streaming Waveform](images/stream_wl_wave.png)

### Console Output

![Streaming Console](images/stream_wl_cons.png)

### Results

| Parameter | Value |
|-----------|------:|
| Hits | 8 |
| Misses | 8 |
| Total Accesses | 16 |
| Hit Rate | 50% |

### Observation

Sequential accesses dominate.

The adaptive selector switches to **FIFO mode**.

---

# 3. Mixed Workload

### Address Pattern

```
20 → 24 → 28 → 20 → 24 → 32 → 36 → 20
```

### RTL Waveform

![Mixed Waveform](images/mixed_wl_waves.png)

### Console Output

![Mixed Console](images/mixed_wl_cons.png)

### Results

| Parameter | Value |
|-----------|------:|
| Hits | 10 |
| Misses | 6 |
| Total Accesses | 16 |
| Hit Rate | 62.5% |

### Observation

The workload contains both repeated and sequential accesses.

The adaptive selector dynamically balances FIFO and LRU replacement policies.

---

# FPGA Synthesis

Target Tool

- Xilinx Vivado

Clock Constraint

- 10 ns (100 MHz)

---

# Resource Utilization

![Utilization](images/utilization_report.png)

| Resource | Used | Utilization |
|-----------|-----:|------------:|
| LUT | 232 | 0.44% |
| FF | 424 | 0.40% |
| BRAM | 0.5 | 0.36% |
| BUFG | 1 | 3.13% |

---

# Timing Analysis

![Timing](images/timing_report.png)

| Parameter | Value |
|-----------|--------|
| WNS | 3.433 ns |
| TNS | 0 ns |
| WHS | 0.185 ns |
| Failing Endpoints | 0 |

All timing constraints are successfully met.

---

# Power Analysis

![Power](images/power_report.png)

| Parameter | Value |
|-----------|--------|
| Total On-Chip Power | 0.129 W |
| Dynamic Power | 0.024 W |
| Static Power | 0.105 W |
| Junction Temperature | 26.5 °C |

The design demonstrates low FPGA resource utilization and low power consumption.

---

# Performance Summary

| Workload | Hits | Misses | Hit Rate |
|-----------|------:|--------:|----------:|
| Repetitive | 13 | 3 | 81.25% |
| Mixed | 10 | 6 | 62.5% |
| Streaming | 8 | 8 | 50% |

---

# Tools Used

| Tool | Purpose |
|------|---------|
| Verilog HDL | RTL Design |
| Xilinx Vivado | Simulation & FPGA Implementation |
| Vivado Simulator | Functional Verification |
| Vivado Synthesis | Resource Analysis |

---

# Documentation

The complete internship report describing the architecture, implementation, simulation, synthesis, and analysis is available in the **docs** folder.

```
docs/
└── Adaptive_Cache_Controller_Report.pdf
```

---

# Future Improvements

- Write-back cache support
- Dirty-bit implementation
- Hardware prefetching
- Larger cache organization
- Integration with RISC-V Processor
- Machine Learning based replacement prediction

---

# References

- Computer Organization and Design – Patterson & Hennessy
- Computer Architecture: A Quantitative Approach
- Xilinx Vivado Design Suite User Guide
- Verilog HDL – Samir Palnitkar

---


# ~NARENDRA
Department of ECE-VLSI  
Indian Institute of Information Technology Senapati Manipur
