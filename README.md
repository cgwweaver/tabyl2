(WORK IN PROGRESS)

# tabyl2

Trying to improve the R function janitor::tabyl().

Current status:
- brainstormed some design ideas
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



easiest incorp into janitor::tabyl() (eg keeping backwards compatibility):
- print opts - esp pillar

rounding rules:



how much care about being able to pipe tabyl2 into adorn_* or mutate etc?


