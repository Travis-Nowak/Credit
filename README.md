
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{Credit}`

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

You can install the development version of `{Credit}` like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Run

You can launch the application by running:

``` r
Credit::run_app()
```

## About

You are reading the doc about version : 0.0.0.9000

This README has been compiled on the

``` r
Sys.time()
#> [1] "2025-03-17 19:58:40 MDT"
```

Here are the tests results and package coverage:

``` r
devtools::check(quiet = TRUE)
#> ℹ Loading Credit
#> Warning: replacing previous import 'DT::dataTableOutput' by
#> 'shiny::dataTableOutput' when loading 'Credit'
#> Warning: replacing previous import 'DT::renderDataTable' by
#> 'shiny::renderDataTable' when loading 'Credit'
#> ── R CMD check results ────────────────────────────────── Credit 0.0.0.9000 ────
#> Duration: 8.3s
#> 
#> ❯ checking package dependencies ... ERROR
#>   Namespace dependencies missing from DESCRIPTION Imports/Depends entries:
#>     'DT', 'bslib', 'ggplot2'
#>   
#>   See section 'The DESCRIPTION file' in the 'Writing R Extensions'
#>   manual.
#> 
#> 1 error ✖ | 0 warnings ✔ | 0 notes ✔
#> Error: R CMD check found ERRORs
```

``` r
covr::package_coverage()
#> Credit Coverage: 90.27%
#> R/run_app.R: 0.00%
#> R/app_ui.R: 42.11%
#> R/app_config.R: 100.00%
#> R/app_server.R: 100.00%
#> R/golem_utils_server.R: 100.00%
#> R/golem_utils_ui.R: 100.00%
#> R/mod_module_1.R: 100.00%
#> R/mod_module_2.R: 100.00%
#> R/mod_module_3.R: 100.00%
#> R/mod_random.R: 100.00%
```
