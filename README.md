### <font color="green"> <span style="font-size:larger;"> Underwater Systems</font>

<font color="green">**Title**:</font> Complete model, simulation and design of an navigation filter for AUV during a lawn-mower survey   
<font color="green">**Authors**:</font> Rachele Nebbia Colomba, Chiara Sammarco, Francesco Vezzi, Matteo Paiano*

This repository contains the final project of course *Underwater Systems* for the master degree in Robotics and Automation Engineering at Universita´ di Pisa.   
The work includes the complete model of the AUV, the simulation of the environment and sensors, the design of the controller and navigation filter needed to perform the mission.   
All the simulations and validation tests were performed using Matlab/Simulink environment.  

The integrated system can be splitted in five main models:  
&#x1F538; **Trajectory generator**: it computes the survey trajectory of the unknow area;  
&#x1F538; **Vehicle Model**: it contains the AUV geometric parameters and dynamics + trusthers postion;  
&#x1F538; **Control**: it contains the PID controllers for the thrusters of the AUV;  
&#x1F538; **Sensor+Environment**: it contains the complete simulation of the environment (seabed model) and model of the chosen sensors;  
&#x1F538; **Navigation**: it contains the kalman navigation filter. 

Below you can visualize a representation of the model of our AUV, "*Pasqualo*". 

<img src="https://github.com/rachele182/navigation_systems/assets/75611841/16b22289-f5a4-4cf3-a26e-ecd3426b7a5f" width="375">

The project contains three main folders: 

- **sensor_model** : here you can find the matlab/simulink files used to simulate the underwater envirnoment and the sensors;  

- **mission** : here you can find the simulink file and the matlab scripts needed to run the simulation of the complete mission;  
  
- **animation**: inside you can find the main script to run an animation of the executed mission. 

A guide with a brief description of the files as well as the instruction on how to run the simulation/animation can be find in the **contents.md** inside the mission folder.  

Please note this project was part of at team work of multiple master students. In **sensor_model** we report all the detailed scripts, simulation files developed from the authors in * for the sensor/environment model.   
In the other two folder you can find the final mission as result of the full-integration between all the five modules.

<img src="https://github.com/rachele182/navigation_systems/assets/75611841/39082569-4841-47a7-8545-c70805ac7949" width="425">


