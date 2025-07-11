---

````markdown
# Half-Center Oscillator (HCO) Model for Neuromorphic Pendulum Control

This repository contains a MATLAB implementation of a **2-neuron Half-Center Oscillator (HCO)** model used to generate torque signals for pendulum control. The system is based on the neural control structure described in:

> Schmetterling, Raphael, et al. **Neuromorphic control of a pendulum.** *IEEE Control Systems Letters* (2024).

---

## 🔬 Overview

The model simulates two reciprocally inhibiting neurons with adaptive dynamics and nonlinear synaptic interactions. The membrane potentials of the neurons evolve via a system of ODEs, and a **thresholded membrane potential** of one neuron is used to generate **torque pulses** to control a pendulum.

The simulation illustrates:
- Membrane voltage oscillations (`v₁`, `v₂`)
- Torque generation based on `v₁`
- Influence of synaptic and adaptation time constants on behavior

---

## 📁 Files

### `Single_HCO.m`
- Main script simulating the 2-neuron HCO
- Implements nonlinear ODE dynamics, time-varying inputs, and torque generation
- Saves output to `single_HCO.mat`
- Plots:
  - Neuron membrane potentials over time
  - Torque output vs. time

---

## ⚙️ Model Features

- **Neural Model**:  
  Two neurons with:
  - Self-excitation
  - Mutual inhibition
  - Ultra-slow adaptive feedback
  - Sigmoidal synaptic dynamics

- **Torque Generation**:  
  A thresholded function of `v₁` outputs a square-wave-like torque.

- **Time-Dependent Modulation**:  
  Excitatory gain `a₃` changes after 3 seconds to transition the network behavior.

- **Inputs**:  
  External input to Neuron 1 changes between 0.3s–0.6s.

---

## 📊 Output

- `v₁`, `v₂`: Membrane voltages  
- `torque`: Generated torque signal  
- `t`: Time vector  
- Output is saved to `single_HCO.mat`

---

## 📈 Example Plots

1. **Membrane Potentials**
   - Red: `v₁`, Blue: `v₂`
   - Dashed black: Output threshold
2. **Torque Output**
   - Step-like pattern based on `v₁ > -0.5`

---

## 🧪 Parameters (Selected)

| Parameter | Description | Value |
|----------|-------------|-------|
| `tau_s` | Synaptic time constant | `0.05` s |
| `tau_us` | Ultra-slow adaptation time constant | `2.5` s |
| `a1`, `a2`, `a4` | Self and mutual excitation/inhibition | Tunable |
| `input_fn1` | Time-varying input to Neuron 1 | -1.2 (0.3s–0.6s) |
| `input_fn2` | Constant input to Neuron 2 | -1.0 |

To test variations, you can change `rate_idx` to select a different value of `a₄` (from a predefined list).

---

## ▶️ Running the Code

In MATLAB:
```matlab
single_HCO
````

---

## 🧩 Other Code

* `HCO_vary_tau_s.m`: Script with varied `tau_s` (synaptic time constant)
* `HCO_vary_tau_us.m`: Script with varied `tau_us` (ultra-slow adaptation constant)
* `HCO_tune_pulse_phase.m`: Script to explore pulse timing and coordination

These additional scripts explore how changes in synaptic and adaptation timescales affect the oscillatory behavior and torque generation of the HCO network. By tuning `tau_s` and `tau_us`, users can investigate network responsiveness, rhythm stability, and phase shifts—providing insights into biologically inspired motor control and temporal processing.

---

## 📚 Citation

If you use or adapt this model, please cite the original paper:

```
@article{schmetterling2024neuromorphic,
  title={Neuromorphic control of a pendulum},
  author={Schmetterling, Raphael and others},
  journal={IEEE Control Systems Letters},
  year={2024}
}
```

---

## 📬 Contact

For questions or collaboration, feel free to reach out to the project authors or submit an issue.

---

