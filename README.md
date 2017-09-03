
[![CircleCI](https://circleci.com/gh/johnboyes/jira-cycle-time.svg?style=svg)](https://circleci.com/gh/johnboyes/jira-cycle-time)
[![Code Climate](https://codeclimate.com/github/johnboyes/jira-cycle-time/badges/gpa.svg)](https://codeclimate.com/github/johnboyes/jira-cycle-time)
[![Test Coverage](https://codeclimate.com/github/johnboyes/jira-cycle-time/badges/coverage.svg)](https://codeclimate.com/github/johnboyes/jira-cycle-time/coverage)
[![Issue Count](https://codeclimate.com/github/johnboyes/jira-cycle-time/badges/issue_count.svg)](https://codeclimate.com/github/johnboyes/jira-cycle-time)
[![Dependency Status](https://gemnasium.com/badges/github.com/johnboyes/jira-cycle-time.svg)](https://gemnasium.com/github.com/johnboyes/jira-cycle-time)


# jira-cycle-time

Export issues' cycle time and other [Control Chart](https://confluence.atlassian.com/agile/glossary/control-chart) data from JIRA.

Cycle time data is very useful for a variety of reporting and forecasting metrics, for instance http://focusedobjective.com/free-tools-resources/

JIRA does provide out of the box [cycle time](https://confluence.atlassian.com/agile/glossary/cycle-time) reporting via its own Control Chart tool, but sadly there is [no official way to export the data](https://jira.atlassian.com/browse/JSWSERVER-4288) through the [JIRA REST API](https://docs.atlassian.com/jira-software/REST/cloud) for 3rd party reporting outside of JIRA.

This Ruby application provides a workaround by accessing the raw data through the "internal" JIRA GreenHopper API, and transforming it into a simple format for export.
