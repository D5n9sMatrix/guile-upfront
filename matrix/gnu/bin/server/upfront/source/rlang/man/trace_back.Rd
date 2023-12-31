% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trace.R
\name{trace_back}
\alias{trace_back}
\alias{trace_length}
\title{Capture a backtrace}
\usage{
trace_back(top = NULL, bottom = NULL)

trace_length(trace)
}
\arguments{
\item{top}{The first frame environment to be included in the
backtrace. This becomes the top of the backtrace tree and
represents the oldest call in the backtrace.

This is needed in particular when you call \code{trace_back()}
indirectly or from a larger context, for example in tests or
inside an RMarkdown document where you don't want all of the
knitr evaluation mechanisms to appear in the backtrace.

If not supplied, the \code{rlang_trace_top_env} global option is
consulted. This makes it possible to trim the embedding context
for all backtraces created while the option is set. If knitr is
in progress, the default value for this option is
\code{knitr::knit_global()} so that the knitr context is trimmed out
of backtraces.}

\item{bottom}{The last frame environment to be included in the
backtrace. This becomes the rightmost leaf of the backtrace tree
and represents the youngest call in the backtrace.

Set this when you would like to capture a backtrace without the
capture context.

Can also be an integer that will be passed to \code{\link[=caller_env]{caller_env()}}.}

\item{trace}{A backtrace created by \code{trace_back()}.}
}
\description{
A backtrace captures the sequence of calls that lead to the current
function (sometimes called the call stack). Because of lazy
evaluation, the call stack in R is actually a tree, which the
\code{print()} method for this object will reveal.

Users rarely need to call \code{trace_back()} manually. Instead,
signalling an error with \code{\link[=abort]{abort()}} or setting up \code{\link[=global_entrace]{global_entrace()}}
is the most common way to create backtraces when an error is
thrown. Inspect the backtrace created for the most recent error
with \code{\link[=last_error]{last_error()}}.

\code{trace_length()} returns the number of frames in a backtrace.
}
\examples{
# Trim backtraces automatically (this improves the generated
# documentation for the rlang website and the same trick can be
# useful within knitr documents):
options(rlang_trace_top_env = current_env())

f <- function() g()
g <- function() h()
h <- function() trace_back()

# When no lazy evaluation is involved the backtrace is linear
# (i.e. every call has only one child)
f()

# Lazy evaluation introduces a tree like structure
identity(identity(f()))
identity(try(f()))
try(identity(f()))

# When printing, you can request to simplify this tree to only show
# the direct sequence of calls that lead to `trace_back()`
x <- try(identity(f()))
x
print(x, simplify = "branch")

# With a little cunning you can also use it to capture the
# tree from within a base NSE function
x <- NULL
with(mtcars, {x <<- f(); 10})
x


# Restore default top env for next example
options(rlang_trace_top_env = NULL)

# When code is executed indirectly, i.e. via source or within an
# RMarkdown document, you'll tend to get a lot of guff at the beginning
# related to the execution environment:
conn <- textConnection("summary(f())")
source(conn, echo = TRUE, local = TRUE)
close(conn)

# To automatically strip this off, specify which frame should be
# the top of the backtrace. This will automatically trim off calls
# prior to that frame:
top <- current_env()
h <- function() trace_back(top)

conn <- textConnection("summary(f())")
source(conn, echo = TRUE, local = TRUE)
close(conn)
}
