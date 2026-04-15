test = list(
  name = "ex2",
  cases = list(
    ottr::TestCase$new(
      name = "Ex2a: monthly_whales exists",
      code = {
        testthat::expect_true(
          exists("monthly_whales", envir = .GlobalEnv),
          label = "'monthly_whales' not found — assign your summarized result to 'monthly_whales'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex2b: monthly_whales is a data frame",
      code = {
        monthly_whales <- get0("monthly_whales", envir = .GlobalEnv)
        testthat::expect_s3_class(monthly_whales, "data.frame")
      }
    ),
    ottr::TestCase$new(
      name = "Ex2c: monthly_whales has expected columns",
      code = {
        monthly_whales <- get0("monthly_whales", envir = .GlobalEnv)
        testthat::expect_true(
          all(c("year", "month", "n_whales") %in% names(monthly_whales)),
          label = "monthly_whales is missing expected columns — use year, month, and n_whales as column names"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex2d: monthly_whales has expected row count",
      code = {
        bluewhales <- get0("bluewhales", envir = .GlobalEnv)
        monthly_whales <- get0("monthly_whales", envir = .GlobalEnv)
        testthat::expect_equal(
          nrow(monthly_whales),
          nrow(dplyr::distinct(
            dplyr::mutate(bluewhales,
                          year = lubridate::year(eventDate),
                          month = lubridate::month(eventDate)),
            year, month
          )),
          label = "Unexpected row count — check that you're grouping by both year and month"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex2e: n_whales reflects observation counts",
      code = {
        bluewhales <- get0("bluewhales", envir = .GlobalEnv)
        monthly_whales <- get0("monthly_whales", envir = .GlobalEnv)
        testthat::expect_equal(
          sum(monthly_whales$n_whales),
          nrow(bluewhales),
          label = "Total n_whales should equal the number of rows in bluewhales — check your summarize(n_whales = n())"
        )
      }
    )
  )
)
