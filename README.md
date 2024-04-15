# Brain Tumor Segmentation using 3D MRIs

Quick guide to use the scripts provided:

1-main.mlx is a MATLAB notebook file meant for understanding what is the workflow adopted to perform the segmentation;

2-fineTuning.m is used to find the best parameters. It is structured in 3 parts, each one performing the 3 main tests that I conducted. Each of this test calls a function named test* that is the same content of 1-main.mlx file but without figures and unnecessary things to speed up computation (Note that it is not necessary to run this file. The results of the computations are saved in .mat files under the directory savedVariables);

3-graphs.m is used to analyze the output of the fine tuning stage, so as before, it is subdivided into 3 parts (each one for each test conducted).

Under the folder utilities there are functions created because they were called multiple times, and for better code and understanding were separated by the main script.