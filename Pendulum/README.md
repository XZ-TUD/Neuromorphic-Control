# 🔄 Stability Diagram of a Damped Driven Pendulum

This MATLAB script visualizes the **stability regimes** of a damped, torque-driven pendulum by constructing a bifurcation diagram over a grid of parameters. It also includes an **accurate numerical computation** of the **homoclinic bifurcation curve**, which separates bistable and monostable regimes.

---

## 🧮 Governing Equation

The system is governed by the second-order nonlinear ODE:

```

q'' + α·q' + sin(q) = I

````

Where:
- `q` is the pendulum angle
- `α` is the damping coefficient
- `I` is the constant driving torque

---

## 📌 Features

✅ Computes and visualizes three key dynamical regimes:
- **Fixed Point**: Stable at rest  
- **Rotation**: Continuous rotation  
- **Bistable**: Coexistence of stable fixed point and rotation

✅ Accurately plots the **homoclinic bifurcation** curve using root-finding (via `fzero`) on a custom condition

✅ Generates a **2D stability map** in the (α, I) parameter space

---

## 🗺️ Output Diagram

The output figure displays:
- **Colored regions** for each dynamic regime:
  - Red: Fixed Point
  - Blue: Rotation
  - Yellow: Bistable
- **Solid black curve**: Accurate homoclinic bifurcation boundary
- **Contour lines**: Visual separatrices between regimes

---

## 📂 File

| Filename | Description |
|----------|-------------|
| `Pen_stability_diagram.m` | Main script to generate the bifurcation/stability diagram |
| *(inline)* | Includes function `homoclinic_condition(I, α)` to compute bifurcation numerically |

---

## ▶️ How to Run

Open MATLAB and run:

```matlab
Pen_stability_diagram
````

A stability diagram figure will be generated automatically.

---

## 🔧 Dependencies

* MATLAB’s built-in functions: `meshgrid`, `imagesc`, `contour`, `fzero`, etc.
* No toolboxes required
* Compatible with MATLAB R2018+ (recommended)

---

## 🧠 Scientific Insight

* **Homoclinic bifurcations** mark the transition between qualitatively different dynamic behaviors.
* This script offers an **energy-based approximation** for computing the exact location of the homoclinic curve, improving over rough analytical thresholds.

---

## 📬 Contact

For questions, improvements, or scientific discussions, feel free to open an issue or contribute.

---

