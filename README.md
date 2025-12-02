This repository contains software associated with the manuscript _Tendler et al., Diffusion-weighted steady-state free precession imaging in the ex vivo macaque brain on a 10.5T human MRI scanner_. 

Scripts are written in MATLAB, with details as follows:

- **_DW-SSFP/SE/STE_ParameterOptimisation.m_**: Scripts to identify DW-SSFP, DW-SE, and DW-STE sequence parameters that maximise SNR efficiency.

- **_ParameterOptions.m_**: Script to define your scanner & sample properties for parameter optimisation

- **_Figures_**: Directory containing scripts to recreate some of the Figures in the manuscript.

- **_bin_**: Directory containing supporting functions for the parameter optimisation software.

**Running the Sequence Optimisation Software**
 
1. In the _ParameterOptions.m script_ define your scanner & sample properties
 
2. In the _..._ParameterOptimisation.m_ script define a target b-value to optimise.
 
3. Run the _…_ParameterOptimisation.m_ script 

**Outputs**

1. (All Scripts) Optimised sequence parameters, corresponding b-value & SNR efficiency (% of S<sub>0</sub>)

2. (DW-SSFP Script) Optimised sequence parameters corrected for the 2*pi*n dephasing condition of DW-SSFP (dependent on the target resolution provided in the 'ParameterOptions.m' script)

3. (DW-SSFP Script) Table of gradient amplitudes associated with 2*pi, 4*pi...2*n*pi dephasing and corresponding q-/b-values. Useful for establishing multi-shell protocols or defining b0-equivalent acquisitions
