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
- how much care about being able to pipe tabyl2 into adorn_* or mutate etc?


rounding rules:


what do others do re rounding: 


JAMA: 


