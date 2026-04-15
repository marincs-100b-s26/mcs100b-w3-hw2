test = list(
  name = "ex4",
  cases = list(
    ottr::TestCase$new(
      name = "Ex4a: a plot was created",
      code = {
        p <- ggplot2::last_plot()
        testthat::expect_s3_class(p, "ggplot")
      }
    ),
    ottr::TestCase$new(
      name = "Ex4b: plot uses oni on x-axis",
      code = {
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
        p <- ggplot2::last_plot()
        testthat::expect_equal(
          get_mapping(p, "x"), "oni",
          label = "x aesthetic should be mapped to 'oni'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex4c: plot uses n_whales on y-axis",
      code = {
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
        p <- ggplot2::last_plot()
        testthat::expect_equal(
          get_mapping(p, "y"), "n_whales",
          label = "y aesthetic should be mapped to 'n_whales'"
        )
      }
    ),
    ottr::TestCase$new(
      name = "Ex4d: plot uses geom_point()",
      code = {
        p <- ggplot2::last_plot()
        geom_classes <- sapply(p$layers, function(l) class(l$geom)[1])
        testthat::expect_true(
          any(geom_classes == "GeomPoint"),
          label = "Plot should use geom_point() for the scatter plot"
        )
      }
    )
  )
)
