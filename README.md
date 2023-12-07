# AoC2023

My submissions for the [Advent of Code](https://adventofcode.com/) challenge

My first time.
<br>
I'm going to use *javascript*.


### Impressions after Day 3

The puzzles are taking a lot longer than I expected per puzzle. But that is good if my goal is to get faster by practicing every day.

I was ambitious at first and wanted to not only solve the possibles, but do a Web app animation of the solving in progress for each one.
So far I haven't had the time to do one of those each day.

My errors are mostly Off-By-One errors or copy and paste errors like parsing with a split by ';' then split each part by ',' but forgetting to change the ';' to a ',' when I copy paste the outer loop code to 'save typing'

### UPDATE: Day 4

I started using awk. Surprisingly simpler so far.

All variables are global which means very few scope bugs but lots of var name collision bugs. Also means you could never use it for large projects.

Compared to javascript and python the awk code has
 * No imports, but everything you need for a line by line parser
 * All globals so no declarations or types or inits
   * Yes, this causes problems if the code gets large, but much faster (less typing) to make a small parser.
 * No types (not even var/let/const) so no lines wasted typing on a small quick parser.
 * The primary assumption is that you are processing a stream of text where each line is an eol separated Record, each Field is a white space separated string, and each Field is in a consistent position.
   * If that is not the format of your data then awk becomes a poor fit very fast.
 * It will work on an infinite stream of data like a unix pipe. And the file will always get closed properly when done.
   * In javascript and python if you are new it's possible to write file read code that:
     * is memory inefficient (reads the entire file first and will break on pipes)
     * doesn't handle file closing properly
     * doesn't handle file read errors properly
