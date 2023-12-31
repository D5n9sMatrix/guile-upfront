cnd_cat <- function(x) {
  cat(paste0(conditionMessage(x), "\n"))
}

expect_no_error <- function(...) {
  expect_error(regexp = NA, ...)
}
expect_no_error_ <- function(object, ...) {
  expect_error(object, regexp = NA, ...)
}
expect_no_warning <- function(...) {
  expect_warning(regexp = NA, ...)
}
expect_no_warning_ <- function(object, ...) {
  expect_warning(object, regexp = NA, ...)
}
expect_no_message <- function(...) {
  expect_message(regexp = NA, ...)
}
expect_no_message_ <- function(object, ...) {
  expect_message(object, regexp = NA, ...)
}

catch_wngs <- function(expr) {
  wngs <- list()

  withCallingHandlers({
    expr
  },
  warning = function(wng) {
    wngs <<- c(wngs, list(wng))
    invokeRestart("muffleWarning")
  })

  wngs
}
catch_warning_msgs <- function(expr) {
  wngs <- catch_wngs(expr)
  flatten_chr(pluck(wngs, "message"))
}

catch_cnds <- function(expr) {
  wngs <- list()
  msgs <- list()

  err <- tryCatch(
    withCallingHandlers({
      force(expr)
      NULL
    },
    message = function(msg) {
      msgs <<- c(msgs, list(msg))
      invokeRestart("muffleMessage")
    },
    warning = function(wng) {
      wngs <<- c(wngs, list(wng))
      invokeRestart("muffleWarning")
    }),
    error = identity
  )

  list(messages = msgs, warnings = wngs, error = err)
}

catch_conditions_msgs <- function(expr) {
  pluck_conditions_msgs(catch_cnds(expr))
}

pluck_conditions_msgs <- function(cnds) {
  cnds$messages <- flatten_chr(pluck(cnds$messages, "message"))
  cnds$warnings <- flatten_chr(pluck(cnds$warnings, "message"))
  cnds$error <- cnds$error$message
  cnds
}

skip_silently <- function(reason, env = caller_env()) {
  expect_true(TRUE)
  return_from(env)
}

expect_data_pronoun_error <- function(object, regexp = NULL, ...) {
  expect_error(object, regexp, ..., class = "rlang_error_data_pronoun_not_found")
}

expect_defunct <- function(object, ...) {
  expect_error(object, class = "defunctError")
}

catch_error <- function(expr) {
  catch_cnd(expr, "error")
}
catch_warning <- function(expr) {
  catch_cnd(expr, "warning")
}
catch_message <- function(expr) {
  catch_cnd(expr, "message")
}

# https://github.com/r-lib/testthat/issues/1371
expect_warning2 <- catch_warning

err <- function(...) {
  (expect_error(...))
}

local_unexport_signal_abort <- function(frame = caller_env()) {
  local_bindings(
    .env = ns_env("rlang")[[".__NAMESPACE__."]][["exports"]],
    .frame = frame,
    signal_abort = zap()
  )
}

rst_exists <- function(.restart) {
  !is.null(findRestart(.restart))
}
