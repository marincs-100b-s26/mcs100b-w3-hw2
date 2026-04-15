test = list(
  name = "ex1",
  cases = list(
    ottr::TestCase$new(
      name = "Ex1a: oni_long exists",
      code = {
        testthat::expect_true(
          exists("oni_long", envir = .GlobalEnv),
          label = "'oni_long' not found — assign your pivoted result to 'oni_long'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex1b: oni_long is a data frame",
      code = {
        oni_long <- get0("oni_long", envir = .GlobalEnv)
        testthat::expect_s3_class(oni_long, "data.frame")
      }
    ),
    ottr::TestCase$new(
      name = "Ex1c: oni_long has expected columns",
      code = {
        oni_long <- get0("oni_long", envir = .GlobalEnv)
        testthat::expect_true(
          all(c("year", "month", "oni") %in% names(oni_long)),
          label = "oni_long is missing expected columns — use names_to = 'month' and values_to = 'oni'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex1d: oni_long has expected row count",
      code = {
        oni_long <- get0("oni_long", envir = .GlobalEnv)
        testthat::expect_equal(
          nrow(oni_long), 72L,
          label = "Unexpected row count — pivot_longer should produce one row per year-month combination (6 years × 12 months = 72)"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex1e: month column is numeric",
      code = {
        oni_long <- get0("oni_long", envir = .GlobalEnv)
        testthat::expect_true(
          is.numeric(oni_long$month),
          label = "The month column should be numeric — make sure the mutate(month = as.numeric(month)) call is included"
        )
      }
    )
  )
)
