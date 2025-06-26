# Lab: External Signal Synchronization

## Overview

This project demonstrates proper external signal synchronization techniques for FPGA designs, focusing on clock domain crossing (CDC) and debouncing of external inputs. The lab showcases best practices for handling asynchronous external signals in FPGA applications.

The target board is an ARTY-Z7-20 board, mounting a Zynq-7000 Z7-20 SoC.

## Project Description

The lab implements a button input system with proper synchronization and debouncing:
- **Input**: External button (BTN0) connected to the FPGA
- **Output**: LED (LD0) that illuminates when the button is properly debounced
- **Clock**: 125MHz system clock converted to 100MHz internal clock
- **Features**: CDC synchronization, debouncing, and proper reset handling

## Key Learning Objectives

1. **Clock Domain Crossing (CDC)**: Proper synchronization of external signals
2. **Debouncing**: Filtering mechanical switch bounce using shift registers
3. **Clock Management**: MMCM-based clock generation and distribution
4. **Reset Synchronization**: Proper reset handling across clock domains

## Project Structure

```
lab-ext-sig-sync/
├── hdl/                                    # Hardware Description Language files
│   ├── fpga_top.sv                        # Main FPGA top-level module
│   └── clk_rst_subsys.sv                  # Clock and reset subsystem
├── hvl/                                    # Hardware Verification Language files
│   └── fpga_top_tb.sv                     # Testbench for simulation
├── xdc/                                    # Xilinx Design Constraints
│   └── constr.xdc                         # Pin assignments and timing constraints
├── tcl/                                    # TCL scripts
│   └── proj.tcl                           # Vivado project creation script
├── SVLib/                                  # SystemVerilog library (git submodule)
│   ├── src/
│   │   ├── cdc/                           # Clock domain crossing modules
│   │   └── registers_regfiles/            # Register and register file modules
│   └── README.md
└── lab-external-signal-synchronization.2023.2/  # Vivado project files
```

## Design Components

### 1. FPGA Top Module (`hdl/fpga_top.sv`)
- **Purpose**: Main design entry point
- **Features**:
  - CDC synchronization for button input
  - 100-stage debouncing shift register
  - LED output control
  - Proper clock and reset integration

### 2. Clock and Reset Subsystem (`hdl/clk_rst_subsys.sv`)
- **Purpose**: Clock generation and reset management
- **Features**:
  - MMCME2_BASE for 125MHz → 100MHz clock conversion
  - Synchronized reset generation
  - CDC synchronization for MMCM lock signal

### 3. SVLib Components
- **CDC Synchronizer** (`SVLib/src/cdc/cdc_sync.sv`):
  - Configurable multi-stage synchronizer
  - ASYNC_REG attributes for proper synthesis
  - Configurable width and depth
- **Register Module** (`SVLib/src/registers_regfiles/register_sync_rstn.sv`):
  - Synchronous reset register with configurable width
  - Used for debouncing shift register implementation

## Technical Details

### Clock Domain Crossing
- **Input Clock**: 125MHz (external)
- **Internal Clock**: 100MHz (generated via MMCM)
- **CDC Stages**: 3-stage synchronizer for button input
- **MTBF**: Enhanced reliability with 3-stage synchronization

### Debouncing Implementation
- **Method**: Shift register-based debouncing
- **Stages**: 100 flip-flops in series
- **Logic**: LED activates when all 100 stages are high (AND reduction)
- **Purpose**: Filters mechanical switch bounce

### Pin Assignments
- **SYS_CLK**: H16 (125MHz system clock)
- **BTN0**: D19 (button input)
- **LD0**: R14 (LED output)

## Prerequisites

- **Vivado**: 2023.2 or compatible version
- **FPGA Board**: Xilinx Zynq-7000 (xc7z020clg400-1)
- **SystemVerilog**: Support for SystemVerilog synthesis

## Setup and Build Instructions

### 1. Environment Setup
```bash
git clone <this-repo>
cd <this-repo>
export REPO_TOP_DIR=$(pwd)
```

### 2. Initialize SVLib Submodule
```bash
git submodule update --init --recursive
```

### 3. Create Vivado Project
```bash
vivado -mode batch -source tcl/proj.tcl -notrace
```

You can then open the Vivado Project in the `lab-external-signal-synchronization.202x.y` folder and wait for implementation to complete to explore the design and then generate the bitstream.

### 4. Build and Implement
The TCL script automatically:
- Creates the Vivado project
- Adds all source files
- Sets up constraints
- Launches implementation

### 5. Simulation (Optional)
```bash
# In Vivado TCL console
launch_simulation
run -all
```

## Simulation

The testbench (`hvl/fpga_top_tb.sv`) provides basic verification:
- Generates 125MHz clock
- Simulates button press after 100 clock cycles
- Allows observation of synchronization and debouncing behavior

## Design Verification

### CDC Verification
- **Tool**: Vivado CDC analysis
- **Focus**: Button input synchronization
- **Expected**: No CDC violations with proper ASYNC_REG attributes

### Timing Analysis
- **Clock**: 100MHz internal clock
- **Constraints**: 8ns period for 125MHz input clock
- **Focus**: Setup/hold timing for debouncing registers

## Best Practices Demonstrated

1. **CDC Synchronization**: Multi-stage synchronizer with proper attributes
2. **Debouncing**: Shift register approach for reliable input filtering
3. **Clock Management**: MMCM-based clock generation with feedback
4. **Reset Handling**: Synchronized reset across clock domains
5. **Modular Design**: Reusable components from SVLib
6. **Constraints**: Proper pin assignments and timing constraints

## Troubleshooting

### Common Issues
1. **CDC Violations**: Ensure ASYNC_REG attributes are set
2. **Timing Failures**: Check clock constraints and MMCM settings
3. **Build Errors**: Verify SVLib submodule is properly initialized
4. **Simulation Issues**: Check testbench clock generation

### Debug Tips
- Use Vivado CDC analysis for synchronization verification
- Monitor MMCM lock signal for clock stability
- Verify debouncing behavior with simulation waveforms

## License

Copyright (c) 2025 Siliscale Consulting, LLC

Licensed under the Apache License, Version 2.0. See individual files for license details.

## Contact

For technical support or business inquiries:
- **Email**: info@siliscale.com
- **Website**: [Siliscale Consulting](https://siliscale.com)

## Version Information

- **Project Version**: 2025.1
- **Vivado Version**: 2023.2
- **Target Device**: xc7z020clg400-1
- **Language**: SystemVerilog
