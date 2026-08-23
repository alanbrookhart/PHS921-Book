# Causal Inference in Epidemiology Using R

**Read the book:** <https://alanbrookhart.github.io/PHS921-Book/>

*Causal Inference in Epidemiology Using R* is a code-first
introduction to causal inference for epidemiology students moving from
associational to causal thinking. It assumes an introductory course in
epidemiology and one in biostatistics, but no prior exposure to causal
inference as a formal framework and no prior experience with R.

The book is organized into four parts, moving from foundational
concepts to a growing toolkit of estimators:

- **Foundations** (Chapters 1-6) — why causal questions need more than
  association, potential outcomes and estimands, the randomized trial as
  a benchmark, causal diagrams, and study design.
- **Core Methods** (Chapters 7-9) — outcome regression and
  standardization, propensity scores, and inverse probability of
  treatment weighting.
- **Time, Censoring, and Survival** (Chapters 10-12) — survival
  outcomes, inverse probability of censoring weighting, and the
  clone-censor-weight approach to sustained treatment strategies.
- **Beyond Exchangeability** (Chapters 13-14) — instrumental variables
  and sensitivity analysis for unmeasured confounding.

Two running examples, drawn from the National Ambulatory Medical Care
Survey (NAMCS), recur throughout: whether a Cox-2 selective NSAID
changes the risk of peptic ulcer disease compared with a nonselective
NSAID, and whether initiating a statin changes the risk of a
cardiovascular event. Along the way, each chapter adds one reusable R
function to a small estimator toolkit in `R/`, summarized in Appendix C.

## Building the book

The book is written in R Markdown and built with
[bookdown](https://bookdown.org/). From the project root:

```r
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

This renders every chapter and appendix into a gitbook site under
`_book/`; open `_book/index.html` to read it. A full render takes several
minutes, since a few chapters bootstrap confidence intervals.

## Package requirements

```r
install.packages(c(
  "tidyverse", "bookdown", "dagitty", "ggdag", "survival",
  "cobalt", "geepack", "broom", "remotes"
))
remotes::install_github("alanbrookhart/NAMCS")
```

Appendix A walks through installing R, RStudio, and these packages in
more detail, including troubleshooting the GitHub install.

## Data source

Both example cohorts are built from real visits in the [National
Ambulatory Medical Care Survey](https://www.cdc.gov/nchs/ahcd/index.htm)
(NAMCS), 2005-2009, and packaged for teaching in the
[`NAMCS`](https://github.com/alanbrookhart/NAMCS) R package. Covariates
and treatment assignment come from the real survey data; outcomes are
simulated so that every estimate in the book can be checked against a
known truth. Appendix B is a full, data-generated codebook for both
cohorts.

## Repository layout

- `01-*.Rmd` through `14-*.Rmd` — the fourteen chapters.
- `90-appendix.Rmd` — the appendices (setup, codebook, estimator
  toolkit, further reading).
- `index.Rmd` — the preface and bookdown entry point.
- `R/` — shared R functions sourced by every chapter; see `R/README.md`.
