library(ctmm)
library(purrr)
library(dplyr)

rFunction <- function(data) {
  # Ensure all telemetry columns are valid. When ctmm subsets the data it
  # renames invalid names, causing the `rbind()` inside `speed()` to fail
  # with "names do not match previous names"
  telemetry <- map(
    data[[2]],
    function(x) {
      names(x) <- make.names(names(x), unique = TRUE)
      x
    }
  )

  s1 <- map2(
    data[[1]],
    telemetry,
    ~ speed(.x, .y, units = FALSE, trace = FALSE)
  )
  
  # ctmm returns DOF = 0 when it can't estimate speed, usually because the
  # model has no velocity component. Those animals get NA in both files.
  no_estimate <- map_lgl(s1, ~ .x$DOF == 0)
  
  walk(
    names(s1)[no_estimate], 
    function(id) {
      logger.warn(paste0(
        id, 
        ": speed and distance could not be estimated. ",
        "See 'Errors and null handling' in the App documentation."
      ))
    }
  )
  
  xx <- map(s1, ~ {
    if (.$DOF == 0) {
      list("Speed (m/s) ", c(NA, NA, NA))
    } else {
      ci <- signif(.$CI, 4)
      list("Speed (m/s) ", c(ci[2], ci[1], ci[3]))
    }
  })
  
  xx1 <- do.call(rbind, map(xx, 2))
  colnames(xx1) <- c("est", "low", "high")
  xx1 |> as_tibble() |> 
    mutate(id = names(xx), unit = map_chr(xx, 1)) |> 
    select(id, unit, low, est, high) |> 
    write.csv(appArtifactPath("speed.csv"), row.names = FALSE)
  
  duration <- map_dbl(data[[2]], ~ diff(range(.x$t)))
  
  xx <- map(s1, ~ .x$CI)
  xx <- do.call(rbind, xx)
  xx |> as_tibble() |> 
    mutate(id = names(s1)) |> 
    mutate(low = low * duration, est = est * duration, high = high * duration, unit = "distance (meters)") |>
    mutate(across(c(low, est, high), ~ if_else(no_estimate, NA_real_, .x))) |>
    select(id, unit, low, est, high) |>
    write.csv(appArtifactPath("distance.csv"), row.names = FALSE)
  
  return(data)
}
