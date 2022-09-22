# Data cleaning and standardisation in R 

[![Funding](https://img.shields.io/static/v1?label=powered+by&message=lifewatch.be&labelColor=1a4e8a&color=f15922)](http://lifewatch.be) [![renv check](https://github.com/lifewatch/ebr-2022-data-cleaning-standarization/workflows/renv-check/badge.svg)](https://github.com/lifewatch/ebr-2022-data-cleaning-standarization/actions) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/lifewatch/ebr-2022-data-cleaning-standarization/HEAD?urlpath=rstudio)

Exercises and slides to be used during the Workshop *Research data management workshop: Hands-on introductions to research data management and publication* in the framework of the Empowering Biodiversity Research Conference II (EBRII). You can find practical information about the workshop and the EBRII conference [here](https://www.biodiversity.be/5147/).

## Set-up 🖥️ 

* We use [R v4.0](https://www.r-project.org/) or higher and [RStudio](https://www.rstudio.com/). This workshop has been tested using R v4.2, RStudio and package versions available at the moment (2022-09-28).

* Download this repository and open the `ebr-2022-data-combine.Rproj` file with RStudio


## Get started 🚀

The exercises for the workshop are in 📁: `./R/Datacleaning_standardization`. 

🌟 **Now we can start the workshop!** 🌟

## Extra Information

### Directory structure 📁 

```
ebr-2022-data-combine/
├── data/ - directory to read local file 
├── slides/ - contains the slides 
└── R/  - 
	├── Datacleaning_standardization/ - script with the exercises that will be used during the workshop
	└── Datacleaning_standardization_solution/ - scripts with the exercises already solved
├── .Rprofile
├── .gitignore
├── Dockerfile - requirement to open the project on binder, uses rocker/binder image
├── install.R - scripts to be run by binder to set up the dependencies of the project
├── README.md
├── ebr-2022-data-combine.Rproj - open this file to start the project
└── renv.lock - this file is used by renv to record the dependencies used by the project
```



### Acknowledgements 🙏

This workshop is inspired on the [INBO Coding Club sessions](https://inbo.github.io/coding-club/).


