# Sequence Detector (Mealy FSM) — Pattern `1101`

This project implements a **Mealy finite state machine (FSM)** in Verilog to detect the serial bit pattern `1101` on a single-bit input stream (`din`).  
The FSM supports overlaps (e.g., the stream `1101101` produces **two detections**). The output `y` generates a **one-cycle pulse** when the last `1` of the pattern arrives.

---

## Files
- `seq_detect_mealy.v` — FSM design (synchronous active-high reset)
- `tb_seq_detect_mealy.v` — testbench (drives multiple bitstreams, includes reset case)
- `dump.vcd` — waveform file generated during simulation

---

## FSM Details

### States
- **init** → no valid prefix
- **got_1** → saw `1`
- **got_11** → saw `11`
- **got_110** → saw `110`

### Transitions
- `init`:  
  - `din=1 → got_1`  
  - `din=0 → init`  
- `got_1`:  
  - `din=1 → got_11`  
  - `din=0 → init`  
- `got_11`:  
  - `din=1 → got_11` (suffix `11`)  
  - `din=0 → got_110`  
- `got_110`:  
  - `din=1 → output pulse, next state = got_1` (overlap handled)  
  - `din=0 → init`  

### Output
- `y = 1` when `(state_present == got_110 && din == 1)`
- This means the pulse occurs **exactly on the final `1` of `1101`**

### Reset
- **Synchronous, active-high**  
- On next rising clock edge with `rst=1`, FSM returns to `init`

---

## How to Compile, Run, and Visualize

### 1. Compile with Icarus Verilog
```bash
iverilog -o seq_detect_mealy_tb tb_seq_detect_mealy.v seq_detect_mealy.v
```

### 2. Run the simulation
```bash
vvp seq_detect_mealy_tb
```
- This generates `dump.vcd` for waveform analysis.

### 3. Visualize with GTKWave
```bash
gtkwave dump.vcd
```
- Open signals: `clk`, `rst`, `din`, `y`  
- Zoom into regions where `din` matches `1101`  
- `y` should pulse exactly on the last `1`

---

## Test Streams and Expected Outputs

### Stream Tested: `11011011101`
- Expected detection indices (0-based, last `1` of `1101`): **3, 6, 10**
- Output `y` pulses at these cycles

### Reset Test
- FSM reset mid-stream returns state to **init** on the next clock
- Pattern detection resumes correctly after reset
