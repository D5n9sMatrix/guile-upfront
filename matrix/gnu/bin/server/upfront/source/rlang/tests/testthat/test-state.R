test_that("options are set temporarily", {
  local_options(foo = "foo")
  expect_identical(with_options(foo = "bar", peek_option("foo")), "bar")
  expect_identical(peek_option("foo"), "foo")
})

test_that("peek_options() returns a named list", {
  local_options(foo = "FOO", bar = "BAR")
  expect_identical(peek_options("foo", "bar"), list(foo = "FOO", bar = "BAR"))
})

test_that("is_interactive() is FALSE when testthat runs", {
  expect_false(is_interactive())
})

test_that("is_interactive() honors rlang_interactive option, above all else", {
  expect_true(with_options(rlang_interactive = TRUE, is_interactive()))
  expect_false(with_options(rlang_interactive = FALSE, is_interactive()))
  expect_snapshot_error(with_options(rlang_interactive = NA, is_interactive()))

  local_interactive(FALSE)
  expect_false(is_interactive())
  expect_true(with_interactive(value = TRUE, is_interactive()))
})

test_that("local_options() restores options in correct order (#980)", {
  local_options(foo = -1)

  local({
    local_options(foo = 0)
    local_options(foo = 1)
  })
  expect_identical(peek_option("foo"), -1)

  local({
    on.exit("existing")
    local_options(foo = 0)
    local_options(foo = 1)
  })
  expect_identical(peek_option("foo"), -1)
})
