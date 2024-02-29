### <font color="green"> <span style="font-size:larger;"> Contents of Mission folder: </font> </span>

Here after a brief description of the contents of the folder.   

- **Simulation File**:
    - teamA_PAsqualo.slx: contains simulink file with the full-integrated simulation of the survey mission. 

- **Matlab Scripts**:
    - init_*.m:  initialization matlab files for each module:  **Trajectory generator** + **Vehicle Model** + **Control**+**Sensor/Environment**+ **Navigation**;
    - main_init.m: script used to run all the initialization files and setup the workspace for the complete system;
    - missionA.m: script to load the mission parameters e.g survey area specifications;
    - proveplots.m: script to plot estimated position results (the plot refers to a pre-run simulation).

- **Include folder**:
    - contains all the basic functions used in the simulation e.g **seabed_function.m**. 

- **How to run**:
    1. run the script main_init.m to set up the complete workspace of the simulation; 
    2. to run a simulation open TeamA_PAsqualo.slx and click on play;
    3. to visualize animation of the run of simulation run script animazione.m in animation folder;
    4. to visualize a 2D plot of the simulation --> run script plot2d.m; 
    5. for both visualization files, it is possible to run a simulation and save the result of every simulation as out_*.mat to visualize the animation and plots for each specific simulations.  

Please note that all the files are written in Matlab and simulink. To run the simulations a Simulink version **>=R2020a** is needed.  
