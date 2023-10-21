<!DOCTYPE html>
<!-- saved from url=(0076)https://www.gnu.org/software/emacs/manual/html_node/elisp/Sequence-Type.html -->
<html><!-- Created by GNU Texinfo 7.0.3, https://www.gnu.org/software/texinfo/ --><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Sequence Type (GNU Emacs Lisp Reference Manual)</title>

<meta name="description" content="Sequence Type (GNU Emacs Lisp Reference Manual)">
<meta name="keywords" content="Sequence Type (GNU Emacs Lisp Reference Manual)">
<meta name="resource-type" content="document">
<meta name="distribution" content="global">
<meta name="Generator" content="makeinfo">
<meta name="viewport" content="width=device-width,initial-scale=1">

<link rev="made" href="mailto:bug-gnu-emacs@gnu.org">
<link rel="icon" type="image/png" href="https://www.gnu.org/graphics/gnu-head-mini.png">
<meta name="ICBM" content="42.256233,-71.006581">
<meta name="DC.title" content="gnu.org">
<style type="text/css">
@import url('/software/emacs/manual.css');
</style>
</head>

<body lang="en">
<div class="subsection-level-extent" id="Sequence-Type">
<div class="nav-panel">
<p>
Next: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Cons-Cell-Type.html" accesskey="n" rel="next">Cons Cell and List Types</a>, Previous: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Symbol-Type.html" accesskey="p" rel="prev">Symbol Type</a>, Up: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Programming-Types.html" accesskey="u" rel="up">Programming Types</a> &nbsp; [<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html#SEC_Contents" title="Table of contents" rel="contents">Contents</a>][<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Index.html" title="Index" rel="index">Index</a>]</p>
</div>
<hr>
<h4 class="subsection" id="Sequence-Types">2.4.5 Sequence Types</h4>

<p>A <em class="dfn">sequence</em> is a Lisp object that represents an ordered set of
elements.  There are two kinds of sequence in Emacs Lisp: <em class="dfn">lists</em>
and <em class="dfn">arrays</em>.
</p>
<p>Lists are the most commonly-used sequences.  A list can hold
elements of any type, and its length can be easily changed by adding
or removing elements.  See the next subsection for more about lists.
</p>
<p>Arrays are fixed-length sequences.  They are further subdivided into
strings, vectors, char-tables and bool-vectors.  Vectors can hold
elements of any type, whereas string elements must be characters, and
bool-vector elements must be <code class="code">t</code> or <code class="code">nil</code>.  Char-tables are
like vectors except that they are indexed by any valid character code.
The characters in a string can have text properties like characters in
a buffer (see <a class="pxref" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Text-Properties.html">Text Properties</a>), but vectors do not support text
properties, even when their elements happen to be characters.
</p>
<p>Lists, strings and the other array types also share important
similarities.  For example, all have a length <var class="var">l</var>, and all have
elements which can be indexed from zero to <var class="var">l</var> minus one.  Several
functions, called sequence functions, accept any kind of sequence.
For example, the function <code class="code">length</code> reports the length of any kind
of sequence.  See <a class="xref" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Sequences-Arrays-Vectors.html">Sequences, Arrays, and Vectors</a>.
</p>
<p>It is generally impossible to read the same sequence twice, since
sequences are always created anew upon reading.  If you read the read
syntax for a sequence twice, you get two sequences with equal contents.
There is one exception: the empty list <code class="code">()</code> always stands for the
same object, <code class="code">nil</code>.
</p>
</div>
<hr>
<div class="nav-panel">
<p>
Next: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Cons-Cell-Type.html">Cons Cell and List Types</a>, Previous: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Symbol-Type.html">Symbol Type</a>, Up: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Programming-Types.html">Programming Types</a> &nbsp; [<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html#SEC_Contents" title="Table of contents" rel="contents">Contents</a>][<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Index.html" title="Index" rel="index">Index</a>]</p>
</div>





</body></html>