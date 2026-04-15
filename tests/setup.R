test = list(
  name = "setup",
  cases = list(
    ottr::TestCase$new(
      name = "Setup1a: oni exists",
      code = {
        testthat::expect_true(
          exists("oni", envir = .GlobalEnv),
          label = "'oni' not found — assign the imported CSV to 'oni'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Setup1b: oni is a data frame",
      code = {
        oni <- get0("oni", envir = .GlobalEnv)
        testthat::expect_s3_class(oni, "data.frame")
      }
    ),
    ottr::TestCase$new(
      name = "Setup1c: oni has expected columns",
      code = {
        oni <- get0("oni", envir = .GlobalEnv)
        testthat::expect_true(
          all(c("year", "1", "2", "3", "4", "5", "6",
                "7", "8", "9", "10", "11", "12") %in% names(oni)),
          label = "oni is missing expected columns — check that you imported data/oni.csv"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Setup1d: oni has expected row count",
      code = {
        oni <- get0("oni", envir = .GlobalEnv)
        testthat::expect_equal(nrow(oni), 6L)
      }
    ),
    ottr::TestCase$new(
      name = "Setup2a: bluewhales exists",
      code = {
        testthat::expect_true(
          exists("bluewhales", envir = .GlobalEnv),
          label = "'bluewhales' not found — assign the imported CSV to 'bluewhales'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Setup2b: bluewhales is a data frame",
      code = {
        bluewhales <- get0("bluewhales", envir = .GlobalEnv)
        testthat::expect_s3_class(bluewhales, "data.frame")
      }
    ),
    ottr::TestCase$new(
      name = "Setup2c: bluewhales has expected columns",
      code = {
        bluewhales <- get0("bluewhales", envir = .GlobalEnv)
        testthat::expect_true(
          all(c("species", "eventDate", "decimalLatitude", "decimalLongitude") %in% names(bluewhales)),
          label = "bluewhales is missing expected columns — check that you imported data/bluewhales.csv"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Setup2d: bluewhales has expected row count",
      code = {
        bluewhales <- get0("bluewhales", envir = .GlobalEnv)
        testthat::expect_equal(nrow(bluewhales), 514L)
      }
    )
  )
)
