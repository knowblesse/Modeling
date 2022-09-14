# VDAC
Simulation & figure drawing scripts for **Value Driven Attentional Capture (VDAC)** thesis.

The manuscript is submitted on 2022SEP14 (KST).

The scripts include quantitative evaluation of models with global optimization.

Detailed information will be updated.

## General Descriptions

There are three kinds of files in this folder.

- Optimization scripts
- Optimization results
- Figure drawing scripts 

### 1. Optimization scripts

Optimization scripts try to find the best parameter set for each associative learning model that has the lowest **negative log-likelihood (NLL)** with the actual human experiment data.

In this way, each model will do its best to explain the experiment result by changing its modifiable parameter set.

Initially, I planned to make a single optimization script that can be applied to all research in this thesis. 

However, the number of stimuli used or train/test session composition varied across different research, and I had to modify the script to fit with each research.

- **`SimulateModel.m`** contains all implementation of associative learning models
- **`getDefaultParam.m`** contains default parameterset for each model
- **`computeNLL`** computes NLL for optimization
- **`mlParameterSearch2.m`** search the parameter set that has the lowest NLL
- **`SearchAll2ParamExp.m`** Main batch script for finding the parameter sets for the following research
    - Anderson et al. (2011b) Exp1
    - Anderson & Halpern (2017) Exp1
    - Cho & Cho (2021) Exp1
    - Anderson (2016) Exp1
    - Mine & Saiki (2015) Exp2

Other studies not listed above have their own folders for the optimization.
    - Anderson et al (2011a) Exp1
    - Cho & Cho (2021) Exp2
    - LePelly et al. (2019)
    - Liao et al. (2020)

Finally, optimization script for the latent inhibition is in a separate folder.

Simulations that shares the same **`mlParameterSearch2.m`** must load each experiment setting data, and this is in the **`/experiments`** folder.

### 2. Optimization results

All optimization results are stored in the **`/result_nll`** folder.

### 3. Figure drawing scripts

All figure drawing scripts are stored in the **`/Figures`** folder



