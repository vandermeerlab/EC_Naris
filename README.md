Carmichael et al. (submitted)

Code used for processing, analysis and visualization in Carmichael, Gmaz, van der Meer (submitted),"Gamma oscillations in the rat ventral striatum originate in the piriform cortex " ([preprint]())

Makes extensive use of the [vandermeerlab codebase](https://github.com/vandermeerlab/vandermeerlab); please use this commit if you want to be sure you are using the same code that generated the results in the paper.

Once you have checked out the above code, set up your MATLAB path using this script.

To obtain the data, e-mail mvdm at dartmouth dot edu to get access to the lab server. Then, to reproduce the results in the paper, run the following:

LFP mapping:
To load raw data and generate intermediate files (all_data_pre, all_data_post, all_data_task) run [AMPX_LFP_MASTER](https://github.com/vandermeerlab/EC_Naris/blob/ee2254f85d7147551c62f0040e78e82cd65f088b/Naris_Paper/Naris/AMPX_LFP_MASTER.m)  To generate figures run [AMPX_figures_MASTER](https://github.com/vandermeerlab/EC_Naris/blob/ee2254f85d7147551c62f0040e78e82cd65f088b/Naris_Paper/Naris/AMPX_figures_MASTER.m)

Naris occlusion:
To load data, generate figures, and get statistics run [Naris_master](https://github.com/vandermeerlab/EC_Naris/blob/ee2254f85d7147551c62f0040e78e82cd65f088b/Naris_Paper/Naris/Naris_MASTER.m). This can be done indepentandly from the LFP mapping workflow. 

Toolboxes used in this analysis
FieldTrip - Used for LFP mapping experiment (Oostenveld, R., Fries, P., Maris, E., Schoffelen, JM (2011) FieldTrip: Open Source Software for Advanced Analysis of MEG, EEG, and Invasive Electrophysiological Data. Computational Intelligence and Neuroscience Volume 2011 (2011), Article ID 156869, doi:10.1155/2011/156869; http://www.ru.nl/neuroimaging/fieldtrip)
Chronux - used for part of the CSD analysis (http://chronux.org/) see reference material in: "Observed Brain Dynamics" by Partha Mitra and Hemant Bokil, Oxford University Press, New York, 2008.


We used MATLAB R2014b running on 64-bit Windows 7.

Wiki-based tutorials introducing the codebase architecture, and step-by-step explanations of specific analyses, are [here](http://ctnsrv.uwaterloo.ca/vandermeerlab/doku.php?id=analysis:course-w16).