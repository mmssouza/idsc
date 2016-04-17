#!/bin/bash

OCTAVE_INCLUDE=/usr/include/octave-3.8.1/octave/
OCTAVE_LIB=/usr/lib/x86_64-linux-gnu/
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB bellman_ford_ex_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB build_graph_contour_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB dist2_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB DPMatching_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB uniform_interp_C.cpp
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB dist_bw_sc_C.c
mkoctfile --mex -I$OCTAVE_INCLUDE -L$OCTAVE_LIB hist_cost.c
