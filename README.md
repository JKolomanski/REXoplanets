# REXoplanets

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Lifecycle: Experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/REXoplanets)](https://CRAN.R-project.org/package=REXoplanets)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/REXoplanets)](https://cran.r-project.org/package=REXoplanets)

## Description

**REXoplanets** is an R package that provides a user-friendly interface to NASA's Exoplanet Archive API. It includes functions for retrieving and analyzing exoplanet data, such as computing key parameters, classifying celestial bodies, and generating visualizations. The package emphasizes identifying potentially habitable and Earth-like planets.

An example Shiny application is included to demonstrate its capabilities.

## Installation

### Via remotes (recommended)

We recommend using [remotes](https://github.com/r-lib/remotes) for package installation, along with all system dependencies. If you do not have `remotes` available, you will need to set it up first:

```r
install.packages("remotes")
```
then you can install [REXoplanets](.) by running:

```r
remotes::install_github("JKolomanski/REXoplanets")
```

### Via cloning the repository (for contributors)

Alternatively, you can set up the package by cloning the repository through your terminal/shell:

```bash
git clone https://github.com/JKolomanski/REXoplanets.git
```

and then loading it directly using [devtools](https://github.com/r-lib/devtools) in your IDE (e.g. RStudio) console:

```r
devtools::load_all()
```

## Quick start

To load the app, simply run:

```r
library("REXoplanets")
```

### Running the application

To run the REXoplanets application invoke:

```r
REXoplanets::app()
```

This will start the Shiny server and open the application in your browser.


### Log level
The package and application utilize [logger](https://daroczig.github.io/logger/). As a default, the log level is set to **INFO**. If you wish to receive more (or less) in-depth logging information, you can specify the level by setting an environment variable `REXOPLANETS_LOG_LEVEL`. You can do that by running:
```R
Sys.setenv(REXOPLANETS_LOG_LEVEL = "TRACE")
```
or by creating `.Renviron` file in the root of your project:
```R
REXOPLANETS_LOG_LEVEL=ERROR
```
For settings in the `.Renviron` file to be applied, you will need to either restart your R session or load the file explicitly by running `readRenviron(".Renviron")`.

## Documentation and references


- Please go to [our Website](.) (TBA) for further information on the **REXoplanets** library and application.