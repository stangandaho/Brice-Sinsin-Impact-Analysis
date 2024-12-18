# Define a function to calculate the angle for text rotation
calc_angle <- function(x) {
  angle <- 90 - 360 * (x - 0.5) / length(x)
  ifelse(angle < -90, angle + 180, angle)
}


