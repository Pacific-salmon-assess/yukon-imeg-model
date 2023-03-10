# yukon-imeg-model

Repository for generating run-reconstructions for lower, middle, and upper (Canadian) Yukon River Chinook salmon (*Oncorhynchus tshawytscha*) stock aggregates as well as biological reference points for the Canadian stock. Estimates are based on an integrated state-space run reconstruction and spawner-recruitment model fit to data (1981-2022) from various assessment projects that estimate mainstem passage, harvests, tributary escapements, stock-proportions, and age-composition, under a single Bayesian estimation framework. 

Full model details are described in: 

>Connors, B.M., Bradley C.A., Cunningham C., Hamazaki T., and Liller, Z.W. 2022. Estimates of biological reference points for the Canadian-origin Yukon River mainstem Chinook salmon (*Oncorhynchus tshawytscha*) stock aggregate. DFO Can. Sci. Advis. Sec. Res. Doc. 2022/031.iv + 100 p.

A summary of model outputs is available [here](https://pacific-salmon-assess.github.io/yukon-imeg-model/04_summary/Model-summary-document.html)

## Repository structure
- `01_inputs`: Contains raw data model is fit to as well as scripts for updating data file ('2022-updates-to-data.R') as more data become available. 
- `02_models`: Contains Stan model file and script to fit model to data.
- `03_outputs`: Contains posterior samples from model fit as well as csv of run-reconstruction estimates of escapement , harvest and harvest rate by stock (`rr-table-2022.csv`)
- `04_summary`: Contains a Rmd file (`Model-summary-document.Rmd`) that can be used to summarize outputs from model. Just open and click 'Knit' button. Also generates stand alone figures and outputs a `.csv` of run-reconstruction estimates that is saved to `03_outputs` folder

## Updating data and refitting model 
To update data add addition years in `01_inputs/2022-updates-to-data.R`, save as a new R script (e.g., `2023-updates-to-data.R`) and save updated .rds file. Then to fit model to updated data run `Run-integrated-model.R` in the `02_models` subfolder, also saving outputs as new year stamped .rds file. Lastly, to summarize outputs of model knit `Model-summary-document.Rmd` in the `04_summary` subfolder.
