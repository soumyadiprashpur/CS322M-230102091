# Vending Machine FSM (Mealy, with Change)

##  Problem Description
We implement a **Mealy FSM vending machine**:

- Item **price = 20**.  
- Accepts coins:
  - `01` = 5  
  - `10` = 10  
  - `00` = idle  
  - `11` = invalid (ignored)  
- When total ≥ 20:
  - `dispense = 1` for **1 clock cycle**.  
  - If total = 25 → also `chg5 = 1` for **1 clock cycle**.  
- After vending, the total resets to `0`.  
- Reset: **synchronous, active-high**.

---

##  Files in this project
- `vending_mealy.v` → FSM module  
- `tb_vending_mealy.v` → Testbench  
- `README.md` → this file  

---

##  Compilation & Simulation Steps

### 1. Compile with Icarus Verilog
```bash
iverilog -o vending_mealy_tb vending_mealy.v tb_vending_mealy.v
```

### 2. Run the simulation
```bash
vvp vending_mealy_tb
```

This will generate a waveform file `tb_vending_mealy.vcd`.

### 3. Visualize with GTKWave
```bash
gtkwave tb_vending_mealy.vcd
```

In GTKWave, add signals (`clk`, `rst`, `coin`, `dispense`, `chg5`, `state_present`) to the waveform viewer.

---

##  FSM Design

### States (encoded in `state_present`)
- `s0` → Total = 0  
- `s5` → Total = 5  
- `s10` → Total = 10  
- `s15` → Total = 15  

### Transitions
- From `s0`:
  - coin=01 → `s5`  
  - coin=10 → `s10`  
- From `s5`:
  - coin=01 → `s10`  
  - coin=10 → `s15`  
- From `s10`:
  - coin=01 → `s15`  
  - coin=10 → Vend (20) → `s0`, `dispense=1`  
- From `s15`:
  - coin=01 → Vend (20) → `s0`, `dispense=1`  
  - coin=10 → Vend (25) → `s0`, `dispense=1, chg5=1`

### Why Mealy?
Because **outputs depend on both state and current input** (e.g., dispense occurs immediately when the correct coin arrives, without waiting for another cycle).

---

##  Expected Waveform Behavior
- After reset:
  - Machine in `s0`.  
- Example sequence:  

| Time | Coin Input | State Transition | Outputs |
|------|------------|------------------|---------|
| 10ns | 01 (5)     | s0 → s5          | dispense=0, chg5=0 |
| 20ns | 10 (10)    | s5 → s15         | dispense=0, chg5=0 |
| 30ns | 10 (10)    | s15 → s0         | dispense=1, chg5=1 |
| 40ns | 00         | idle             | dispense=0, chg5=0 |

- `dispense` and `chg5` are **1-cycle pulses** only at vending events.

---

##  Testbench Features
The testbench applies:
- Reset pulse at start.  
- Multiple coin sequences:
  - 5 + 5 + 10 = 20 (dispense only)  
  - 10 + 10 + 5 = 25 (dispense + chg5)  
  - Idle cycles to show no false triggers.  
- Generates a `tb_vending_mealy.vcd` for GTKWave.  

---

 With this README, anyone can clone your project and simulate it directly.  
