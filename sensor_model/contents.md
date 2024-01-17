### <font color="green"> <span style="font-size:larger;"> Contents of Mission folder: </font> </span>

Here after a brief description of the contents of the folder.   

- **Simulation File**:
    - simusink.slx: contains simulink file with the full model of the sensors used during the mission on the AUV
    - validazione_sonar_down.slx, validazione_sonar_front.slx: simulink file to validate the model of the two sonars, including batimetry model of the seabed. 
    - validazione_usbl.slx: simulink file used to validate the model of the sensor USBL. 

- **Matlab Scripts**:
    - init_sensors.m:  initialization matlab files containing all the sensors parameters; 
    - main_init.m: script used to run all the initialization files and setup the workspace for the complete system;
    - missionA.m: script to load the mission parameters e.g survey area specifications;
    - seabed_function.m: contains the model of the environmet, e.g function representing the seabed;
    - rot_body_ned.m,rot_ned_body.m,rotx.m,rot_body_ned_media.m: util functions to rotate from ned to body and viceversa;
    - sonar_media.m : model of sonar where we do an average of the calculate points to smooth the estimation of seabed profile;
    - Validazione_sonar.m: script file to validate the sonar model;
    - usbl.m script to model USBL sensor. 

- **How to run**:
    1. run the init_sensors.m to set up the complete workspace of the simulation; 
    2. to run a simulation open simusink.slx and click on play;
    3. for further validation analysy run the other simulink files.   

Please note that all the files are written in Matlab and simulink. To run the simulations a Simulink version **>=R2020a** is needed.  
