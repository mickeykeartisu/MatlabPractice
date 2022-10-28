## Copyright (C) 1995-2016 Andreas Weingessel
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {} {} hanning (@var{m})
## @deftypefnx {} {} hanning (@var{m}, "periodic")
## @deftypefnx {} {} hanning (@var{m}, "symmetric")
## Return the filter coefficients of a Hanning window of length @var{m}.
##
## If the optional argument @qcode{"periodic"} is given, the periodic form
## of the window is returned.  This is equivalent to the window of length
## @var{m}+1 with the last coefficient removed.  The optional argument
## @qcode{"symmetric"} is equivalent to not specifying a second argument.
##
## For a definition of the Hanning window see, e.g.,
## @nospell{A.V. Oppenheim & R. W. Schafer},
## @cite{Discrete-Time Signal Processing}.
## @end deftypefn

## Author: AW <Andreas.Weingessel@ci.tuwien.ac.at>
## Description: Coefficients of the Hanning window

function c = hanning (m, opt)

  if (nargin < 1 || nargin > 2)
    print_usage ();
  endif

  if (! (isscalar (m) && (m == fix (m)) && (m > 0)))
    error ("hanning: M must be a positive integer");
  endif

  st = 1;
  N = m + 1;
  if (nargin == 2)
    switch (opt)
      case "periodic"
        st = 0;
        N = m;
        m -= 1;
      case "symmetric"
        ## Default option, same as no option specified.
      otherwise
        error ('hanning: window type must be either "periodic" or "symmetric"');
    endswitch
  endif

  if (m == 1)
    c = 1;
  else
    c = 0.5 - 0.5 * cos (2 * pi * (st : m)' / N);
  endif

endfunction
