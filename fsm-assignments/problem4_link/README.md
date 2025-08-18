# Master–Slave Handshake FSM Project

This project implements a **4-phase request/acknowledge handshake protocol** between a **Master FSM** and a **Slave FSM** using Verilog.  
The system is verified with a top-level module and a testbench.

---

##  Files

- `master_fsm.v` — Master finite state machine
- `slave_fsm.v` — Slave finite state machine
- `link_top.v` — Top-level wrapper connecting Master and Slave
- `tb_link_top.v` — Testbench for simulation

---

##  How to Compile and Run (Icarus Verilog + GTKWave)

1. **Compile all files**
```bash
iverilog -o simv tb_link_top.v link_top.v master_fsm.v slave_fsm.v
```

2. **Run simulation**

```bash
vvp simv
```

   This generates `handshake.vcd` and prints monitor output in the terminal.

3. **Open waveform in GTKWave**

```bash
gtkwave handshake.vcd
```

   Drag signals of interest (`clk`, `rst`, `req`, `ack`, `data`, `last_byte`, `done`) into the waveform viewer.

---

##  Expected Behavior

- Master sends **4 bytes** (`0xA0`, `0xA1`, `0xA2`, `0xA3`).
- For each byte:
  1. Master asserts `req` with `data`.
  2. Slave latches `data_in` into `last_byte`, asserts `ack` for 2 cycles.
  3. Master detects `ack`, drops `req`.
  4. Slave drops `ack` once `req` goes low.
- After 4 bytes, Master asserts `done` (1 cycle).
- Slave’s `last_byte` ends as `0xA3`.

---

##  State Diagrams

### Master FSM

States:

- **S_IDLE** → Drive first `req` with data.
- **S_WAIT_ACK** → Wait for `ack=1`.
- **S_WAIT_ACK0** → Wait for `ack=0`, increment byte counter.
- **S_DONE** → Pulse `done`, then return to `S_IDLE`.

### Slave FSM

States:

- **S_WAIT_REQ** → Wait for `req=1`.
- **S_HOLD_ACK** → Assert `ack` for 2 cycles.
- **S_DROP_ACK** → Drop `ack`, return when `req=0`.

---

##  Example Simulation Log

```
 Time | clk rst | req ack | data  last  | done
   25 |  1   0  |  1   0  |  a0   00  |  0
   35 |  1   0  |  1   1  |  a0   a0  |  0
   55 |  1   0  |  1   0  |  a1   a0  |  0
   65 |  1   0  |  1   1  |  a1   a1  |  0
   ...
  135 |  1   0  |  0   0  |  a3   a3  |  1   <-- done
```

---

##  Waveform

- `req` and `ack` form a 4-phase handshake per byte.
- `data` values appear sequentially (`A0`, `A1`, `A2`, `A3`).
- `last_byte` updates with each `data`.
- `done` pulses high after the 4th byte.

---
