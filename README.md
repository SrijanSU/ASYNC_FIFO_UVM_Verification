# ASYNC_FIFO_UVM_Verification

# 🧠 Asynchronous FIFO Verification using UVM

## 📘 Project Overview
This project implements and verifies a **dual-clock Asynchronous FIFO** using **SystemVerilog and UVM (Universal Verification Methodology)**.  
The FIFO supports independent read and write clock domains and ensures reliable data transfer through proper synchronization logic.

---

## ⚙️ Design Features
- **Dual Clock Domains:** Separate `wclk` and `rclk` for write and read operations.  
- **Metastability Protection:** Two flip-flop synchronizers for pointer crossings.  
- **Full/Empty Detection:**  
  - `wfull` asserted when FIFO is full (based on Gray-coded pointer comparison).  
  - `rempty` asserted when FIFO is empty.  
- **Parameterized Depth and Data Width:** Configurable via `ASIZE` and `DSIZE`.

---

## 🧩 RTL Modules
| Module | Description |
|---------|-------------|
| `FIFO` | Top-level FIFO wrapper connecting all submodules |
| `FIFO_memory` | Memory array with synchronous write logic |
| `wptr_full` | Write pointer logic and full flag generation |
| `rptr_empty` | Read pointer logic and empty flag generation |
| `two_ff_sync` | Two flip-flop synchronizer for safe pointer transfer |

---

## 🧪 Verification Environment (UVM)
| Component | Description |
|------------|-------------|
| `async_fifo_env` | UVM environment containing agents, scoreboard, and virtual sequencer |
| `async_fifo_write_agent` / `async_fifo_read_agent` | Generate and monitor transactions on write and read interfaces |
| `async_fifo_driver` | Drives FIFO interface signals from sequence items |
| `async_fifo_monitor` | Observes DUT interface and sends transactions to scoreboard |
| `async_fifo_scoreboard` | Compares DUT behavior with expected model (reference FIFO) |
| `async_fifo_virtual_sequence` | Controls read/write stimulus coordination across agents |
| `async_fifo_test` | Top-level test that configures and runs the environment |

---

## 🔍 Scoreboard Logic
- Maintains a **reference FIFO model** (`exp_fifo`) for data tracking.  
- Compares:
  - DUT vs. Reference data (`rdata`)  
  - DUT vs. Reference flags (`wfull`, `rempty`)  
- Reports:
  - ✅ **Match**
  - ❌ **Mismatch (UVM_ERROR)**

---

## 🧰 Key Concepts Demonstrated
- Asynchronous domain synchronization  
- Gray-coded pointer arithmetic  
- Clock-domain crossing verification  
- UVM component hierarchy and factory registration  
- Transaction-level modeling (TLM) with analysis FIFOs  

---

## 🧾 Simulation Flow
1. **Compile** the RTL and UVM environment  
2. **Run** simulation using any supported simulator (e.g., QuestaSim, VCS)  
3. **Observe Logs:**  
   - Data transfer across clock domains  
   - `wfull` and `rempty` behavior  
   - Scoreboard comparison results  

---

