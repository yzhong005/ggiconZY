# Contributing to ggiconZY

Contributions are welcome through GitHub issues and pull requests.

## Report a problem

Include a minimal R example, the output of `sessionInfo()`, and the icon or
culture-plate function involved.

## Propose an icon

Coordinate datasets should:

- use a short lower-case icon name;
- contain numeric `x` and `y` columns;
- omit exported row-number columns;
- contain only the detail required for a clear plotted silhouette; and
- include an example image or script demonstrating the intended result.

Store new icon data in `inst/extdata/icons/`, register it in `.ggicon_files` in
`R/icons.R`, and add coverage in `tests/testthat/test-icons.R`.

## Validate a change

Run the following from the package root:

```r
devtools::test()
devtools::check()
```

Keep pull requests focused and explain any changes to existing coordinates.
