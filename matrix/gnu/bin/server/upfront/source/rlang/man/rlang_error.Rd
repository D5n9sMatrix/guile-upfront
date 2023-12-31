% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnd.R
\name{rlang_error}
\alias{rlang_error}
\title{Errors of class \code{rlang_error}}
\description{
\code{\link[=abort]{abort()}} and \code{\link[=error_cnd]{error_cnd()}} create errors of class \code{"rlang_error"}.
The differences with base errors are:
\itemize{
\item Implementing \code{conditionMessage()} methods for subclasses of
\code{"rlang_error"} is undefined behaviour. Instead, implement the
\code{\link[=cnd_header]{cnd_header()}} method (and possibly \code{\link[=cnd_body]{cnd_body()}} and
\code{\link[=cnd_footer]{cnd_footer()}}). These methods return character vectors which are
assembled by rlang when needed: when
\code{\link[=conditionMessage]{conditionMessage.rlang_error()}} is called
(e.g. via \code{\link[=try]{try()}}), when the error is displayed through \code{\link[=print]{print()}}
or \code{\link[=format]{format()}}, and of course when the error is displayed to the
user by \code{\link[=abort]{abort()}}.
\item \code{\link[=cnd_header]{cnd_header()}}, \code{\link[=cnd_body]{cnd_body()}}, and \code{\link[=cnd_footer]{cnd_footer()}} methods can be
overridden by storing closures in the \code{header}, \code{body}, and
\code{footer} fields of the condition. This is useful to lazily
generate messages based on state captured in the closure
environment.
\item \ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}} The \code{use_cli_format}
condition field instructs whether to use cli (or rlang's fallback
method if cli is not installed) to format the error message at
print time.

In this case, the \code{message} field may be a character vector of
header and bullets. These are formatted at the last moment to
take the context into account (starting position on the screen
and indentation).

See \code{\link[=local_use_cli]{local_use_cli()}} for automatically setting this field in
errors thrown with \code{\link[=abort]{abort()}} within your package.
}
}
