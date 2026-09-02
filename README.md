(WORK IN PROGRESS)

# tabyl2

Trying to improve the R function janitor::tabyl().

Current status:
- brainstormed some design ideas ([design.txt])
- implemented some of them into a semi working function

Next steps:
- expand design ideas
- get function working
- add testthat suite?

Later steps:
- test it by using tabyl2() instead of tabyl() in all my day-to-day R coding
- approach janitor author/maintainers? Re incorporate some ideas into janitor::tabyl()?


# design.txt

others have forked or tried to improve on tabyl()?

overall design goals:
- modernize(?) eg tibble, pillar

smaller goals:
- some adorn opts in tabyl()
- auto display col var (2/3-way)
- better 3-way 3rd var printing
- change 3-way var ordering? think more about this
- display fewer digits in pct cols (1-way)

easiest incorp into janitor::tabyl() (eg keeping backwards compatibility):
- print opts - esp pillar


ponder:
- how much care about being able to pipe tabyl2 into adorn_*, mutate etc? (ie stays df/tbl). elimated if only modding print dispatch!!


## pct rounding rules

I want:
default:
100, >99.9, 99.9, .., 98.5, 98, ..., 10, 9.5, .., 0.1, 0.09, .., 0.01, <0.01, 0
questioning: instead 2, 1.5? (mirrors 98.5, 98). but often care 1.5 vs 2.5?
in words:
  100, 0 iff exactly (ie count is all/none)
  >/< if above/below 99.9/0.01 (not 99.95/0.005)
  transitions digits/sig figs: 98.5-98, 10-9.5 (dig), 1.0-0.9 (sig), 0.1-0.09 (dig)
  (sig figs make sense/defined near 100?)

rationale:
  display 99, 9, wo decimals feels wrong (too imprecise)
  precision usually more important pcts close to 0 vs 100 
  don't want possible see a number displayed diff ways: eg 1, 1.0


digits +/-:


what do others do re rounding: 
pillar: 
JAMA: 


