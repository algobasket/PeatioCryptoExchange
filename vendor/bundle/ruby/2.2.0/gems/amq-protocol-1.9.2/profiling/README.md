# Profiling Scripts

This directory contains profiling scripts. Currently they use [stackprof](https://github.com/tmm1/stackprof) which
requires Ruby 2.1+ (preview2 or later).

## Running the Profiler

    ruby profiling/stackprof/body_framing_with_2k_payload.rb
    stackprof profiling/dumps/body_framing_with_2k_payload.dump --text
