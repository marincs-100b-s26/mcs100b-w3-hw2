# ottr Test Conventions for MARIN CS 100B Assignments

This document describes how to write ottr autograder tests for homework assignments in this course. Use it as a reference when creating tests for a new assignment.

---

## File structure

- One test file per exercise (or setup block), placed in `tests/`.
- Typical names: `setup.R`, `ex1.R`, `ex2.R`, etc.
- Each file defines a single `test` list with a `name` and a `cases` list of `ottr::TestCase$new(...)` objects.

```r
test = list(
  name = "ex1",
  cases = list(
    ottr::TestCase$new(
      name = "Ex1a: descriptive name",
      code = { ... }
    ),
    ...
  )
)
```

## Placing tests in the .qmd

After each student code chunk, add a test chunk:

````markdown
```{r}
#| label: test-ex1
. = ottr::check("tests/ex1.R")
```
````

The `label` is for internal reference only; the filename passed to `ottr::check()` is what matters.

---

## Test case patterns

### Object existence

Always check that a required variable exists before testing its contents. This catches students who computed a value but forgot to assign it.

```r
testthat::expect_true(
  exists("my_var", envir = .GlobalEnv),
  label = "'my_var' not found — assign your result to 'my_var'"
)
```

### Class check

After confirming existence, retrieve the object with `get0` and verify its class.

```r
my_var <- get0("my_var", envir = .GlobalEnv)
testthat::expect_s3_class(my_var, "data.frame")
```

### Data frame contents

Check column names and row count. When the expected row count can be derived from another variable already in the environment, recompute it rather than hardcoding — this keeps the test correct if the source data changes.

```r
# Column names
testthat::expect_true(
  all(c("col_a", "col_b") %in% names(my_var)),
  label = "my_var is missing expected columns"
)

# Row count — hardcoded (use when the count is a fixed property of a dataset file)
testthat::expect_equal(nrow(my_var), 404235L)

# Row count — recomputed (use when count depends on a filter applied to another variable)
testthat::expect_equal(
  nrow(filtered_var),
  nrow(dplyr::filter(source_var, some_condition)),
  label = "Unexpected row count — check your filter"
)
```

### Row-level invariants

Verify that every row satisfies a condition (e.g., a filter was applied correctly).

```r
testthat::expect_true(
  all(my_var$some_col > threshold),
  label = "All rows should satisfy the condition"
)
```

### Plot — existence and class

Use `ggplot2::last_plot()` to capture the most recently rendered plot. Always check it's a ggplot first.

```r
p <- ggplot2::last_plot()
testthat::expect_s3_class(p, "ggplot")
```

### Plot — aesthetic mappings

Students may place `aes()` at the top level (`ggplot(aes(...))`) or inside a layer (`geom_*(aes(...))`). Use a helper that searches both, so tests pass either way.

```r
# Returns the name mapped to `aesthetic` anywhere in the plot (top-level or any layer).
# Returns NULL if the aesthetic is not mapped anywhere.
get_mapping <- function(p, aesthetic) {
  all_mappings <- c(
    list(p$mapping),
    lapply(p$layers, function(l) l$mapping)
  )
  for (m in all_mappings) {
    val <- m[[aesthetic]]
    if (!is.null(val)) return(rlang::as_name(val))
  }
  NULL
}

testthat::expect_equal(get_mapping(p, "x"),      "col_name")
testthat::expect_equal(get_mapping(p, "y"),      "col_name")
testthat::expect_equal(get_mapping(p, "colour"), "col_name")
testthat::expect_equal(get_mapping(p, "fill"),   "col_name")
```

### Plot — geometry

Check that a required geometry is present.

```r
geom_classes <- sapply(p$layers, function(l) class(l$geom)[1])
testthat::expect_true(any(geom_classes == "GeomPoint"), label = "Plot should use geom_point()")
```

Common geometry class names: `GeomPoint`, `GeomLine`, `GeomBoxplot`, `GeomDensity`, `GeomBar`, `GeomCol`.

### Plot — underlying data

When the exercise requires filtering before plotting, verify the plot data directly.

```r
plot_data <- p$data
testthat::expect_true(
  all(plot_data$some_col == "expected_value"),
  label = "Plot data should be filtered to ..."
)
```

---

## Naming conventions

- Case names follow the pattern `ExNx: short description`, e.g. `Ex1a`, `Ex2c`.
- Setup cases use `SetupN`.
- Labels in `expect_*` calls should be written as student-facing feedback: explain what went wrong and hint at the fix.

---

## What to test (by exercise type)

| Exercise type | Recommended checks |
|---|---|
| Import data | Object exists, is a data frame, has expected columns, has expected row count |
| Filter / mutate | Object exists, is a data frame, row-level invariant holds, row count matches recomputed expectation |
| Summarize / count | Object exists, value equals recomputed expectation |
| ggplot (any) | Plot is a ggplot, correct x/y aesthetics, correct color/fill aesthetic |
| ggplot (geometry matters) | Above + geometry class check |
| ggplot (filter before plot) | Above + plot data invariant |
| Pivot longer/wider | Object exists, is a data frame, expected column names, expected row count |
