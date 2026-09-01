# Caffeine-HeartRate-PD-Model

Run this R script to analyze your own caffeine heart rate data using a simple crossover design.

---

## What you need

- R (version 4.0 or higher)
- RStudio (optional but recommended)
- One CSV file (or type numbers manually)

---

## How to run

1. Open `caffeine_model_interactive.R` in RStudio.
2. Click the **Source** button (or press `Ctrl + Shift + Enter`).
3. In the console, choose a data input method:
   - `1` → use built-in demo data (no file needed)
   - `2` → read from a CSV file (recommended)
   - `3` → type 12 numbers by hand
4. Follow the on-screen prompts.
5. The script will:
   - show two plots
   - print Tmax, peak ΔHR, and AUC
   - save the plots as PNG files in your working directory

---

## CSV file format (if you choose option 2)

Save a plain text file with **no header** and **two columns** (separated by comma or space):

```csv
72, 72
71, 76
73, 80
72, 84
78, 86
74, 87
75, 85
73, 83
72, 80
74, 78
73, 76
71, 74
```

- Column 1: heart rate on **control day** (no caffeine)
- Column 2: heart rate on **caffeine day**
- Exactly 12 rows (one every 10 minutes, from 0 to 110 min)

---

## Output

- Two plots: raw curves and smoothed net effect
- Console output with:
  - Tmax (time to peak effect, in minutes)
  - Maximum net HR increase (bpm)
  - AUC (area under the curve, bpm·min)

---

## Required R package

- `ggplot2` (will be installed automatically if missing)

---

## Notes

- This is a personal exploratory tool, not a clinical diagnostic.
- All calculations are based on your own input data.
