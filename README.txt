(WORK IN PROGRESS)

# tabyl2

Trying to improve the R function janitor::tabyl().

Current status:
- brainstormed ideas (design.txt)
- implemented some of them into a function that was working but currently broken (tabyl2.R)

Next steps:
- find if others have forked or tried to improve tabyl()
- get a working function (start from scratch?)
- add testthat suite?
- expand design ideas?

Later steps:
- day-to-day testing: use tabyl2() instead of tabyl() in all my R projects, for data exploration/checks (not production)
- possibly make into an actual package, roxygen/DESCRIPTION/etc, perhaps only if/when sharing it with others
- approach janitor maintainers re incorporate some ideas into janitor::tabyl()? and/or collab on a tabyl2()??
  - seems like janitor maintainers don't have much time to spend on janitor?



Links:
- https://github.com/sfirke/tabyl
- https://github.com/sfirke/janitor
- https://github.com/pyjanitor-devs/pyjanitor

sfirke planning on splitting off tabyl from janitor?
going to submit tabyl to CRAN/remove tabyl() from janitor on CRAN?

