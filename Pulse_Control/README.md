
# 🌀 Pulse-Based Pendulum Control

This repository contains a set of MATLAB scripts exploring **pulse-based and PD-based control strategies** for a simple pendulum system. The goal is to investigate how different control paradigms—neuromorphic pulses, energy-based switching, and classical PD control—can be used to swing, stabilize, or manipulate a pendulum.

---

## 📂 Code Overview

| File | Description |
|------|-------------|
| `Pulse_control_inphase.m` | Pulse torque applied **in phase** with pendulum motion. Sweeps amplitude, period, and duty cycle. |
| `Pulse_control_antiphase.m` | Pulse torque applied **anti-phase** to slow down or resist pendulum motion. |
| `Swing_pulse_control.m` | Energy-based pulse controller that builds a **swinging limit cycle** toward a target amplitude. |
| `Equilibrium_pulse_control.m` | **Anti-phase stabilization**: uses short pulses to remove energy and stabilize the pendulum at vertical. |
| `Equilibrium_PD.m` | Classical PD controller to stabilize the pendulum upright. |
| `Swing_PD.m` | Classical PD controller to drive the pendulum into sustained oscillations. |

---

## 📈 Dynamics

All scripts simulate the motion of a simple pendulum:
- Length `L = 0.36 m`
- Mass `m = 1.0 kg` (or computed from volume in some scripts)
- Gravity `g = 9.81 m/s²`
- Moment of inertia computed as `J = m * L²`
- Simulations are performed using either ODE solvers or fixed time-step integration (`dt = 0.001 s`)

---

## 🧪 Control Strategies

### 🔁 1. `Pulse_control_inphase.m`
Applies square-wave torques **in sync** with motion. Sweeps three parameters:

- **Amplitude (`K`)**
- **Period (`T`)**
- **Duty cycle (`duty`)**

Plots the effect of these parameters on pendulum motion and torque signals.

### 🔁 2. `Pulse_control_antiphase.m`
Like the above, but torques oppose motion. Demonstrates damping-like behavior through **pulse reversal**.

### 🏁 3. `Equilibrium_pulse_control.m`
Neuromorphic-style **anti-phase pulsing** with no friction. Detects when pendulum is crossing center and applies a short, opposing torque burst.

- Stops automatically when energy becomes low
- Demonstrates stabilization at the vertical without dissipation

### 🧠 4. `Swing_pulse_control.m`
Energy-based pulse control:

- Pulses timed near zero-crossing to **inject energy**
- Goal: reach and maintain a target amplitude
- Mimics **central pattern generator (CPG)**-like control

Also plots total system energy and phase portrait.

### 🧮 5. `Equilibrium_PD.m`
Classic PD control:

- Stabilizes pendulum around `θ = 0`
- Uses linear torque based on angle and angular velocity

### 🧮 6. `Swing_PD.m`
PD controller tuned to drive the pendulum into a limit cycle:

- Behaves similar to underdamped oscillator
- No pulsing—continuous torque control

---

## 📊 Output

Most scripts generate plots for:

- **Angle vs. time**
- **Angular velocity**
- **Torque signal**
- **Energy**
- (Some) **Phase portrait**

These help visualize how pulse-based vs. continuous control strategies influence pendulum dynamics.

---

## ▶️ How to Run

Open MATLAB and run any script directly:

```matlab
Pulse_control_inphase
Swing_pulse_control
Equilibrium_PD
% etc.
````

Each script is self-contained and includes clear parameter definitions. Use the plots to compare control effectiveness and energy usage.

---

## 🧠 Why Pulse Control?

Pulse-based control mimics how biological motor systems generate bursts of force through **spiking pulse** and **timing-based feedback**. These scripts provide insight into how simple timing rules can lead to complex motor outcomes—offering an alternative to traditional continuous feedback controllers.

---

## 📬 Contact

For questions or contributions, please open an issue or contact the repository maintainer.

---

