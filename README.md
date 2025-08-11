# REXoplanets <img src="man/figures/logo.png" align="right" height="139" alt="" />

## Description

**REXoplanets** is an R package that provides a user-friendly interface to NASA's Exoplanet Archive API. It includes functions for retrieving and analyzing exoplanet data, such as computing key parameters, classifying celestial bodies, and generating visualizations. The package emphasizes identifying potentially habitable and Earth-like planets.

An example Shiny application is included to demonstrate its capabilities.

## Installation

### Via remotes (recommended)

We recommend using [remotes](https://github.com/r-lib/remotes) for package installation, along with all system dependencies. If you do not have `remotes` available, you will need to set it up first:

```r
install.packages("remotes")
```
Now you can install [REXoplanets](.) by running:

```r
remotes::install_github("JKolomanski/REXoplanets")
```

Then, to load the library, simply run:

```r
library("REXoplanets")
```

## Features

### API access
Fetch data from the NASA Exoplanet Archive’s TAP service using:

```r
fetch_table("[table name]")
```

Supports filtering and replacing column names with their descriptive labels:

```r
fetch_table("ps", query_string = "pl_bmasse > 3", pretty_colnames = TRUE)
```
### Calculations and Classifications
Built-in functions for habitability and Earth similarity analysis, e.g.:

  * `calculate_esi()` – Earth Similarity Index.
  * `calculate_stellar_flux()` – Stellar flux based on orbital and stellar parameters.

Quick body classification tools such as:
  * `classify_planet_type()` – Classify planets into categories.

### Visualizations
Generate publication-ready visualizations:

  * `scatterplot_esi()` – ESI vs. another parameter.

  * `plot_star_system()` – Stylized star system maps.

All visualizations return ggplot2 objects for easy customization.

### Application
The REXoplanets application provides an interactive interface for exploring data from the NASA Exoplanet Archive. It allows you to search for star systems, visualize their structure, and view key information about all known stellar bodies.

To run the REXoplanets application invoke:

```r
REXoplanets::app()
```

This will start the Shiny server and open the application in your browser.

## Contributing

All contributions to REXoplanets are welcome.

If you encounter a bug or request a new feature, report it by opening a new issue on our [Github](https://github.com/JKolomanski/REXoplanets/issues) page. Please utilize the correct issue template.

### Development setup

If you wish to contribute to the code of the package, do so by cloning the repository through your terminal/shell:

```bash
git clone https://github.com/JKolomanski/REXoplanets.git
```

and then loading it directly using [`devtools`](https://github.com/r-lib/devtools) in your IDE (e.g. RStudio) console:

```r
devtools::load_all()
```

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
