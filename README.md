# smard-power-forecasting

This repository is for forecasting german energy power consumption and generation.

Based on:

- [Forecasting: Principles and Practice](https://otexts.com/fpp3/)
- DOI: [10.1109/TPWRS.2011.2162082](https://ieeexplore.ieee.org/document/5985500) - Short-Term Load Forecasting Based on a Semi-Parametric Additive Model
- DOI: [10.1109/TPWRS.2009.2036017](https://ieeexplore.ieee.org/document/5345698) - Density Forecasting for Long-Term Peak Electricity Demand
- DOI: [10.1080/00031305.2017.1380080](https://www.tandfonline.com/doi/full/10.1080/00031305.2017.1380080) - Forecasting at Scale

Data source: [SMARD](https://www.smard.de/home/downloadcenter/download-marktdaten/)
    
- Resolution: 1h
- Timewindow: from 2015-01-01 to 2024-09-07

Put all dowloaded files into:

    /example/dataset

Check the [forecast.Rmd](example/forecast.Rmd) file to see how you can run
this code on your dataset.