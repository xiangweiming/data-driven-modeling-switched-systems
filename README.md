# Data Driven Model of Switched Systems (A DC-DC Modeling Exmaple)

# Installation:
  1) Install MATLAB.
  2) Clone or download code from (https://github.com/xiangweiming/data-driven-model-of-switched-systems).
  3) Run main.m in dc-dc example folder.

Note: This code is for a DC-DC modeling example. A complete data-driven tool is still under development.

# Features:

1) trace_generate_dcdc.m generates traces from the DC-DC model and one random state response. Numbers of traces numX0 = 20 and length of simulation K_train = 1000 are initialized, you can change to any numbers (positive integer). One state response is plotted. 

<figure>
    <img src="/image/dcdc.png" width="200"> <figcaption>DC-DC Converter Topology.</figcaption>
</figure>

<figure>
    <img src="/image/fig1.png" width="400"> <figcaption>One Random State Response.</figcaption>
</figure>

2) train_dcdc.m generates a data-driven model. A switching detection (systemInfo.subsystem, switchInfo.outputDataSegmented, switchInfo.switchTime), reconstructed switching (systemInfo.segmentIndex), and ELMs (systemInfo.subsystem) are obtained.

	switchInfo = 

  	struct with fields:

     inputDataSegmented: {1×100 cell}
    outputDataSegmented: {1×100 cell}
             switchTime: [1×101 double]

	systemInfo = 

  	struct with fields:

       subsystem: {[1×1 struct]  [1×1 struct]}
    segmentIndex: {[1×50 double]  [1×50 double]}

<figure>
    <img src="/image/fig2.png" width="400"> <figcaption>Switching Detection.</figcaption>
</figure>


<figure>
    <img src="/image/fig5.png" width="400"> <figcaption>Reconstructed Switchings.</figcaption>
</figure>

<figure>
    <img src="/image/fig3.png" width="400"> <figcaption>State Responeses.</figcaption>
</figure>

<figure>
    <img src="/image/fig4.png" width="400"> <figcaption>State Trajectories.</figcaption>
</figure>


3) systemSim_dcdc.m generate the state response figure, switching instant figure. 





