test = list(
  name = "ex3",
  cases = list(
    ottr::TestCase$new(
      name = "Ex3a: oni_whales exists",
      code = {
        testthat::expect_true(
          exists("oni_whales", envir = .GlobalEnv),
          label = "'oni_whales' not found — assign your joined result to 'oni_whales'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex3b: oni_whales is a data frame",
      code = {
        oni_whales <- get0("oni_whales", envir = .GlobalEnv)
        testthat::expect_s3_class(oni_whales, "data.frame")
      }
    ),
    ottr::TestCase$new(
      name = "Ex3c: oni_whales has expected columns",
      code = {
        oni_whales <- get0("oni_whales", envir = .GlobalEnv)
        testthat::expect_true(
          all(c("year", "month", "oni", "n_whales") %in% names(oni_whales)),
          label = "oni_whales is missing expected columns — the join should produce year, month, oni, and n_whales"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex3d: oni_whales row count matches oni_long",
      code = {
        oni_long <- get0("oni_long", envir = .GlobalEnv)
        oni_whales <- get0("oni_whales", envir = .GlobalEnv)
        testthat::expect_equal(
          nrow(oni_whales),
          nrow(oni_long),
          label = "Unexpected row count — a left join on oni_long should keep all rows from oni_long"
        )
      }
    )
  )
)
