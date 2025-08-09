# REXoplanets

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